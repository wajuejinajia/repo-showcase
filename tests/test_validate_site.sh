#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/.." && pwd -P)
python3 "$ROOT/scripts/validate-site.py" "$ROOT/tests/fixtures/site-valid" >/dev/null
if python3 "$ROOT/scripts/validate-site.py" "$ROOT/tests/fixtures/site-invalid" >/dev/null 2>&1; then
  echo "Invalid site unexpectedly passed validation" >&2
  exit 1
fi
echo "test_validate_site: PASS"
