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
          Pointer<Char> Function(Pointer<Int32>, IntPtr),
          Pointer<Char> Function(Pointer<Int32>, int)>('rust_quicksort');

      final resultPtr = rustQuicksort(ptr, data.length);
      return resultPtr.toStr(); // Uses app_core's extension which frees memory
    } finally {
      calloc.free(ptr);
    }
  }

  /// Generate prime numbers
  String generatePrimes(int limit) {
    final rustGeneratePrimes = _lib.lookupFunction<
        Pointer<Char> Function(Uint32),
        Pointer<Char> Function(int)>('rust_generate_primes');

    final resultPtr = rustGeneratePrimes(limit);
    return resultPtr.toStr();
  }

  /// Calculate SHA-256 hash
  String sha256Hash(String text) {
    final textPtr = text.toPtr();

    final rustSha256 = _lib.lookupFunction<
        Pointer<Char> Function(Pointer<Char>),
        Pointer<Char> Function(Pointer<Char>)>('rust_sha256');

    final resultPtr = rustSha256(textPtr);
    return resultPtr.toStr();
  }

  /// Generate Fibonacci sequence
  String fibonacciSequence(int n) {
    final rustFibonacci = _lib.lookupFunction<
        Pointer<Char> Function(Uint32),
        Pointer<Char> Function(int)>('rust_fibonacci_sequence');

    final resultPtr = rustFibonacci(n);
    return resultPtr.toStr();
  }

  /// Matrix multiplication
  String matrixMultiply(int size) {
    final rustMatrixMultiply = _lib.lookupFunction<
        Pointer<Char> Function(IntPtr),
        Pointer<Char> Function(int)>('rust_matrix_multiply');

    final resultPtr = rustMatrixMultiply(size);
    return resultPtr.toStr();
  }

  /// Parse and manipulate JSON
  String parseJson(String jsonStr) {
    final jsonPtr = jsonStr.toPtr();

    final rustJsonParse = _lib.lookupFunction<
        Pointer<Char> Function(Pointer<Char>),
        Pointer<Char> Function(Pointer<Char>)>('rust_json_parse');

    final resultPtr = rustJsonParse(jsonPtr);
    return resultPtr.toStr();
  }

  /// Text analysis
  String analyzeText(String text) {
    final textPtr = text.toPtr();

    final rustTextAnalysis = _lib.lookupFunction<
        Pointer<Char> Function(Pointer<Char>),
        Pointer<Char> Function(Pointer<Char>)>('rust_text_analysis');

    final resultPtr = rustTextAnalysis(textPtr);
    return resultPtr.toStr();
  }

  /// Calculate Pi using Monte Carlo method
  double calculatePi(int iterations) {
    final rustCalculatePi = _lib.lookupFunction<Double Function(Uint32),
        double Function(int)>('rust_calculate_pi');

    return rustCalculatePi(iterations);
  }

  /// Run-length encoding compression
  String compressRle(String input) {
    final inputPtr = input.toPtr();

    final rustCompressRle = _lib.lookupFunction<
        Pointer<Char> Function(Pointer<Char>),
        Pointer<Char> Function(Pointer<Char>)>('rust_compress_rle');

    final resultPtr = rustCompressRle(inputPtr);
    return resultPtr.toStr();
  }
}
