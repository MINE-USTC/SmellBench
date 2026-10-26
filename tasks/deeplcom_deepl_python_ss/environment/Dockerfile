FROM python:3.12-slim

USER root

RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates curl jq nodejs npm util-linux && rm -rf /var/lib/apt/lists/*

ARG REPO_URL="https://github.com/DeepLcom/deepl-python"
ARG TARGET_COMMIT="74415f95d0ed10414b278d7a332af6c7e7687f31"

RUN git clone "${REPO_URL}" /workspace/repo \
    && git -C /workspace/repo checkout --detach "${TARGET_COMMIT}"


RUN apt-get update && apt-get install -y --no-install-recommends python3 && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/repo

RUN python3 -m venv .venv && . .venv/bin/activate && pip install --upgrade pip && pip install -e . "pydantic<2" typing_extensions keyring pytest coverage pylint click && if [ ! -d /workspace/deepl-mock ]; then git clone --depth=1 https://github.com/DeepLcom/deepl-mock /workspace/deepl-mock; fi && (cd /workspace/deepl-mock && npm install --omit=dev)

CMD ["/bin/bash"]

COPY smell.diff /tmp/smell.diff
RUN cd /workspace/repo && git apply /tmp/smell.diff && rm /tmp/smell.diff \
    && git add -u && git ls-files --cached --others --exclude-standard -z > /tmp/snapshot-files
RUN cd /workspace/repo \
    && rm -rf /workspace/repo/.git && git init \
    && git add -f --pathspec-from-file=/tmp/snapshot-files --pathspec-file-nul \
    && git -c user.name=Benchmark -c user.email=benchmark@local commit -m 'Repository snapshot' \
    && git rev-parse HEAD > /workspace/smellbench_base_commit && rm /tmp/snapshot-files
