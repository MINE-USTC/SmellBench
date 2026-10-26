# Restore package configuration ownership

Package discovery, generation, installation and verification interpret package configuration internals independently. Restore ownership of identity, command-file defaults and artifact/template decisions. Include checksum and platform-specific projections while keeping consumer-specific execution and filesystem effects in their workflows.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
