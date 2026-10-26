Refactor recurring filesystem transport data groups in Cross's container workflow. Restore cohesive handling of toolchain copy paths and target components, project and target paths, nested Docker mount associations, remote cache observations, and custom image build paths.

The data groups travel through container provisioning, toolchain copy, mount association, remote-cache observations and artifact synchronization. Keep path identity and captured command values associated from preparation to final copy rather than regrouping only the first call site.

Keep public interfaces, command behavior, error order, supported branches, path representations, captured values, cache equivalence and original tests/configuration. Choose suitable abstractions; neither a historical architecture nor a lengthy repair is required.
