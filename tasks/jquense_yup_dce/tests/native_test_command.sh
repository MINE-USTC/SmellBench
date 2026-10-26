#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
corepack yarn lint && corepack yarn testonly --reporter=json --outputFile=/logs/artifacts/native.json
