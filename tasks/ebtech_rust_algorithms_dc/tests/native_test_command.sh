#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
cargo test --no-fail-fast
