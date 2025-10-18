#!/bin/bash
set -e

echo "🦀 Building Rust and regenerating C header..."
cd rust
cargo build
cd ..

echo "🎯 Regenerating Dart FFI bindings..."
dart run ffigen --config ffigen.yaml

echo "✅ Done! Bindings regenerated."
echo ""
echo "Next steps:"
echo "  cd example && flutter run"