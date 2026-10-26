#!/usr/bin/env bash
set -euo pipefail
cd /workspace/repo
test "$(git -C test/unit/objs rev-parse HEAD)" = d31eed75b76312986b65a65133b9a100efcc3903
git -C test/unit/objs diff --exit-code HEAD
make -C kpatch-build
make -C test/unit
