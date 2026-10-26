#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
cd packages/next-on-pages && npx vitest run --reporter=json --outputFile=/logs/artifacts/native.json --config vitest.config.ts
