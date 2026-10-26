Refactor the deeply nested implementations in source mapping, snapshot history and language-service projection into cohesive operations with clear boundaries.

The nested workflows cover source-map lazy selection, snapshot history, completion/edit recovery and Markdown projection. Recover cohesive operations while preserving plugin overrides, cancellation, exception propagation and Promise/iterator ordering.

Preserve supported APIs and behavior: mapping order and lazy caches, snapshot history and repeated queries, completion metadata and edit recovery, Markdown projection, plugin overrides, cancellation, exceptions, iterator finalization and Promise ordering. Keep tests and configuration unchanged. A concise valid decomposition is welcome; no particular architecture is required.

Validate using the original commands: corepack pnpm run build and corepack pnpm test.
