# Simplify obsolete buffer paths

Buffer transfer and allocation handling have accumulated overlapping implementations. Review the read/write adapters, initialized and uninitialized buffer operations, and allocation/reclamation paths. Remove implementations that cannot be reached in supported executions. Preserve live validation, initialization guarantees, cursor advancement, allocation ownership, supported extension behavior, and public APIs. Analyze the effective callers and ownership transitions before treating an implementation as obsolete. Keep the existing native tests unchanged; absence of test coverage is not evidence of deadness.

The affected transfer and allocation paths cross read/write adapters, initialized-length publication and storage reclamation. Follow chunk-level ownership and partial-progress behavior before removing an implementation; an apparently superseded loop may still enforce initialization or cursor effects.
