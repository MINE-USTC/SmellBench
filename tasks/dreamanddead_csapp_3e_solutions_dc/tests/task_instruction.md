# Clarify simulator state relationships

The chapter 4 simulators pass memory, machine and pipeline state as recurring groups of independent values. Restore coherent representations across ISA helpers and the YIS, PIPE and SEQ consumers. Make bounds and state-transition meanings clear without changing the simulated architecture.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
