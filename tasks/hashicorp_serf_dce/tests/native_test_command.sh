#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
busybox syslogd -n -O /logs/artifacts/syslog.log &
logger_pid=$!
trap 'kill "$logger_pid" 2>/dev/null || true' EXIT
for _ in $(seq 1 40); do [ -S /dev/log ] && break; sleep .1; done
test -S /dev/log
GOTOOLCHAIN=auto go test -count=1 -json ./...
