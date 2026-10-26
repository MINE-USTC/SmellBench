Refactor the recurring cohesive data groups in jaq-core's compilation, execution, loading and path workflows. Give related values and their representation changes clear ownership across their producers and consumers.

The affected code follows five connected lineages: signature declaration and resolution, lexical binding depths, execution frames, import roots and path provenance. Follow how those representations are produced and consumed across compilation and evaluation, including argument modes, caller capture and optional path results; do not treat each repeated tuple as an isolated cleanup.

Preserve public APIs and generic/native extensions, argument evaluation and capture, lexical and tail-call behavior, import resolution, path provenance, optional errors, query outputs and ordering. Keep original tests and configuration unchanged and validate with the original jaq-core suite.
