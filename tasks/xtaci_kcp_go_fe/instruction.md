# Restore protocol and session ownership

Session IO and packet consumers increasingly manipulate protocol, FEC and cipher internals. Restore coherent ownership across receive/send, loss recovery and packet protection. Keep session buffering and backpressure distinct from protocol queue and shard policy, including platform-specific receive paths.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
