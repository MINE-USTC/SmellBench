# Restore tree and cursor ownership

Public tree, set and iterator adapters interpret foreign node and cursor policy across point updates, rank and extreme operations, traversal, copying and cursor movement. Refactor these consumers so node selection, root/count maintenance, traversal callbacks, isolation and lock lifetime have coherent ownership. Keep each adapter's genuine result projection and avoid solving only one operation family.

Preserve generic and non-generic APIs, ordering and hints, mutation results, copy isolation, callback short-circuiting and grouping, concurrency options, iterator release behavior and supported nil-pivot cases. Choose an appropriate decomposition without requiring a particular helper name or file layout.

Keep the original tests and build configuration unchanged. Run the relevant native checks and report any limitations. Work from this checkout without retrieving a reference implementation.
