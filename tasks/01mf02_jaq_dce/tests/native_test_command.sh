#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
export PATH=/usr/local/cargo/bin:$PATH && cargo test --workspace --all-features
