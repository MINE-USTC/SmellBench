#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
GOTOOLCHAIN=auto go test -json -count=1 -timeout 25m ./...
