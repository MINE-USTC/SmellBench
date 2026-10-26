# Restore prompt model ownership

Prompt bindings, forms and configured prompts increasingly interpret Choice, control and Question state themselves. Restore coherent ownership of selection/search/presentation and execution policy while leaving prompt-specific bindings in their consumers. Include async execution and callback-sensitive state.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
