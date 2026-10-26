# Separate endpoint request lifecycles

Spotify endpoint methods repeat nested argument handling, request preparation, transport and completion logic. Recover reusable stages across catalog, library, playlist and playback operations while keeping endpoint-specific payload policy clear. Include callback and promise-provider paths and their failure timing.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
