Refactor the analysis reporting implementation so that maintaining a shared output rule does not require coordinated changes throughout the individual analyses. Preserve each analysis's legitimate differences, including optional summaries, recursive traversal, limits, and output schemas.

The repeated output policy spans Top, Diff, Dominators, Paths, Monos and Garbage. Shared JSON/table decisions include member continuity, summary rows and omissions, while each analysis keeps its own traversal and limit semantics; extracting one intact formatter block is not the whole repair.

Keep all supported public APIs, feature configurations, CLI and WebAssembly entry points, exact output bytes, field ordering, writer-error behavior, and original tests unchanged. Do not add new functionality or correct existing serialization quirks as part of this refactoring.
