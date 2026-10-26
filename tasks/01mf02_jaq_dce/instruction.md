# Simplify compilation and execution paths

The filter compiler and evaluator carry overlapping representations and execution paths. It is difficult to distinguish temporary construction forms from operations that can actually reach execution. Simplify obsolete implementation across expression evaluation and continuation processing, tracing construction and state transitions before deciding what can be removed.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
