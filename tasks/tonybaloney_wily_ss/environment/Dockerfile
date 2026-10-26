FROM python:3.12-slim

USER root

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates curl jq build-essential cmake pkg-config perl && rm -rf /var/lib/apt/lists/*

ARG REPO_URL="https://github.com/tonybaloney/wily"
ARG TARGET_COMMIT="24f450b544afead1fb3070259e94d724aec5223e"

RUN git clone "${REPO_URL}" /workspace/repo \
    && git -C /workspace/repo checkout --detach "${TARGET_COMMIT}"


RUN apt-get update && apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/repo

RUN set -e && curl --proto =https --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal --default-toolchain stable && . "$HOME/.cargo/env" && python3 -m venv .venv && .venv/bin/python -m pip install --upgrade pip && .venv/bin/python -m pip install maturin gitpython click nbformat plotly rich "pytest~=9.0" "pytest-cov~=4.1.0" "radon>=5.1,<5.2" pylint==4.0.8 astroid==4.0.4 && . .venv/bin/activate && maturin develop --release

CMD ["/bin/bash"]

COPY smell.diff /tmp/smell.diff
RUN cd /workspace/repo && git apply /tmp/smell.diff && rm /tmp/smell.diff \
    && git add -u && git ls-files --cached --others --exclude-standard -z > /tmp/snapshot-files
RUN cd /workspace/repo \
    && rm -rf /workspace/repo/.git && git init \
    && git add -f --pathspec-from-file=/tmp/snapshot-files --pathspec-file-nul \
    && git -c user.name=Benchmark -c user.email=benchmark@local commit -m 'Repository snapshot' \
    && git rev-parse HEAD > /workspace/smellbench_base_commit && rm /tmp/snapshot-files
