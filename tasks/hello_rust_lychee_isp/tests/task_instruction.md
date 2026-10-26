# Refactor output capability boundaries

Refactor CLI reporting so clients and adapters depend on the capabilities they actually use. Progress tracking, response presentation, statistics collection and serialization, diagnostic hints, host summaries and output destinations should not impose unrelated implementation or initialization obligations.

Progress, response presentation, statistics and host summaries now meet in a broad output contract. Narrow dependencies for compact/detailed reporting and serialization without imposing destination or initialization obligations on lightweight consumers.

Preserve existing formatter entry points and observable output, including natural ordering and grouping of errors, timeouts and ignored links; Markdown span and cached-status details; optional host statistics; all output modes and formats; Task-mode progress fallback; no-color behavior; hidden bars and verbosity; progress completion and response-less updates; redirect accounting; hint eligibility and order; and output-file error context. Existing narrow formatter implementations must remain usable. Preserve the behavior of default implementations and report adapters when separating capabilities.

Choose coherent contracts and reusable helpers. No particular architecture or minimum patch size is required. Do not alter tests, fixtures or Cargo configuration to obtain a pass. Run the original relevant command: `cargo test --locked -p lychee --bin lychee`.
