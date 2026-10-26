# Refactor language-service data handling

Related projection and incremental-result values are scattered across the language-service implementations. Restore cohesive handling of document-coordinate conversion, completion refresh state, diagnostic changes, formatting selections and recovered text edits. Reduce repeated component plumbing and make the relationships between captured values and their later use clear across the affected feature paths.

The related values cross source-coordinate projection, completion refresh, diagnostic changes, formatting selections and recovered text edits. Restore producer-to-consumer relationships without replacing separate per-feature state with one indiscriminate context object.

Preserve supported language-service and plugin interfaces, cancellation and failure behavior, mapping and filter semantics, result ordering, deferred resolution and existing mutation behavior. Keep original tests intact. Choose appropriate abstractions from the code; no particular class layout or file organization is required.
