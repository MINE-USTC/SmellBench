# Clarify FST construction and traversal

FST construction, traversal and binary-format handling embed low-level operations inside their callers. Recover cohesive processing boundaries across builders, streams, set operations and node serialization. Pay attention to intermediate-state ownership and partial progress, not only the size of individual routines.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
