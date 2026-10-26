#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
GOTOOLCHAIN=auto CGO_ENABLED=0 go test -count=1 -json ./...
