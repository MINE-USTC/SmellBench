# Consolidate reporting policies

Reporting commands independently maintain metric interpretation, cache conventions and presentation rules. Consolidate these shared responsibilities so a policy change does not require coordinated edits across commands. Preserve each command's selection, ordering, missing-value handling, styled text, console and HTML output, errors and supported interfaces. Keep upstream tests unchanged. No particular abstraction or helper is required.

Metric interpretation, row conversion and presentation rules are repeated in rank and other table commands. Consolidate policy changes across command consumers while preserving each command's ordering, missing-value and console/HTML behavior.
