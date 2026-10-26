#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
npx jest --runInBand --json --outputFile=/logs/artifacts/native.json
