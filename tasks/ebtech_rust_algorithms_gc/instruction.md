# Refactor graph responsibility boundaries

The graph implementation has accumulated connectivity decomposition, flow optimization, set maintenance and traversal execution alongside its compact storage representation. These responsibilities depend on internal traversal and publication details, making independent changes harder to reason about.

The graph owner combines connectivity decomposition, traversal execution, flow optimization and set maintenance with compact storage. Refactor across these whole responsibility families, including how recursive state is published to callers, without merely moving intact algorithms behind wrappers.

Restore clearer ownership and maintainable boundaries across the affected graph workflows. Preserve the existing public graph, connectivity, flow, disjoint-set and iterator APIs, algorithm results, ordering and supported edge cases. Keep the original tests unchanged. No new functionality or particular class hierarchy is required.
