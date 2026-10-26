# Recover container mutation boundaries

Container mutation routines mix capacity management, traversal, topology changes and result publication. Recover cohesive operations across arrays/deques, hash tables, linked lists, priority queues and ordered/ternary trees. Include iterator and byte-sized array consumers and preserve existing failure-side effects.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
