# Consolidate presentation styling and layout policy

Presentation styling and viewport handling have become difficult to change consistently. Related rules are repeated or mixed into element builders, theme processing, rendering, and live snippet output, so a small policy adjustment can require edits in several places.

The repeated styling decisions connect raw theme inheritance, palette errors, alignment and viewport geometry, element builders and live snippet output. Give policies that change together coherent ownership while retaining each renderer's local layout and color behavior.

Refactor these paths so shared decisions have coherent ownership and consumers retain only their genuine local differences. Cover the related presentation paths rather than fixing a single example. Preserve existing rendering, configuration, palette errors, extension points and execution behavior, including precedence, spacing and rounding details. Keep the original tests intact and run them. A compact solution is welcome; no particular class structure or reference implementation is required. Work from the supplied repository without retrieving upstream implementations.
