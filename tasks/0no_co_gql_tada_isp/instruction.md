# Narrow schema workflow dependencies

Schema loaders, analysis clients and CLI output producers are coupled through operations that span more capabilities than each client needs. Refactor their contracts so loading, observation, analysis and output can evolve independently. Follow the actual consumers, including subscription and publication paths, rather than only changing interface declarations.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
