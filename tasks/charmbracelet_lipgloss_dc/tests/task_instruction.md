# Restore cohesion in rendering data

Related rendering values are dispersed through style configuration, table layout, perimeter coloring and layer composition. Restore coherent ownership of these data groups and their transformations across their actual producers and consumers.

The recurring values move through border glyph selection, raw style flags, table sizing and wrapping, and layer placement. Review both construction and later rendering consumers so a coherent data relationship survives inheritance, empty values and conditional layout.

Preserve public APIs, raw configuration getters, inheritance and unset behavior, conditional rendering defaults, sizing and wrapping, rendered output, composition order, hit testing and refresh semantics. Keep native tests unchanged. Choose appropriate abstractions without requiring a particular class layout.
