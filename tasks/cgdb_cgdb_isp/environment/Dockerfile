FROM ubuntu:24.04

USER root

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates curl jq build-essential cmake autoconf automake libtool flex bison m4 texinfo libncurses-dev libreadline-dev dejagnu expect tcl-dev clang clang-tidy pkg-config && rm -rf /var/lib/apt/lists/*

ARG REPO_URL="https://github.com/cgdb/cgdb.git"
ARG TARGET_COMMIT="ae240a2fb828fb3e8d57bd75f603a93e28d3fff1"

RUN git clone "${REPO_URL}" /workspace/repo \
    && git -C /workspace/repo checkout --detach "${TARGET_COMMIT}"


RUN apt-get update && apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/repo

RUN sed -i 's/AC_PREREQ(\[2.72\])/AC_PREREQ([2.71])/' configure.ac && ./autogen.sh && ./configure && make

CMD ["/bin/bash"]

COPY smell.diff /tmp/smell.diff
RUN cd /workspace/repo && git apply /tmp/smell.diff && rm /tmp/smell.diff \
    && git add -u && git ls-files --cached --others --exclude-standard -z > /tmp/snapshot-files
RUN cd /workspace/repo \
    && rm -rf /workspace/repo/.git && git init \
    && git add -f --pathspec-from-file=/tmp/snapshot-files --pathspec-file-nul \
    && git -c user.name=Benchmark -c user.email=benchmark@local commit -m 'Repository snapshot' \
    && git rev-parse HEAD > /workspace/smellbench_base_commit && rm /tmp/snapshot-files
