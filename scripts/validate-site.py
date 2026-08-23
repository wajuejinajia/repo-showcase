#!/usr/bin/env python3
"""Validate a dependency-free repo-showcase HTML site using only Python's standard library."""
from __future__ import annotations

import argparse
import re
import sys
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlparse


class SiteParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.tags: list[tuple[str, dict[str, str]]] = []
        self.ids: list[str] = []
        self.title = ""
        self._in_title = False

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        values = {key: value or "" for key, value in attrs}
        self.tags.append((tag, values))
        if values.get("id"):
            self.ids.append(values["id"])
        if tag == "title":
            self._in_title = True

    def handle_endtag(self, tag: str) -> None:
        if tag == "title":
            self._in_title = False

    def handle_data(self, data: str) -> None:
        if self._in_title:
            self.title += data


def is_external(value: str) -> bool:
    return value.startswith("//") or urlparse(value).scheme in {"http", "https"}


def check_resource(site_root: Path, html_file: Path, value: str, errors: list[str], allow_external: bool) -> None:
    if not value or value.startswith(("#", "data:", "mailto:", "tel:", "javascript:")):
        return
    if is_external(value):
        if not allow_external:
            errors.append(f"external resource/link is not allowed: {value}")
        return
    path_part = unquote(value.split("#", 1)[0].split("?", 1)[0])
    if not path_part:
        return
    candidate = (site_root / path_part.lstrip("/")) if path_part.startswith("/") else (html_file.parent / path_part)
    if not candidate.resolve().is_relative_to(site_root.resolve()):
        errors.append(f"resource escapes site directory: {value}")
    elif not candidate.exists():
        errors.append(f"missing local resource: {value}")


def validate(path: Path, allow_external: bool) -> list[str]:
    html_file = path / "index.html" if path.is_dir() else path
    errors: list[str] = []
    if not html_file.is_file():
        return [f"index file not found: {html_file}"]
    if html_file.stat().st_size > 150 * 1024:
        errors.append("index.html exceeds the 150 KB default size budget")
    content = html_file.read_text(encoding="utf-8", errors="replace")
    if re.search(r"\{\{[^}]+\}\}", content):
        errors.append("unresolved template placeholder found")
    parser = SiteParser()
    parser.feed(content)
    html_tags = [attrs for tag, attrs in parser.tags if tag == "html"]
    if not html_tags or not html_tags[0].get("lang"):
        errors.append("html lang attribute is required")
    if not parser.title.strip():
        errors.append("non-empty title is required")
    if not any(tag == "meta" and attrs.get("name") == "description" and attrs.get("content") for tag, attrs in parser.tags):
        errors.append("meta description is required")
    if not any(tag == "meta" and attrs.get("name") == "viewport" for tag, attrs in parser.tags):
        errors.append("viewport meta tag is required")
    duplicate_ids = {item for item in parser.ids if parser.ids.count(item) > 1}
    for item in sorted(duplicate_ids):
        errors.append(f"duplicate id: {item}")
    ids = set(parser.ids)
    site_root = html_file.parent
    for tag, attrs in parser.tags:
        if tag == "img" and not attrs.get("alt"):
            errors.append(f"image without alt text: {attrs.get('src', '(no src)')}")
        for key in ("src", "href"):
            if key in attrs:
                check_resource(site_root, html_file, attrs[key], errors, allow_external)
        href = attrs.get("href", "")
        if href.startswith("#") and href[1:] and href[1:] not in ids:
            errors.append(f"fragment target does not exist: {href}")
    return errors


def main() -> int:
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("site", type=Path, help="site directory or HTML file")
    cli.add_argument("--allow-external", action="store_true", help="allow HTTP(S) links and resources")
    args = cli.parse_args()
    errors = validate(args.site, args.allow_external)
    if errors:
        print("Site validation failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print("Site validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
