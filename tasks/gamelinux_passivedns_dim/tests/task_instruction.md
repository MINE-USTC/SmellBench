# Separate packet and DNS processing stages

Packet reassembly and DNS processing mix protocol decisions with buffer, registry and output mechanics. Recover cohesive boundaries across fragments, TCP streams, outstanding queries, cache expiry and structured answer formatting. Include failure and partial-progress paths, where ownership and publication order matter.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
