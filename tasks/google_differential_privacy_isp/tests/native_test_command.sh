#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
export PATH="$PATH:/usr/local/go/bin" && cd /workspace/repo/go && GOTOOLCHAIN=auto go test -json -count=1 ./...
