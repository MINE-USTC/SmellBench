# Separate container build and execution ownership

Container execution has accumulated custom-image building, environment preparation, remote synchronization and artifact publication in broad owners. Refactor these responsibilities for both local and remote execution. Follow configuration through image selection and output collection so lifecycle decisions remain coherent.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
