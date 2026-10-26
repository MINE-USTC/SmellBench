# Separate terminal callback capabilities

The terminal implementation couples parser, state, screen and output clients through a broad services object. Refactor these dependencies around the capabilities each layer actually uses. Include callback registration and fallback dispatch as well as ordinary rendering, without changing the supported terminal integration.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
