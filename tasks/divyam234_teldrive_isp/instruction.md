# Narrow transfer and storage contracts

Transfer, storage and background-job clients depend on backend contracts spanning unrelated capabilities. Refactor these contracts around actual download, upload, copy and maintenance needs. Include the lifecycle work around metadata persistence, sessions, leases and cleanup; narrowing declarations alone is not sufficient.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
