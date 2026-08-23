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


def local_target(site_root: Path, html_file: Path, value: str) -> Path | None:
    path_part = unquote(value.split("#", 1)[0].split("?", 1)[0])
    if not path_part:
        return html_file
    candidate = (site_root / path_part.lstrip("/")) if path_part.startswith("/") else (html_file.parent / path_part)
    if candidate.is_dir():
        candidate = candidate / "index.html"
    return candidate


def check_resource(site_root: Path, html_file: Path, value: str, errors: list[str], allow_external: bool) -> None:
    if not value or value.startswith(("#", "data:", "mailto:", "tel:", "javascript:")):
        return
    if is_external(value):
        if not allow_external:
            errors.append(f"external resource/link is not allowed: {value}")
        return
    candidate = local_target(site_root, html_file, value)
    if candidate is None:
        return
    root = site_root.resolve()
    if not candidate.resolve().is_relative_to(root):
        errors.append(f"resource escapes site directory: {value}")
    elif not candidate.exists():
        errors.append(f"missing local resource: {value}")


def validate_page(
    site_root: Path,
    html_file: Path,
    parser: SiteParser,
    page_parsers: dict[Path, SiteParser],
    allow_external: bool,
) -> list[str]:
    errors: list[str] = []
    if html_file.stat().st_size > 150 * 1024:
        errors.append("index.html exceeds the 150 KB default size budget")
    content = html_file.read_text(encoding="utf-8", errors="replace")
    if re.search(r"\{\{[^}]+\}\}", content):
        errors.append("unresolved template placeholder found")
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
    for tag, attrs in parser.tags:
        if tag == "img" and not attrs.get("alt"):
            errors.append(f"image without alt text: {attrs.get('src', '(no src)')}")
        for key in ("src", "href"):
            if key in attrs:
                check_resource(site_root, html_file, attrs[key], errors, allow_external)
        href = attrs.get("href", "")
        if not href or is_external(href) or href.startswith(("mailto:", "tel:", "javascript:", "data:")):
            continue
        if href.startswith("#"):
            fragment = href[1:]
            if fragment and fragment not in ids:
                errors.append(f"fragment target does not exist: {href}")
            continue
        if "#" in href:
            fragment = href.split("#", 1)[1]
            target = local_target(site_root, html_file, href)
            target_parser = page_parsers.get(target.resolve()) if target else None
            if fragment and target_parser and fragment not in set(target_parser.ids):
                errors.append(f"fragment target does not exist: {href}")
    return errors


def validate(path: Path, allow_external: bool, all_pages: bool) -> list[str]:
    path = path.resolve()
    if path.is_dir():
        html_files = sorted(path.rglob("*.html")) if all_pages else [path / "index.html"]
        site_root = path
    else:
        html_files = [path]
        site_root = path.parent
    if not html_files or any(not item.is_file() for item in html_files):
        missing = next((str(item) for item in html_files if not item.is_file()), str(path))
        return [f"index file not found: {missing}"]

    page_parsers: dict[Path, SiteParser] = {}
    errors: list[str] = []
    for html_file in html_files:
        parser = SiteParser()
        try:
            parser.feed(html_file.read_text(encoding="utf-8", errors="replace"))
        except Exception as exc:
            errors.append(f"{html_file.relative_to(site_root)}: HTML parsing failed: {exc}")
        page_parsers[html_file.resolve()] = parser
    for html_file in html_files:
        parser = page_parsers[html_file.resolve()]
        page_errors = validate_page(site_root, html_file, parser, page_parsers, allow_external)
        label = str(html_file.relative_to(site_root))
        errors.extend(f"{label}: {error}" for error in page_errors)
    return errors


def main() -> int:
    cli = argparse.ArgumentParser(description=__doc__)
    cli.add_argument("site", type=Path, help="site directory or HTML file")
    cli.add_argument("--all", action="store_true", help="validate every HTML page below a site directory")
    cli.add_argument("--allow-external", action="store_true", help="allow HTTP(S) links and resources")
    args = cli.parse_args()
    errors = validate(args.site, args.allow_external, args.all)
    if errors:
        print("Site validation failed:", file=sys.stderr)
        for error in errors:
            print(f"- {error}", file=sys.stderr)
        return 1
    print("Site validation passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
