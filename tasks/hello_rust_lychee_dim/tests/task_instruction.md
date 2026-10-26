# Refactor link-processing boundaries

Restore coherent boundaries in local-path checking, HTTP method attempts, URL-to-request construction, collection and fragment validation. The outer workflows currently combine nested parsing, policy decisions and result publication.

The affected workflows include method retry exits, URL-to-request construction, local-path errors and anchor decode/cache sequencing. Recover boundaries that carry intermediate state through the outer async workflow rather than merely shortening one checker function.

Preserve supported behavior, public APIs, plugin ordering, diagnostics, asynchronous behavior and all original tests. Choose suitable abstractions for these workflows; no particular helper names, architecture or minimum change size is required.
