# Restore buffer responsibility boundaries

Several buffer consumers have accumulated knowledge of mutable storage representation and initialization rules. Refactor these boundaries so traversal, quota accounting, immutable ownership conversion and mutable storage management have sensible owners.

The misplaced decisions occur where buffer consumers write into mutable storage, account for quota and initialized length, and convert mutable ownership to immutable views. Keep producer-owned invariants coherent even when a transfer panics after partial progress.

Preserve public APIs, supported trait implementations, allocation ownership, zero-copy behavior and all existing tests. Keep production changes focused and preserve observable behavior, including partially completed transfers when a source or destination panics.
