Refactor the supplied Questionary source to remove code that cannot execute in its current production workflows. Follow the relationships between prompt entry points, choice preparation and registration, validation results, and completion state before deciding a branch is dead.

Prompt entrypoints, choice registration, validation and completion state form the producer-to-consumer reachability chain. Delete only paths excluded by that chain; retain custom validators, completers and checks that still reject invalid input.

Preserve public prompt behavior, exceptions, callback timing, selection order, formatting, and synchronous/asynchronous entry points. Preserve supported custom validators, completers, choice values, and aliases. Keep live supporting logic, including checks that can reject invalid user input. Do not infer deadness from lack of test coverage.

Do not modify tests, project configuration, or dependency constraints. Validate the result with the unchanged native test suite (`python -m pytest -q`). Briefly explain the production constraints that establish unreachability for each deletion.
