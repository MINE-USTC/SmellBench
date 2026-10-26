#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
pnpm run test --reporter=json --outputFile=/logs/artifacts/native.json
