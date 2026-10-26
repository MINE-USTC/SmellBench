Refactor the translation-option and glossary-entry policies used by Translator and DeepLClient so a change to a shared rule can be made consistently across their consumers. Preserve supported APIs, request contents and field order, glossary language behavior, error messages and their ordering, and CSV/TSV input conventions. Keep legitimate differences between text and document requests and between bilingual and multilingual operations.

The shared decisions include language normalization, glossary eligibility and entry conversion across Translator, DeepLClient and text/document request paths. Consolidate only policies that truly change together; retain the distinct bilingual and multilingual request contracts and error timing.

The existing utility APIs remain supported. Choose appropriate internal boundaries without changing the original tests or adding new product behavior.
