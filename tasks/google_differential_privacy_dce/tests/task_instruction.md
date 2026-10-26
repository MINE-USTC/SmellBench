Simplify the Go aggregation and noise implementation by removing obsolete code whose execution is ruled out by the effective lifecycle, cache publication, or production call graph. Trace shared producers and their consumers before choosing deletion boundaries.

The relevant paths depend on aggregation admission, result-cache publication and the later Count, sum, mean, variance and quantile consumers. Prove a branch unreachable from those state transitions before deleting it, and preserve custom-noise and serialization paths that remain supported.

Preserve supported public and custom-noise behavior, error ordering and wrapping, random sampling, privacy budgets, repeatable quantiles, and gob compatibility. Some cache fallback paths remain necessary; do not assume every branch beside a cache lookup is obsolete. Keep upstream tests and configuration unchanged. Equivalent concise repairs are welcome.
