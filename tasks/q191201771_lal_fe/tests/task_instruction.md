Refactor misplaced message-format responsibilities in the streaming pipeline. Message classification, timing interpretation, metadata-envelope handling and retained-payload ownership are scattered through caches, remuxers, lazy outputs and group broadcasting. Restore cohesive responsibility boundaries while preserving each consumer's protocol-specific behavior, state transitions and output ordering.

The foreign decisions extend from GOP cache admission and sequence handling through dummy-audio filtering, RTMP-to-AV remuxing and group broadcast. Keep protocol-specific message order and metadata errors while restoring ownership of packet interpretation and retained payloads.

Keep supported APIs and all original tests intact. Preserve classic and enhanced RTMP behavior, sequence-header handling, key-frame gating, timestamp arithmetic, metadata error handling, and memory independence for retained or transformed payloads. Equivalent sound designs are acceptable; no particular helper names or file layout are required.

Run the repository's native Go tests (`go test -count=1 ./pkg/...`).
