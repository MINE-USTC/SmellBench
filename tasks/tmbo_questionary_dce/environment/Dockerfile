FROM python:3.12-slim

USER root

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates curl jq && rm -rf /var/lib/apt/lists/*

ARG REPO_URL="https://github.com/tmbo/questionary"
ARG TARGET_COMMIT="5a68c2d3e1d4ed01b9692b487349be66014db65f"

RUN git clone "${REPO_URL}" /workspace/repo \
    && git -C /workspace/repo checkout --detach "${TARGET_COMMIT}"


RUN apt-get update && apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/repo

RUN pip install --no-cache-dir -e . pytest pytest-cov pylint

CMD ["/bin/bash"]

COPY smell.diff /tmp/smell.diff
RUN cd /workspace/repo && git apply /tmp/smell.diff && rm /tmp/smell.diff \
    && git add -u && git ls-files --cached --others --exclude-standard -z > /tmp/snapshot-files
RUN cd /workspace/repo \
    && rm -rf /workspace/repo/.git && git init \
    && git add -f --pathspec-from-file=/tmp/snapshot-files --pathspec-file-nul \
    && git -c user.name=Benchmark -c user.email=benchmark@local commit -m 'Repository snapshot' \
    && git rev-parse HEAD > /workspace/smellbench_base_commit && rm /tmp/snapshot-files
