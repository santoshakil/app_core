import 'dart:ffi';

import 'package:flutter/foundation.dart';

import 'app_core_bindings_generated.dart';
import 'src/async_helper.dart';
import 'src/ffi_extensions.dart';
import 'src/platform_loader.dart';
import 'src/isolate_helper.dart';

export 'app_core_bindings_generated.dart';
export 'src/ffi_extensions.dart';
export 'src/memory.dart';

final DynamicLibrary _dylib = loadLibrary();

final AppCoreBindings bindings = AppCoreBindings(_dylib);

bool _dartApiInitialized = false;

void initAppCore() {
  try {
    bindings.init_runtime();
    if (!_dartApiInitialized) {
      bindings.init_dart_api(NativeApi.initializeApiDLData);
      _dartApiInitialized = true;
    }
    debugPrint('AppCore initialized - version: ${AppCore.getVersion()}');
  } catch (e, stack) {
    debugPrint('Error initializing AppCore: $e');
    debugPrint('Stack: $stack');
    rethrow;
  }
}

class AppCore {
  AppCore._();

  static int sum(int a, int b) {
    return bindings.sum(a, b);
  }

  static int multiply(int a, int b) {
    return bindings.multiply(a, b);
  }

  static String helloWorld() {
    return bindings.hello_world().toStr();
  }

  static String reverseString(String input) {
    return bindings.reverse_string(input.toPtr()).toStr();
  }

  static String toUppercase(String input) {
    return bindings.to_uppercase(input.toPtr()).toStr();
  }

  static String concatenate(String a, String b) {
    return bindings.concatenate(a.toPtr(), b.toPtr()).toStr();
  }

  static int stringLength(String input) {
    return bindings.string_length(input.toPtr());
  }

  static String getVersion() {
    return bindings.get_version().toStr();
  }

  static Future<String> fetchDataAsync(String url) {
    return ffiAsync(
      (port) => bindings.fetch_data_async(url.toPtr(), port),
      (msg) => msg as String,
    );
  }

  static Future<String> processAsync(String data) {
    return ffiAsync(
      (port) => bindings.process_async(data.toPtr(), port),
      (msg) => msg as String,
    );
  }

  static Future<int> fibonacci(int n) {
    return ffiCompute(_fibonacciWorker, n);
  }

  static int _fibonacciWorker(int n) {
    return bindings.fibonacci(n);
  }

  static Future<int> heavyComputation(int iterations) {
    return ffiCompute(_heavyWorker, iterations);
  }

  static int _heavyWorker(int iterations) {
    return bindings.heavy_computation(iterations);
  }
}
