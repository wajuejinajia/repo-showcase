#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
FIXTURE="$ROOT/tests/fixtures/node-project"
OUTPUT=$(mktemp -d)/facts.json
trap 'rm -rf "${OUTPUT%/*}"' EXIT

bash "$ROOT/scripts/analyze-repo.sh" "$FIXTURE" --output "$OUTPUT" >/dev/null
python3 - "$OUTPUT" <<'PY'
import json
import sys
facts = json.load(open(sys.argv[1], encoding="utf-8"))
assert facts["repository"]["name"] == "node-project"
assert facts["description"] == "A fixture project for repository analysis tests."
assert facts["manifests"] == ["package.json"]
assert facts["assets"] == ["public/logo.svg"]
assert facts["readme"]["headings"][1]["text"] == "Features"
assert any(item["field"] == "description" and item["source"] == "package.json" for item in facts["sources"])
PY
echo "test_analyze_repo: PASS"
