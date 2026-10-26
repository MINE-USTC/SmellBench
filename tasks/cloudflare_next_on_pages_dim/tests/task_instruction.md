# Clarify application build stages

The Vercel-output conversion pipeline embeds file preparation, function interpretation and route publication details in large orchestration routines. Recover cohesive stages across build setup, edge/prerender processing, deduplication and metadata generation, including how intermediate results become final routes.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
