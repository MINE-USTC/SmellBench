#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
GOTOOLCHAIN=auto go test -count=1 -json ./... -race -covermode=atomic
