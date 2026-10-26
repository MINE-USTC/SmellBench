# Restore cohesive symbol lookup data

Symbol lookup and patch metadata generation pass related symbol fields through repeated scalar interfaces and parallel storage. Restore coherent representations from table loading through lookup and relocation consumers. Keep raw input interpretation distinct from effective metadata used by each output path.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
