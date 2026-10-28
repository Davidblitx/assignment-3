#!/usr/bin/env bash
set -u
cd "$(dirname "$0")/.." || exit 1
fail=0
for f in README.md app/app.sh scripts/lint.sh scripts/build.sh tests/test.sh Dockerfile compose.yaml .dockerignore .github/workflows/ci.yml; do
  [[ -f "$f" ]] || { echo "MISSING: $f"; fail=1; }
done
for f in app/*.sh scripts/*.sh tests/*.sh; do
  if bash -n "$f"; then echo "OK syntax: $f"; else echo "SYNTAX ERROR: $f"; fail=1; fi
done
if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -S error app/*.sh scripts/*.sh tests/*.sh || fail=1
fi
exit $fail
