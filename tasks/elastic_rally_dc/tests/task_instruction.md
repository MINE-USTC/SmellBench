Refactor Rally's measurement and result-reporting code to remove recurring data clumps. Give related timing, aggregation, operation identity, race provenance and result values coherent representations across their producers and consumers.

Measurement identity, provisional throughput samples, warmup/normal phase and result-document projection form a connected data lifecycle. Preserve pending replay and publication order while giving related timing and aggregation values a coherent representation across calculators and reports.

Preserve supported APIs, extension dispatch, serialized output and runtime behavior. This includes incremental throughput replay and publication, warmup/normal transitions, single- and multi-cluster reports, missing values, optional metadata, and serialization and reporting callbacks. Keep original tests and configuration unchanged. Use maintainable abstractions suited to the existing codebase; no specific architecture or minimum patch size is required.
