# app_core

**Production-ready Flutter FFI plugin template with Rust backend**

A complete, ready-to-use template for building high-performance Flutter applications with Rust. Clone, customize, and ship.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Rust](https://img.shields.io/badge/Rust-1.70+-orange.svg)](https://www.rust-lang.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.3+-blue.svg)](https://flutter.dev/)

## Why This Template?

**Flutter for UI. Rust for everything else.**

- ⚡ **Performance**: FFI calls in ~50ns, native Rust speed, zero GC pauses
- 🔒 **Security**: Build from source, no prebuilt binaries, verify everything
- 🌍 **Cross-platform**: Android, iOS, macOS, Linux, Windows
- 🚀 **Production-ready**: Based on real production apps handling millions of users
- 🛠️ **Zero config**: Cargokit handles all platforms automatically
- 📦 **Complete**: Memory management, async operations, comprehensive examples
- 🎯 **Pub-ready**: Standard Flutter plugin structure, ready to publish

## Features

- ✅ Cross-platform support (5 platforms out-of-the-box)
- ✅ Automatic C header generation (cbindgen)
- ✅ Automatic Dart binding generation (ffigen)
- ✅ Memory management utilities (auto-free patterns)
- ✅ Type-safe FFI with convenient extensions
- ✅ Async operations with isolated ports (no global state, truly parallel)
- ✅ Working example app demonstrating all features
- ✅ Helper scripts for development workflow
- ✅ Comprehensive tests
- ✅ Easy package renaming with automated script

## Quick Start

### Prerequisites

**Required:**
```bash
# Install Rust (must use rustup, not package managers)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Verify Flutter
flutter doctor
```

**Platform-specific:**
- **Android**: Android Studio + SDK (NDK auto-installed)
- **iOS/macOS**: Xcode + Command Line Tools
- **Linux**: CMake, Ninja, Clang
- **Windows**: Visual Studio 2019+ with C++ tools

### Installation

**1. Clone this template**
```bash
cd your_flutter_app
git clone https://github.com/yourusername/app_core.git
cd app_core
```

**2. Add to your `pubspec.yaml`**
```yaml
dependencies:
  app_core:
    path: ./app_core
```

**3. Get dependencies**
```bash
flutter pub get
```

**4. Initialize in your app**
```dart
import 'package:flutter/material.dart';
import 'package:app_core/app_core.dart';

void main() {
  initAppCore();  // Initialize FFI runtime
  runApp(MyApp());
}
```

**5. Use FFI functions**
```dart
// Math operations
final sum = AppCore.sum(10, 20);        // 30
final product = AppCore.multiply(5, 6); // 30

// String operations
final reversed = AppCore.reverseString('hello');  // 'olleh'
final upper = AppCore.toUppercase('flutter');     // 'FLUTTER'
final greeting = AppCore.helloWorld();            // 'Hello from Rust!'

// Get version
final version = AppCore.getVersion();  // '0.1.0'
```

**6. First build**
```bash
flutter run
# First build: 5-10 minutes (compiling Rust dependencies)
# Subsequent builds: <1 minute (cached)
```

## Project Structure

```
app_core/
├── lib/                    # Dart code
│   ├── app_core.dart      # Main API
│   └── src/               # Extensions, platform loader
│
├── rust/                   # Rust library
│   ├── src/
│   │   ├── ffi/           # FFI utilities (memory, types, runtime)
│   │   ├── examples/      # Example FFI functions
│   │   └── lib.rs         # Library entry
│   ├── Cargo.toml
│   ├── cbindgen.toml      # C header generation config
│   └── build.rs           # Auto-generates C header
│
├── cargokit/              # Cross-platform Rust builds
├── android/               # Gradle + Cargokit
├── ios/                   # CocoaPods + Cargokit
├── macos/                 # CocoaPods + Cargokit
├── linux/                 # CMake + Cargokit
├── windows/               # CMake + Cargokit
├── test/                  # Dart tests
│
├── example/               # Demo app
│   └── lib/main.dart
│
├── scripts/
│   ├── regen_bindings.sh  # Rebuild + regenerate bindings
│   ├── test_all.sh        # Run all tests
│   └── rename_package.sh  # Rename package to your own name
│
├── pubspec.yaml           # Flutter package config
├── ffigen.yaml            # Dart binding generation config
│
└── docs/
    └── CREATING_YOUR_OWN.md  # Tutorial: Build your own FFI plugin
```

This is a standard Flutter plugin structure, ready for pub.dev publishing.

## Adding Custom Functions

### 1. Write Rust Code

```rust
// rust/src/examples/my_feature.rs
use std::ffi::c_char;
use crate::ffi::{CstrToRust, RustToCstr};

#[no_mangle]
pub extern "C" fn greet_user(name: *const c_char) -> *mut c_char {
    let name = name.to_native();  // Auto-frees Dart memory
    format!("Hello, {}!", name).to_cstr()  // Rust allocates
}
```

Add to `rust/src/examples/mod.rs`:
```rust
pub mod my_feature;
```

### 2. Regenerate Bindings

```bash
./scripts/regen_bindings.sh
```

This automatically:
- Builds Rust (`cargo build`)
- Generates C header (`build.rs` → `cbindgen`)
- Generates Dart bindings (`ffigen`)

### 3. Use in Dart

```dart
// Direct FFI binding
final greeting = bindings.greet_user('Alice'.toPtr()).toStr();

// Or wrap in AppCore class
class AppCore {
  static String greetUser(String name) {
    return bindings.greet_user(name.toPtr()).toStr();
  }
}
```

## Memory Management

### Pattern 1: Automatic Free (Recommended)

**Rust side:**
```rust
#[no_mangle]
pub extern "C" fn process_data(input: *const c_char) -> *mut c_char {
    let data = input.to_native();  // Auto-frees Dart memory
    let result = do_processing(&data);
    result.to_cstr()  // Rust allocates, Dart will free
}
```

**Dart side:**
```dart
final result = bindings.process_data(input.toPtr()).toStr();
// Both input and result automatically freed
```

### Pattern 2: Manual Control (Advanced)

```rust
let data = input.to_native_no_free();  // Dart still owns memory
```

```dart
final inputPtr = input.toPtr();
final resultPtr = bindings.process_data(inputPtr);
final result = resultPtr.toStrNoFree();
// Manual cleanup
bindings.free_c_string(resultPtr);
malloc.free(inputPtr);
```

## Async Operations

**Rust side:**
```rust
use irondash_dart_ffi::DartPort;

#[no_mangle]
pub extern "C" fn fetch_data_async(url: *const c_char, port: i64) {
    let url = url.to_native();
    let dart_port = DartPort::new(port);

    crate::ffi::spawn(async move {
        let result = simulate_network_fetch(&url).await;
        dart_port.send(result);  // Send directly to isolated port
    });
}
```

**Dart side:**
```dart
// Clean usage - just await!
final result = await AppCore.fetchDataAsync('https://example.com/api');
print('Got result: $result');

// With error handling
try {
  final data = await AppCore.processAsync('some data');
  print('Processed: $data');
} catch (e) {
  print('Error: $e');
}
```

**How it works:**
1. Dart creates isolated `ReceivePort` for each call
2. Passes port to Rust function
3. Rust spawns async task on multi-threaded runtime (uses all CPU cores)
4. Rust sends result directly to that port
5. Port auto-closes after receiving
6. **Truly parallel** - multiple calls run simultaneously across cores

**No global state, no request IDs, no complexity!**

## Blocking Operations with Isolates

**For CPU-intensive work that blocks:**

```dart
// Dart side - runs in isolate to prevent UI freezing
final result = await AppCore.fibonacci(40);  // Runs on separate isolate

// Implementation uses ffiCompute
static Future<int> fibonacci(int n) {
  return ffiCompute(_fibonacciWorker, n);
}

static int _fibonacciWorker(int n) {
  return bindings.fibonacci(n);  // Blocking Rust call
}
```

**Rust side:**
```rust
#[no_mangle]
pub extern "C" fn fibonacci(n: u64) -> u64 {
    // Blocking, CPU-intensive work
    match n {
        0 => 0,
        1 => 1,
        _ => fibonacci(n - 1) + fibonacci(n - 2),
    }
}
```

**When to use:**
- ✅ CPU-intensive computations
- ✅ Blocking operations (no tokio)
- ✅ Long-running synchronous work
- ❌ Don't use for async I/O (use `ffiAsync` instead)

## Platform Support

| Platform | Arch | Status |
|----------|------|--------|
| Android | arm64-v8a, armeabi-v7a, x86_64, x86 | ✅ |
| iOS | arm64, x86_64 (sim) | ✅ |
| macOS | arm64, x86_64 | ✅ |
| Linux | x86_64, arm64 | ✅ |
| Windows | x86_64 | ✅ |

## Running the Example

```bash
cd example
flutter run
```

The example app demonstrates:
- Math operations (sum, multiply)
- String manipulation (reverse, uppercase, concatenate)
- Memory management (automatic free)
- Async operations with isolated ports (truly parallel)
- Cross-platform FFI integration

## Development Workflow

```bash
# Add Rust function
vim rust/src/examples/my_feature.rs

# Regenerate bindings
./scripts/regen_bindings.sh

# Test
./scripts/test_all.sh

# Run example
cd example && flutter run
```

## Customizing the Template

### Quick Rename with Script

The easiest way to rename this package:

```bash
./scripts/rename_package.sh my_awesome_package MyAwesomePackage my_awesome_core
```

This automatically updates:
- Rust package name in `Cargo.toml`
- All platform configurations (Android, iOS, macOS, Linux, Windows)
- Dart package references
- Library loader
- Example app

### Manual Rename

If you prefer to rename manually:

**1. Update Rust:**
```toml
# rust/Cargo.toml
[package]
name = "my_core"
```

**2. Update platform configs:**
```gradle
// android/build.gradle
cargokit {
    libname = "my_core"
}
```

```ruby
# ios/app_core.podspec (and macos/)
:script => 'sh "$PODS_TARGET_SRCROOT/../cargokit/build_pod.sh" ../rust my_core',
:output_files => ["${BUILT_PRODUCTS_DIR}/libmy_core.a"],
```

```cmake
# linux/CMakeLists.txt (and windows/)
apply_cargokit(${PLUGIN_NAME} ${CMAKE_CURRENT_SOURCE_DIR}/../rust my_core)
```

```dart
// lib/src/platform_loader.dart
const String _libName = 'my_core';
```

**3. Rebuild:**
```bash
cd rust && cargo build
dart run ffigen
```

### Add Dependencies

**Rust:**
```toml
# rust/Cargo.toml
[dependencies]
reqwest = { version = "0.11", features = ["json"] }
```

**Dart:**
```yaml
# pubspec.yaml
dependencies:
  http: ^1.0.0
```

## Testing

```bash
# Rust tests
cd rust && cargo test

# Dart tests
flutter test

# Run all tests
./scripts/test_all.sh
```

## Performance

- **FFI call overhead**: ~50-100ns
- **String conversion**: ~1-2μs
- **Memory allocation**: ~100ns

## Build Times

| Type | First Build | Incremental |
|------|-------------|-------------|
| Debug | 3-5 min | 10-30 sec |
| Release | 5-10 min | 30-60 sec |
| Android (all ABIs) | 10-15 min | 1-2 min |

## Troubleshooting

### "Rust not found"
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

### Android NDK errors
```bash
flutter clean
flutter build apk  # Cargokit auto-installs NDK
```

### iOS simulator build fails
```bash
rustup target add x86_64-apple-ios aarch64-apple-ios-sim
```

### First build taking forever
This is normal! First build compiles all Rust dependencies (5-10 min). Subsequent builds use cache and are much faster (<1 min).

### Library not loaded at runtime
- Ensure `initAppCore()` is called before using FFI functions
- Check that first build completed successfully

## Learn More

- 📚 **[Creating Your Own FFI Plugin](docs/CREATING_YOUR_OWN.md)** - Complete tutorial
- 🦀 **[Rust FFI Guide](https://doc.rust-lang.org/nomicon/ffi.html)** - Official Rust docs
- 🎯 **[Dart FFI](https://dart.dev/guides/libraries/c-interop)** - Official Dart docs
- 🛠️ **[Cargokit](https://github.com/irondash/cargokit)** - Cross-platform Rust builds

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open a Pull Request

## License

MIT License - see [LICENSE](LICENSE) for details

## Credits

- [Cargokit](https://github.com/irondash/cargokit) by [irondash](https://github.com/irondash)
- Inspired by real-world production Flutter + Rust apps
- Built with ❤️ for the Flutter and Rust communities

---

**Build from source. Ship with confidence.** 🦀💙

Need help? Open an issue or check the [tutorial](docs/CREATING_YOUR_OWN.md)!
