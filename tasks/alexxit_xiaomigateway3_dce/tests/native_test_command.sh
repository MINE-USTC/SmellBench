#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
TZ=MSK-3 python3 -m pytest tests -q
