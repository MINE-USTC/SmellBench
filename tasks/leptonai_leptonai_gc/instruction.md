Refactor the v2 API implementation to resolve the God Class in its common API resource layer. Recover cohesive ownership of workload, template, log, ingress, infrastructure and credential operations while retaining existing SDK and CLI behavior.

The overloaded common API resource has taken on workload, template, log, ingress, infrastructure and credential lifecycles. Separate responsibility and state publication across these families while retaining their shared transport behavior and the distinct SDK/CLI contracts.

Preserve public signatures, defaults, dynamic extension hooks and standalone utilities. Preserve validation and mutation order, request and response formats, pagination, streaming, and sensitive diagnostic handling. Keep original tests and configuration unchanged. No particular internal architecture or minimum change size is required.
