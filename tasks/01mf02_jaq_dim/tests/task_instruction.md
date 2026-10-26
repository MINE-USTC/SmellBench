# Clarify filter processing boundaries

Lexing, compilation, module loading and CLI execution now mix orchestration with nested implementation details. The same difficulty extends to tabular input and output handling. Recover cohesive operations across these workflows, paying attention to where temporary state is established, consumed and published.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
