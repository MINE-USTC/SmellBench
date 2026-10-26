#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
cargo test --all-features -p fst
