# Clarify plugin operation lifecycles

Command execution, installation, plugin lifecycle and downloads have large routines combining preparation, execution and failure handling. Recover cohesive operations across these flows. Pay attention to deferred callbacks and the different completion, cancellation and rollback scopes.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
