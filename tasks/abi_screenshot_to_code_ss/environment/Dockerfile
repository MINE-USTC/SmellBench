FROM python:3.12-slim

USER root

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates curl jq && rm -rf /var/lib/apt/lists/*

ARG REPO_URL="https://github.com/abi/screenshot-to-code"
ARG TARGET_COMMIT="a8139779f7c5ae231b7f2a86fa7f83ddc5f7badc"

RUN git clone "${REPO_URL}" /workspace/repo \
    && git -C /workspace/repo checkout --detach "${TARGET_COMMIT}"


RUN apt-get update && apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/repo

RUN python3 -m pip install "poetry==2.5.1" && poetry --directory /workspace/repo/backend install --no-root

CMD ["/bin/bash"]

COPY smell.diff /tmp/smell.diff
RUN cd /workspace/repo && git apply /tmp/smell.diff && rm /tmp/smell.diff \
    && git add -u && git ls-files --cached --others --exclude-standard -z > /tmp/snapshot-files
RUN cd /workspace/repo \
    && rm -rf /workspace/repo/.git && git init \
    && git add -f --pathspec-from-file=/tmp/snapshot-files --pathspec-file-nul \
    && git -c user.name=Benchmark -c user.email=benchmark@local commit -m 'Repository snapshot' \
    && git rev-parse HEAD > /workspace/smellbench_base_commit && rm /tmp/snapshot-files
