#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
go test -json -count=1 ./...
