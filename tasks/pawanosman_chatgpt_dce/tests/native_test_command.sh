#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
npx vitest run --reporter=json --outputFile=/logs/artifacts/native.json --no-file-parallelism
