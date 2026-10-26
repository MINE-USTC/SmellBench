#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
cd test && python3 test_all.py
