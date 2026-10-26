#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
python -m pytest -q
