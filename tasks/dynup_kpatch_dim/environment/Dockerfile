FROM ubuntu:24.04

USER root

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates curl jq build-essential cmake libelf-dev clang clang-tidy && rm -rf /var/lib/apt/lists/*

ARG REPO_URL="https://github.com/dynup/kpatch"
ARG TARGET_COMMIT="74ac9ffe96df2704eb6f141bc7e680a7f449503e"

RUN git clone "${REPO_URL}" /workspace/repo \
    && git -C /workspace/repo checkout --detach "${TARGET_COMMIT}"


RUN apt-get update && apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/repo

RUN git submodule update --init test/unit/objs && test "$(git -C test/unit/objs rev-parse HEAD)" = d31eed75b76312986b65a65133b9a100efcc3903 && make -C kpatch-build

CMD ["/bin/bash"]

COPY smell.diff /tmp/smell.diff
RUN cd /workspace/repo && git apply /tmp/smell.diff && rm /tmp/smell.diff \
    && git add -u && git ls-files --cached --others --exclude-standard -z > /tmp/snapshot-files
RUN cd /workspace/repo \
    && mv .git/modules /tmp/native-fixture-submodule-modules \
    && rm -rf /workspace/repo/.git && git init \
    && mv /tmp/native-fixture-submodule-modules .git/modules \
    && git add -f --pathspec-from-file=/tmp/snapshot-files --pathspec-file-nul \
    && git -c user.name=Benchmark -c user.email=benchmark@local commit -m 'Repository snapshot' \
    && git rev-parse HEAD > /workspace/smellbench_base_commit && rm /tmp/snapshot-files
