# Consolidate generated-artifact policy

Changes to schema selection or generated-artifact handling require coordinated edits across CLI producers and workers. Consolidate the repeated policy while preserving the distinctions between schema-derived and project-derived outputs. Include how content is prepared and how existing headers and output destinations are handled.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
