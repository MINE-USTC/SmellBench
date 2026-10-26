FROM ubuntu:24.04

USER root

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates curl jq build-essential cmake php-cli php-dev php8.3-cgi autoconf clang-tidy-18 && rm -rf /var/lib/apt/lists/*

ARG REPO_URL="https://github.com/laruence/php-yaf"
ARG TARGET_COMMIT="eafa56fb9b77173d62dde98f1bdfb63b4f4d0790"

RUN git clone "${REPO_URL}" /workspace/repo \
    && git -C /workspace/repo checkout --detach "${TARGET_COMMIT}"


RUN apt-get update && apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/repo

RUN phpize && ./configure --enable-yaf && make -j4

CMD ["/bin/bash"]

COPY smell.diff /tmp/smell.diff
RUN cd /workspace/repo && git apply /tmp/smell.diff && rm /tmp/smell.diff \
    && git add -u && git ls-files --cached --others --exclude-standard -z > /tmp/snapshot-files
RUN cd /workspace/repo \
    && rm -rf /workspace/repo/.git && git init \
    && git add -f --pathspec-from-file=/tmp/snapshot-files --pathspec-file-nul \
    && git -c user.name=Benchmark -c user.email=benchmark@local commit -m 'Repository snapshot' \
    && git rev-parse HEAD > /workspace/smellbench_base_commit && rm /tmp/snapshot-files
