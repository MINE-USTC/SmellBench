#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
CI=true pnpm exec vitest run --reporter=json --outputFile=/logs/artifacts/native.json
