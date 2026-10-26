# Remove unreachable resolver and template paths

Resolver consumers, configuration merging and template handlers retain error and rendering paths whose reachability depends on earlier argument validation, extension selection and prepared-content ownership. Trace those producer-to-consumer contracts across the resolver helpers, merge strategies and local, S3 and HTTP handlers before removing code that cannot execute in supported workflows.

Preserve public and plugin extension contracts, supported invalid-input diagnostics, raw-content precedence, optional formats, download and temporary-file lifetimes, rendering output and error ordering. Do not remove live logging or handler behavior merely because an adjacent fallback is unreachable; equivalent internal decompositions are acceptable.

Keep the original tests and configuration unchanged. Run the relevant native checks and report any limitations. Work from this checkout without retrieving a reference implementation.
