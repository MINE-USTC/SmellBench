#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
cargo test --locked --all-targets --workspace --all-features -- --test-threads=1
