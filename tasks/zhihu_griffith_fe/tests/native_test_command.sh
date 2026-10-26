#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
corepack yarn test --json --outputFile=/logs/artifacts/native.json
