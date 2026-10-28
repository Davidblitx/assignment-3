#!/usr/bin/env bash
set -u
cd "$(dirname "$0")/.." || exit 1
IMAGE="devops-tool"
fail() { echo "FAIL: $1"; exit 1; }

docker build -t "$IMAGE" . || fail "docker build"
docker run --rm "$IMAGE" help >/dev/null || fail "smoke: help"
docker run --rm "$IMAGE" system-info >/dev/null || fail "smoke: system-info"
docker run --rm "$IMAGE" invalid-command >/dev/null 2>&1
[[ $? -eq 2 ]] || fail "smoke: invalid command should exit 2"
echo "All Docker smoke tests passed"
