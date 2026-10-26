#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
npm test -- --json --outputFile=/logs/artifacts/native.json
