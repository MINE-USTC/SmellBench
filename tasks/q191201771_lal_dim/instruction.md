# Clarify media processing boundaries

Remuxing, RTP unpacking, FLV playback and HLS output embed low-level parsing and lifecycle work in large routines. Recover cohesive operations across these media paths. Keep cache draining, observer callbacks and partial-input handling explicit so a decomposition remains correct under reentry and errors.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
