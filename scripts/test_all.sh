#!/bin/bash
set -e

echo "🧪 Running Rust tests..."
cd rust
cargo test
cd ..

echo "🧪 Running Dart tests..."
flutter test

echo "✅ All tests passed!"