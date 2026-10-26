# Narrow tree access capabilities

Tree lookup, traversal and mutation clients now depend on a node service spanning ordering, allocation, cloning and lifecycle operations. Refactor these dependencies for generic trees, ordered maps and their wrappers. Include iterators and snapshots, where access mode, owner identity and release behavior interact.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
