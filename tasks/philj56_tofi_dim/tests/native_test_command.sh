#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
ninja -C builddir && meson test --verbose -C builddir
