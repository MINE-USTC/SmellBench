# Remove obsolete storage execution paths

Storage normalization and dispatch leave overlapping fallback paths in core operations, tracing, utilities and the server. Simplify genuinely obsolete implementation by tracing the values and capabilities produced upstream. Retain supported driver fallbacks and externally observable error behavior.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
