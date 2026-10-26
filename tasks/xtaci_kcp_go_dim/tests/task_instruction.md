Refactor the deeply inlined transport workflows in this kcp-go checkout into cohesive, understandable operations. Address the protocol acknowledgement and receive paths, session stream reads and writes, FEC encode/decode and initialization, and timed transmission paths.

The embedded mechanics cross ACK/receive processing, session stream reads and writes, FEC encoding/decoding and timed transmission. Separate operations around packet ownership, locking and callback boundaries rather than moving a complete protocol loop unchanged.

Preserve supported APIs, packet formats, ordering of observable effects, buffer ownership, locking, callbacks, error handling and platform behavior. Keep the original tests and configuration unchanged. Choose sensible extraction boundaries and reuse existing operations where they fit; no particular decomposition is required.

Validate with the repository's original Go tests and explain the boundaries restored by your changes.
