#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
cargo test --workspace --locked --tests
