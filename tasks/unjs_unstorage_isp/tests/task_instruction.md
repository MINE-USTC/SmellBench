# Separate storage driver capabilities

Core storage operations and the overlay driver depend on a broad driver-facing session that combines item access, mutation, metadata, key enumeration, watching and disposal. Refactor these consumers around the capabilities each operation actually needs. Pay attention to optional driver operations, fallback paths, mount-relative keys and change notifications across both regular and overlay storage.

Mounted storage and overlay layers use one broad driver session, including raw/batch defaults, metadata, clear, watch and disposal. Refactor around the capabilities required by each consumer and the fallback/notification lifecycle; retaining the same all-purpose adapter under a new name would not segregate those dependencies.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
