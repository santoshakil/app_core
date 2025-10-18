import 'dart:ffi';
import 'dart:io';

const String _pluginName = 'app_core';
const String _libName = 'rust_core';

DynamicLibrary loadLibrary() {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_pluginName.framework/$_pluginName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}
