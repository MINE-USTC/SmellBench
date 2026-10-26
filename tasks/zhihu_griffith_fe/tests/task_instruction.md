# Restore playback responsibility boundaries

Playback consumers interpret source and media details that belong to other components. Revisit how the source provider selects and orders physical qualities, how Player coordinates picture-in-picture and persisted state, and how MSE uses MP4 probe intervals and track information while admitting requests, consulting the cache and appending fragments. Keep HLS source interpretation connected to manifest publication without moving transport effects into the probe.

Preserve public interfaces, quality selection and reset behavior, malformed-history fallback, picture-in-picture lifecycle, seek versus sequential playback, request/cache ordering, track append order, missing-audio handling, events and observable output. A repair may use any coherent ownership boundary; no particular helper name or decomposition is required.

Keep the original tests and configuration unchanged. Run the relevant native checks and report any limitations. Work from this checkout without retrieving a reference implementation.
