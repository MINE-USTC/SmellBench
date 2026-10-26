#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
chown -R nativebench:nativebench /workspace/repo /logs/artifacts
runuser -u nativebench -- /workspace/repo/.venv/bin/python -m pytest tests/
