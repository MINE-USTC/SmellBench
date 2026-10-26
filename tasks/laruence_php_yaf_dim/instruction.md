# Clarify request and template execution stages

Application startup, request routing, dispatch and template rendering embed several layers of implementation in their callers. Recover cohesive operations across these workflows, including autoloading and normal/error finalization. Keep ownership of PHP values and execution resources explicit when moving boundaries.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
