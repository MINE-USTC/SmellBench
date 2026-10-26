# Restore workload and API resource ownership

V2 API resources and CLI commands interpret workload, schema and compatibility details across endpoint, development-pod, deployment, job, fine-tuning, pod and Ray-cluster workflows. Refactor the affected consumers so resource-specific validation, request construction and lifecycle policy have coherent owners; avoid merely relocating complete command or request blocks.

Preserve supported SDK and CLI entry points, extension hooks, defaults, validation and error ordering, request and response payloads, pagination, streaming, mutation order and diagnostic redaction. Keep legitimate differences between resource types. Choose the internal design appropriate to this codebase, without requiring a named helper or class layout.

Keep the original tests and configuration unchanged. Run the relevant native checks and report any limitations. Work from this checkout without retrieving a reference implementation.
