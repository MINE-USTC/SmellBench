Related storage, traversal, and allocation values are passed separately through several collection implementations, and parts of the same data constraint are handled at different stages. Refactor the affected growth, copying/transfer, keyed lookup, and pool allocation paths to restore coherent data boundaries and simplify their use.

The affected data lifecycles include dynamic-buffer growth, byte-width and capacity handling, keyed lookup, iterator setup and pool allocation. Restore associations between size, backing storage and allocator state across callers while preserving failure and callback effects.

Preserve the public API and existing behavior, including allocation failures, custom callbacks, iterator effects, and error results. Keep the repository's tests unchanged and avoid unrelated feature or behavior fixes.
