#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
make -j4
TERM=xterm make check
