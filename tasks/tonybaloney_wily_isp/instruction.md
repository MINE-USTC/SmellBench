# Separate command execution capabilities

The command runtime mixes cache querying, source discovery, revision checkout and analysis publication. Read-only commands carry source and write dependencies, and query defaults also participate in source-backed revision selection and build metadata handling.

Read-only history/rank commands and source-backed revision/build commands currently share cache, checkout and publication capabilities. Narrow command dependencies across scan, source discovery and analysis publication without losing default selection or resource cleanup.

Refactor the runtime and its consumers so each command depends on the capabilities it actually needs. Preserve CLI results, supported archivers, revision resolution, metric values, ordering, missing-field defaults, error handling and resource cleanup. Keep existing tests intact. No new features or particular class layout are required.
