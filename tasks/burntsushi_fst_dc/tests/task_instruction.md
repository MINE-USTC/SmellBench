Refactor recurring groups of related values in raw FST construction and reading so that their relationships and invariants have cohesive owners. Cover unfinished edges and nodes, output factoring through canonicalization and binary encoding, reader metadata, and range traversal state and bounds.

The data relationships extend from unfinished nodes and output factoring into canonicalization and binary encoding, then into reader metadata and range traversal state. Preserve distinctions between construction-time and serialized representations and between a traversal's pending and published bounds.

Preserve public APIs, sorted insertion and duplicate-key behavior, serialized bytes and checksums, range and automaton results including callback order, and I/O failure behavior. Preserve the distinction between representations of an output at different construction stages and the lifetime of traversal data across seeking, suspension, resumption and termination. Clear independent abstractions are valid; no reference architecture or minimum patch size is required.

Keep original tests and build configuration unchanged. Run `cargo test -p fst --all-features`.
