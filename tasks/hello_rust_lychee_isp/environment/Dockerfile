FROM rust:1.98.1-slim

USER root

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates curl jq build-essential perl && rm -rf /var/lib/apt/lists/*

ARG REPO_URL="https://github.com/hello-rust/lychee"
ARG TARGET_COMMIT="4e065481e8571d0b270c5f4e2332b74cc8342758"

RUN git clone "${REPO_URL}" /workspace/repo \
    && git -C /workspace/repo checkout --detach "${TARGET_COMMIT}"


RUN apt-get update && apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/repo

RUN cargo build --all-targets

CMD ["/bin/bash"]

COPY smell.diff /tmp/smell.diff
RUN cd /workspace/repo && git apply /tmp/smell.diff && rm /tmp/smell.diff \
    && git add -u && git ls-files --cached --others --exclude-standard -z > /tmp/snapshot-files
RUN cd /workspace/repo \
    && rm -rf /workspace/repo/.git && git init \
    && git add -f --pathspec-from-file=/tmp/snapshot-files --pathspec-file-nul \
    && git -c user.name=Benchmark -c user.email=benchmark@local commit -m 'Repository snapshot' \
    && git rev-parse HEAD > /workspace/smellbench_base_commit && rm /tmp/snapshot-files
