# Separate schema and persisted-query processing stages

Schema introspection and persisted-query processing have become difficult to follow: nested projection, rendering and expression-resolution details are embedded in their consumers. Schema loading has the same problem across initial loads and updates. Refactor these related workflows into maintainable operations while retaining their different caching and lifecycle contracts.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
