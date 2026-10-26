#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
make -j4 && tini -s -- python3 tests/run.py
