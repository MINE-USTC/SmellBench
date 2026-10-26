#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
for ch in chapter2 chapter5 chapter8 chapter9; do make --trace -C site/content/$ch/code test CFLAGS="-m64 -pthread -fwrapv" || exit 1; done
