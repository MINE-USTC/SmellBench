# Recover glTF processing boundaries

glTF parsing and writing contain deeply embedded object and representation mechanics. Recover cohesive boundaries across token processing, object collections, buffer/accessor handling and document serialization in cgltf.h and cgltf_write.h. Cover nested extensions and failure paths as well as common mesh data.

Preserve supported behavior, public APIs and extension hooks, including output, errors and resource lifetimes. Choose a decomposition appropriate to the existing code; no particular helper names or file layout are required. Do not add features or narrow supported behavior.

Keep the original tests, fixtures, dependency settings and test configuration unchanged; no new tests are required. Run the relevant existing tests and build checks, and report what ran and any limitations. Work from this checkout without retrieving upstream or reference implementations.
