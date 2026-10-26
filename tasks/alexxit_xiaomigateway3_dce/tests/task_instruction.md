# Remove obsolete gateway processing branches

Gateway message processing contains overlapping routes whose reachability depends on earlier normalization and dispatch decisions. Simplify obsolete paths across incoming reports, outgoing commands, converter handling and entity registration. Check the producers of each intermediate value before removing a branch; uncommon supported protocols must remain supported.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
