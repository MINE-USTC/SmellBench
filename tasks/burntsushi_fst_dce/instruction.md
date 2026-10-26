# Task

Remove permanently unreachable internal implementation code from this fst checkout while preserving supported behavior and public APIs. Follow actual entry points, encoding, cache, query and writer relationships to distinguish retired code from live helpers and test-used owners. Clean up any exclusively dead helper closure without deleting live decoding, streaming, custom automaton or optional-feature paths.

The reachability chain crosses builder registry lookup, node encoding and writer finalization. Check which state can actually be produced by supported builders before deleting downstream paths, and keep cache rotation, streaming and error propagation that still serve live operations.

Keep repository tests and configuration unchanged. Preserve encoded data, query results, error propagation and writer finalization. A concise correct cleanup is valid; there is no requirement to match a particular refactoring architecture.

Verify with `cargo test --all-features -p fst` and describe the reachability reasoning separately from test coverage.
