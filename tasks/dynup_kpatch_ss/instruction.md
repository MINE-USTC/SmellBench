# Consolidate special-section policy

Special-section and compiler-generated metadata rules are spread across correlation, lookup and relocation handling. Consolidate the policies that must change together while retaining architecture and kernel-version differences. Include how section-size and grouping decisions feed regeneration and safety checks.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
