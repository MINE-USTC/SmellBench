# Separate analysis and report responsibilities

The analysis layer combines selection, recursive traversal, comparison and report publication in the same implementation. Refactor these responsibilities into coherent owners across paths, garbage, comparison, monomorphization and top-level summaries. The output consumers must still interpret shared analysis state rather than simply moving whole report blocks to another module.

Preserve the public APIs, feature options, traversal membership and limits, filtering and omitted totals, deduplication, and text, JSON and CSV output contracts. Hidden or truncated rows may still affect later accounting. Choose appropriate internal boundaries without requiring a particular type or file layout.

Keep the original tests, fixtures and build configuration unchanged. Run the relevant native checks and report any limitations. Work from this checkout without retrieving a reference implementation.
