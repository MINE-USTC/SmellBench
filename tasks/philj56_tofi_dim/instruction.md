# Separate launcher processing operations

Input editing, search, history/cache handling and rendering contain nested mechanics inside large workflows. Refactor these into cohesive operations, following how edits become filtered results and how measured text becomes painted output. Include cache/history failure handling and both normal and fuzzy matching.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
