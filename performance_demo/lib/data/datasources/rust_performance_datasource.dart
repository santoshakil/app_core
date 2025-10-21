import 'dart:ffi';
import 'package:app_core/app_core.dart';
import 'package:ffi/ffi.dart';

/// Data source for Rust FFI implementations
class RustPerformanceDataSource {
  final DynamicLibrary _lib;

  RustPerformanceDataSource(this._lib);

  /// Quicksort implementation
  String quicksort(List<int> data) {
    final ptr = calloc<Int32>(data.length);
    for (var i = 0; i < data.length; i++) {
      ptr[i] = data[i];
    }

    try {
      final rustQuicksort = _lib.lookupFunction<
          Pointer<Utf8> Function(Pointer<Int32>, IntPtr),
          Pointer<Utf8> Function(Pointer<Int32>, int)>('rust_quicksort');

      final resultPtr = rustQuicksort(ptr, data.length);
      final result = resultPtr.toDartString();
      calloc.free(resultPtr);
      return result;
    } finally {
      calloc.free(ptr);
    }
  }

  /// Generate prime numbers
  String generatePrimes(int limit) {
    final rustGeneratePrimes = _lib.lookupFunction<
        Pointer<Utf8> Function(Uint32),
        Pointer<Utf8> Function(int)>('rust_generate_primes');

    final resultPtr = rustGeneratePrimes(limit);
    final result = resultPtr.toDartString();
    calloc.free(resultPtr);
    return result;
  }

  /// Calculate SHA-256 hash
  String sha256Hash(String text) {
    final textPtr = text.toNativeUtf8();

    try {
      final rustSha256 = _lib.lookupFunction<
          Pointer<Utf8> Function(Pointer<Utf8>),
          Pointer<Utf8> Function(Pointer<Utf8>)>('rust_sha256');

      final resultPtr = rustSha256(textPtr);
      final result = resultPtr.toDartString();
      calloc.free(resultPtr);
      return result;
    } finally {
      calloc.free(textPtr);
    }
  }

  /// Generate Fibonacci sequence
  String fibonacciSequence(int n) {
    final rustFibonacci = _lib.lookupFunction<
        Pointer<Utf8> Function(Uint32),
        Pointer<Utf8> Function(int)>('rust_fibonacci_sequence');

    final resultPtr = rustFibonacci(n);
    final result = resultPtr.toDartString();
    calloc.free(resultPtr);
    return result;
  }

  /// Matrix multiplication
  String matrixMultiply(int size) {
    final rustMatrixMultiply = _lib.lookupFunction<
        Pointer<Utf8> Function(IntPtr),
        Pointer<Utf8> Function(int)>('rust_matrix_multiply');

    final resultPtr = rustMatrixMultiply(size);
    final result = resultPtr.toDartString();
    calloc.free(resultPtr);
    return result;
  }

  /// Parse and manipulate JSON
  String parseJson(String jsonStr) {
    final jsonPtr = jsonStr.toNativeUtf8();

    try {
      final rustJsonParse = _lib.lookupFunction<
          Pointer<Utf8> Function(Pointer<Utf8>),
          Pointer<Utf8> Function(Pointer<Utf8>)>('rust_json_parse');

      final resultPtr = rustJsonParse(jsonPtr);
      final result = resultPtr.toDartString();
      calloc.free(resultPtr);
      return result;
    } finally {
      calloc.free(jsonPtr);
    }
  }

  /// Text analysis
  String analyzeText(String text) {
    final textPtr = text.toNativeUtf8();

    try {
      final rustTextAnalysis = _lib.lookupFunction<
          Pointer<Utf8> Function(Pointer<Utf8>),
          Pointer<Utf8> Function(Pointer<Utf8>)>('rust_text_analysis');

      final resultPtr = rustTextAnalysis(textPtr);
      final result = resultPtr.toDartString();
      calloc.free(resultPtr);
      return result;
    } finally {
      calloc.free(textPtr);
    }
  }

  /// Calculate Pi using Monte Carlo method
  double calculatePi(int iterations) {
    final rustCalculatePi = _lib.lookupFunction<Double Function(Uint32),
        double Function(int)>('rust_calculate_pi');

    return rustCalculatePi(iterations);
  }

  /// Run-length encoding compression
  String compressRle(String input) {
    final inputPtr = input.toNativeUtf8();

    try {
      final rustCompressRle = _lib.lookupFunction<
          Pointer<Utf8> Function(Pointer<Utf8>),
          Pointer<Utf8> Function(Pointer<Utf8>)>('rust_compress_rle');

      final resultPtr = rustCompressRle(inputPtr);
      final result = resultPtr.toDartString();
      calloc.free(resultPtr);
      return result;
    } finally {
      calloc.free(inputPtr);
    }
  }
}
