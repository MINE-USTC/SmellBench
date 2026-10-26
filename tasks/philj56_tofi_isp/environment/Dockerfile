FROM ubuntu:24.04

USER root

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates curl jq build-essential cmake meson ninja-build pkg-config libwayland-dev wayland-protocols libcairo2-dev libpango1.0-dev libharfbuzz-dev libfreetype-dev libxkbcommon-dev libglib2.0-dev clang clang-tidy libclang-dev && rm -rf /var/lib/apt/lists/*

ARG REPO_URL="https://github.com/philj56/tofi"
ARG TARGET_COMMIT="1eb6137572ab6c257ab6ab851d5d742167c18120"

RUN git clone "${REPO_URL}" /workspace/repo \
    && git -C /workspace/repo checkout --detach "${TARGET_COMMIT}"


RUN apt-get update && apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/repo

RUN meson setup builddir && ninja -C builddir

CMD ["/bin/bash"]

COPY smell.diff /tmp/smell.diff
RUN cd /workspace/repo && git apply /tmp/smell.diff && rm /tmp/smell.diff \
    && git add -u && git ls-files --cached --others --exclude-standard -z > /tmp/snapshot-files
RUN cd /workspace/repo \
    && rm -rf /workspace/repo/.git && git init \
    && git add -f --pathspec-from-file=/tmp/snapshot-files --pathspec-file-nul \
    && git -c user.name=Benchmark -c user.email=benchmark@local commit -m 'Repository snapshot' \
    && git rev-parse HEAD > /workspace/smellbench_base_commit && rm /tmp/snapshot-files
