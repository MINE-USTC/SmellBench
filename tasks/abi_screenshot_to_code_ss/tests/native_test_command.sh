#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
cd /workspace/repo/backend && poetry run pytest
