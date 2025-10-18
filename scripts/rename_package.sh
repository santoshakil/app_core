#!/bin/bash
set -e

if [ "$#" -ne 3 ]; then
    echo "Usage: ./rename_package.sh <package_name> <ClassName> <lib_name>"
    echo ""
    echo "Example:"
    echo "  ./rename_package.sh my_awesome_package MyAwesomePackage my_awesome_core"
    echo ""
    echo "Arguments:"
    echo "  package_name: Dart package name (snake_case, e.g., my_awesome_package)"
    echo "  ClassName:    Main API class name (PascalCase, e.g., MyAwesomePackage)"
    echo "  lib_name:     Native library name (snake_case, e.g., my_awesome_core)"
    exit 1
fi

PACKAGE_NAME=$1
CLASS_NAME=$2
LIB_NAME=$3

echo "🔄 Renaming package..."
echo "  Package: app_core -> $PACKAGE_NAME"
echo "  Class:   AppCore -> $CLASS_NAME"
echo "  Library: rust_core -> $LIB_NAME"
echo ""

# Rust crate name
echo "📦 Updating Rust configuration..."
sed -i '' "s/name = \"rust_core\"/name = \"$LIB_NAME\"/" rust/Cargo.toml
sed -i '' "s/^rust_core = /\"$LIB_NAME\" = /" rust/Cargo.toml

# Dart package name
echo "📦 Updating Dart package configuration..."
sed -i '' "s/name: app_core/name: $PACKAGE_NAME/" pubspec.yaml
sed -i '' "s/description: .*/description: $CLASS_NAME Flutter FFI plugin/" pubspec.yaml

# Platform configs - Android
echo "🤖 Updating Android configuration..."
sed -i '' "s/libname = \"rust_core\"/libname = \"$LIB_NAME\"/" android/build.gradle
sed -i '' "s/group = \"com.example.app_core\"/group = \"com.example.$PACKAGE_NAME\"/" android/build.gradle
sed -i '' "s/namespace = \"com.example.app_core\"/namespace = \"com.example.$PACKAGE_NAME\"/" android/build.gradle

# Platform configs - iOS
echo "🍎 Updating iOS configuration..."
sed -i '' "s/s.name.*=.*'app_core'/s.name             = '$PACKAGE_NAME'/" ios/*.podspec
sed -i '' "s/rust_core/$LIB_NAME/g" ios/*.podspec

# Platform configs - macOS
echo "💻 Updating macOS configuration..."
sed -i '' "s/s.name.*=.*'app_core'/s.name             = '$PACKAGE_NAME'/" macos/*.podspec
sed -i '' "s/rust_core/$LIB_NAME/g" macos/*.podspec

# Platform configs - Linux
echo "🐧 Updating Linux configuration..."
sed -i '' "s/set(PROJECT_NAME \"app_core\")/set(PROJECT_NAME \"$PACKAGE_NAME\")/" linux/CMakeLists.txt
sed -i '' "s/set(PLUGIN_NAME \"app_core_plugin\")/set(PLUGIN_NAME \"${PACKAGE_NAME}_plugin\")/" linux/CMakeLists.txt
sed -i '' "s/rust_core/$LIB_NAME/g" linux/CMakeLists.txt

# Platform configs - Windows
echo "🪟 Updating Windows configuration..."
sed -i '' "s/set(PROJECT_NAME \"app_core\")/set(PROJECT_NAME \"$PACKAGE_NAME\")/" windows/CMakeLists.txt
sed -i '' "s/set(PLUGIN_NAME \"app_core_plugin\")/set(PLUGIN_NAME \"${PACKAGE_NAME}_plugin\")/" windows/CMakeLists.txt
sed -i '' "s/rust_core/$LIB_NAME/g" windows/CMakeLists.txt

# Dart platform loader
echo "🎯 Updating Dart platform loader..."
sed -i '' "s/const String _pluginName = 'app_core'/const String _pluginName = '$PACKAGE_NAME'/" lib/src/platform_loader.dart
sed -i '' "s/const String _libName = 'rust_core'/const String _libName = '$LIB_NAME'/" lib/src/platform_loader.dart

# Rename main Dart file
echo "📝 Renaming main Dart file..."
if [ -f "lib/app_core.dart" ]; then
    git mv lib/app_core.dart lib/$PACKAGE_NAME.dart
fi
sed -i '' "s/class AppCore/class $CLASS_NAME/g" lib/$PACKAGE_NAME.dart
sed -i '' "s/AppCore\./$CLASS_NAME./g" lib/$PACKAGE_NAME.dart

# Update bindings file reference
sed -i '' "s/app_core_bindings_generated/${PACKAGE_NAME}_bindings_generated/" lib/$PACKAGE_NAME.dart

# Update ffigen output
echo "🔧 Updating ffigen configuration..."
sed -i '' "s/name: AppCoreBindings/name: ${CLASS_NAME}Bindings/" ffigen.yaml
sed -i '' "s|output: \"lib/app_core_bindings_generated.dart\"|output: \"lib/${PACKAGE_NAME}_bindings_generated.dart\"|" ffigen.yaml

# Rename generated bindings if it exists
if [ -f "lib/app_core_bindings_generated.dart" ]; then
    git mv lib/app_core_bindings_generated.dart lib/${PACKAGE_NAME}_bindings_generated.dart
fi

# Update example app
echo "📱 Updating example app..."
sed -i '' "s/app_core:/$PACKAGE_NAME:/" example/pubspec.yaml
sed -i '' "s|path: ../dart_core|path: ..|" example/pubspec.yaml
sed -i '' "s/package:app_core/package:$PACKAGE_NAME/g" example/lib/main.dart
sed -i '' "s/AppCore/$CLASS_NAME/g" example/lib/main.dart
sed -i '' "s/initAppCore/init$CLASS_NAME/g" example/lib/main.dart

# Update src files
echo "🔨 Updating source files..."
if [ -f "src/rust_core.c" ]; then
    git mv src/rust_core.c src/$LIB_NAME.c
fi
if [ -f "src/rust_core.h" ]; then
    git mv src/rust_core.h src/$LIB_NAME.h
fi
sed -i '' "s/rust_core/$LIB_NAME/g" src/CMakeLists.txt
sed -i '' "s/app_core/$PACKAGE_NAME/g" src/CMakeLists.txt

echo ""
echo "✅ Rename complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Review changes: git status"
echo "  2. Update README.md and CHANGELOG.md manually"
echo "  3. Regenerate bindings: ./scripts/regen_bindings.sh"
echo "  4. Run tests: ./scripts/test_all.sh"
echo "  5. Test example: cd example && flutter run"
echo "  6. Commit changes: git add . && git commit -m 'Rename to $PACKAGE_NAME'"
echo ""
