#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
make -j4
make -j4
export NO_INTERACTION=1 REPORT_EXIT_STATUS=1
NO_INTERACTION=1 make test
