# Restore coherent file-operation data

File access, catalog queries and mutations repeatedly pass related values separately across API and service boundaries. Refactor these data relationships so their meaning remains clear from validation through execution. Pay particular attention to batch access decisions and how normalized query or mutation values are consumed.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
