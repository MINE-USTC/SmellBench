# Restore collection storage ownership

Collection facades and iterators directly interpret storage and mutation details belonging to the underlying implementations. Refactor the affected stack, array, queue, deque, hash-set and tree-set paths so growth, membership, traversal, replacement and teardown have coherent owners. Cover constructor and failure-cleanup paths as well as ordinary operations; do not treat a moved block or a repaired compile error as the whole refactoring.

Preserve public C APIs, return values, element ordering, iterator behavior, allocator callbacks, failure cleanup and supported aliasing between collections passed to zip iterators. Legitimate differences between collection types should remain. No particular helper names or file layout are required.

Keep the original tests and build configuration unchanged. Run the relevant native checks and report any limitations. Work from this checkout without retrieving a reference implementation.
