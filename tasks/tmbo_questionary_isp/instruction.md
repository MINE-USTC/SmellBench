# Separate prompt service capabilities

Prompt construction, answer storage, navigation, presentation and execution depend on one broad service. Refactor around the capabilities each client needs, including lightweight style/print/key consumers. Keep stateful defaults and per-question execution isolated without losing configured-prompt and form behavior.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
