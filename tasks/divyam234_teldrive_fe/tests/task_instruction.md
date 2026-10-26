# Clarify file-service responsibility boundaries

File browsing, public sharing, storage reporting and transfer handling have accumulated knowledge of one another's policies. Consumers interpret details that should have coherent ownership, making changes to file access, storage records and encrypted layout unnecessarily scattered.

The affected chain includes file-list cursor preparation, public-share traversal, storage accounting and upload/download framing. Put access and record invariants with their owners while leaving pagination, presentation and transfer orchestration in the appropriate consumers.

Refactor these production paths to restore sensible responsibility boundaries. Preserve supported APIs, permission and error behavior, pagination, storage results, and upload/download compatibility. Cover the related consumers rather than addressing only one example. Keep the repository's existing tests unchanged; do not add unrelated features or replace the application with a new architecture.
