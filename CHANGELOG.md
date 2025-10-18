## 0.2.0

* **BREAKING**: Restructured to standard Flutter plugin layout (root-level structure)
  - Moved `dart_core/` contents to root
  - Renamed `rust_core/` to `rust/`
  - All platform configs now at root level
  - Simpler paths throughout (`../rust` instead of `../../rust_core`)
* Added `rename_package.sh` script for easy package customization
* Updated all documentation for new structure
* Ready for pub.dev publishing

## 0.1.0

* Initial release
* FFI bindings for Rust core library
* Memory management utilities
* Platform support: Android, iOS, macOS, Linux, Windows