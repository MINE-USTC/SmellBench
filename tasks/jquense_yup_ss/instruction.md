# Consolidate validation diagnostic policies

Validation diagnostics and standard-schema adapters contain independently maintained pieces of the same rules. Changes to value display, error-path interpretation or reference-valued diagnostic parameters now require coordinated edits in several places.

The repeated policy extends through diagnostic value display, error-path interpretation, reference-valued parameters and standard-schema adapters. A single shared change should not require matching edits in each consumer, but legitimate differences in message and metadata publication must remain.

Refactor this code so the relevant policies have coherent ownership and are maintainable across their consumers. Preserve observable messages, paths, metadata, ordering, public APIs and synchronous/asynchronous behavior, including legitimate differences between consumers. Keep the original tests intact. Choose the design rather than matching a prescribed helper or class layout.
