#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
.venv/bin/python -m pytest tests/ -p no:cacheprovider -q
