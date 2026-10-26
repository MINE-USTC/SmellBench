#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
test -f go.mod || go mod init github.com/xwb1989/sqlparser; go test -count=1 -json ./...
