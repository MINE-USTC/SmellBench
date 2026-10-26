# Restore query and coordinate data cohesion

Query handling and coordinate updates repeatedly move related values through scalar-heavy interfaces. Restore coherent representations across query creation, response delivery, key-management results and numerical updates. Include expiry and derived results, where identity and lifetime must remain associated.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
