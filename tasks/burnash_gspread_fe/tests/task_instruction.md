# Restore transport and spreadsheet ownership

Spreadsheet operations increasingly know about HTTP session and retry internals, while transport helpers also reach into spreadsheet and worksheet state. Refactor these boundaries across client operations, metadata and worksheet mutations. Keep request policy with its owner and object-state updates with the objects whose invariants they maintain.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
