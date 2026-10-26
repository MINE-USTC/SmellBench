# Narrow display service dependencies

Text rendering, configuration, clipboard and surface handling share a broad display service and request object. Refactor clients toward the capabilities and context each operation needs. Include backend metrics, scaling and redraw behavior without coupling lightweight text or clipboard work to the entire display subsystem.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
