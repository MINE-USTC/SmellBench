# Recover patch-building operation boundaries

ELF loading, correlation, symbol lookup and module construction mix traversal with nested interpretation and mutation. Recover cohesive operations across these workflows, including special-section handling. Keep source/destination contexts and publication order understandable at the boundaries.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
