#!/usr/bin/env bash
# Collect source-backed repository facts for repo-showcase.
# Usage: bash analyze-repo.sh [target-repo] [--output /path/to/facts.json]
set -euo pipefail

TARGET="."
OUTPUT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --output)
      [[ $# -ge 2 ]] || { echo "--output needs a path" >&2; exit 2; }
      OUTPUT="$2"
      shift 2
      ;;
    -h|--help)
      sed -n '2,3p' "$0"
      exit 0
      ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 2
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

[[ -d "$TARGET" ]] || { echo "Target repository does not exist: $TARGET" >&2; exit 2; }
TARGET=$(cd "$TARGET" && pwd -P)
OUTPUT=${OUTPUT:-"$TARGET/.repo-showcase/facts.json"}
mkdir -p "$(dirname "$OUTPUT")"

remote=$(git -C "$TARGET" config --get remote.origin.url 2>/dev/null || true)
readme=""
for candidate in README.md readme.md Readme.md README.rst README; do
  if [[ -f "$TARGET/$candidate" ]]; then readme="$candidate"; break; fi
done

# Network metadata is deliberately opt-in: the skill must work in offline and private repos.
remote_description=""
if [[ "${PROJECT_SHOWCASE_FETCH_REMOTE:-0}" == "1" && "$remote" == *github.com* ]] && command -v curl >/dev/null; then
  slug=$(printf '%s' "$remote" | sed -E 's#.*github.com[:/]##; s/\.git$//')
  remote_description=$(curl --connect-timeout 3 --max-time 8 -fsS "https://api.github.com/repos/$slug" 2>/dev/null \
    | python3 -c "import json,sys; print(json.load(sys.stdin).get('description') or '')" 2>/dev/null || true)
fi

TARGET="$TARGET" OUTPUT="$OUTPUT" REMOTE="$remote" README_PATH="$readme" REMOTE_DESCRIPTION="$remote_description" python3 - <<'PY'
import json
import os
import re
from pathlib import Path

root = Path(os.environ["TARGET"])
output = Path(os.environ["OUTPUT"])
readme_name = os.environ["README_PATH"]
remote = os.environ["REMOTE"]
remote_description = os.environ["REMOTE_DESCRIPTION"]
image_suffixes = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg", ".avif"}
manifests = [
    "package.json", "pyproject.toml", "setup.py", "Cargo.toml", "go.mod", "pom.xml",
    "build.gradle", "build.gradle.kts", "Gemfile", "requirements.txt", "Makefile", "Dockerfile",
]
lockfiles = ["pnpm-lock.yaml", "yarn.lock", "package-lock.json", "bun.lockb", "uv.lock", "poetry.lock", "Cargo.lock", "go.sum"]

def source(field, value, path, line=None):
    entry = {"field": field, "value": value, "source": path}
    if line is not None:
        entry["line"] = line
    return entry

sources = [source("project_name", root.name, ".")]
description = remote_description
if remote_description:
    sources.append(source("description", remote_description, "GitHub API (opt-in)"))

package_path = root / "package.json"
if package_path.exists():
    try:
        package = json.loads(package_path.read_text(encoding="utf-8"))
        if package.get("name"):
            sources.append(source("package_name", package["name"], "package.json"))
        if not description and package.get("description"):
            description = package["description"]
            sources.append(source("description", description, "package.json"))
    except (OSError, json.JSONDecodeError):
        pass

pyproject = root / "pyproject.toml"
if not description and pyproject.exists():
    for number, line in enumerate(pyproject.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
        match = re.match(r"\s*description\s*=\s*[\"'](.+?)[\"']\s*$", line)
        if match:
            description = match.group(1)
            sources.append(source("description", description, "pyproject.toml", number))
            break

readme_headings = []
if readme_name:
    readme_path = root / readme_name
    for number, line in enumerate(readme_path.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
        heading = re.match(r"^(#{1,3})\s+(.+?)\s*$", line)
        if heading:
            text = heading.group(2).strip()
            readme_headings.append({"text": text, "level": len(heading.group(1)), "line": number})
            if not description and len(heading.group(1)) == 1:
                continue
        if not description and line.strip() and not line.startswith(("#", "```", "!", "[")):
            description = line.strip()
            sources.append(source("description", description, readme_name, number))
            break

assets = []
for path in root.rglob("*"):
    if not path.is_file() or path.suffix.lower() not in image_suffixes:
        continue
    if any(part in {".git", "node_modules", "vendor", ".repo-showcase"} for part in path.parts):
        continue
    assets.append(str(path.relative_to(root)))

facts = {
    "schema_version": 1,
    "repository": {"path": str(root), "name": root.name, "remote": remote or None},
    "description": description or None,
    "manifests": [name for name in manifests if (root / name).is_file()],
    "lockfiles": [name for name in lockfiles if (root / name).is_file()],
    "readme": {"path": readme_name or None, "headings": readme_headings},
    "assets": sorted(assets),
    "sources": sources,
    "notes": [
        "Treat this manifest as an index, not proof of a marketing claim.",
        "Before publishing copy, map each claim to a source file and line, or omit it.",
    ],
}
output.write_text(json.dumps(facts, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
PY

printf 'Facts written: %s\n' "$OUTPUT"
python3 - "$OUTPUT" <<'PY'
import json
import sys
facts = json.load(open(sys.argv[1], encoding="utf-8"))
print(f"Project: {facts['repository']['name']}")
print(f"Description: {facts['description'] or 'not found'}")
print(f"Manifests: {', '.join(facts['manifests']) or 'none'}")
print(f"Assets: {len(facts['assets'])}")
print(f"README: {facts['readme']['path'] or 'not found'}")
PY
