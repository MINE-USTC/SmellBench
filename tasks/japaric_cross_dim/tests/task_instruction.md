Refactor the deeply inlined production workflows in Cross while preserving supported behavior.

The expanded paths cover configuration precedence, image naming and selection, mount discovery, environment mapping and remote artifact handling. Extract coherent nested operations with clear effect boundaries while preserving command order and temporary-resource lifetime.

Improve the separation of configuration lookup and precedence, image construction and selection, mount discovery, and remote preparation and artifact handling. Recover coherent nested contracts with clear inputs, results, and effect boundaries. Preserve public interfaces, configuration precedence, error behavior, command ordering, stable mount selection, temporary-resource lifetimes, and remote copy/fallback behavior.

Do not change native tests or build configuration to make validation pass. A concise correct refactoring is welcome; no particular class layout or helper naming is required.

Validate with the unchanged root-package suite: `cargo test --locked --offline` when dependencies are available.
