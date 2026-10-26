#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
cmake -S . -B build && cmake --build build -j4
ctest --verbose --output-junit /logs/artifacts/native.xml --test-dir build --output-on-failure
