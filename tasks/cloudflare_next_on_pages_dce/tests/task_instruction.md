# Remove unreachable build-processing paths

The Vercel-output conversion pipeline carries fallback paths through invalid-function reconciliation, prerender asset resolution, import-identifier accounting and edge-runtime publication. Trace how collected route identities, validated configuration and registered entrypoint consumers flow into those later stages, then remove only implementations that cannot execute in supported builds.

Preserve live locale and index alternatives, asset validation and copying, route destinations, edge entrypoints, generated output and diagnostics. Keep public behavior and extension points intact; do not discard a branch merely because its condition looks redundant in one function or because tests do not exercise it.

Keep the original tests, fixtures and build configuration unchanged. Run the relevant native checks and report any limitations. Work from this checkout without retrieving a reference implementation.
