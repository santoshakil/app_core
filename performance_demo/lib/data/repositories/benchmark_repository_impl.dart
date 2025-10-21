import 'dart:math';
import '../../domain/entities/benchmark_result.dart';
import '../../domain/repositories/benchmark_repository.dart';
import '../datasources/dart_performance_datasource.dart';
import '../datasources/rust_performance_datasource.dart';

class BenchmarkRepositoryImpl implements BenchmarkRepository {
  final DartPerformanceDataSource dartDataSource;
  final RustPerformanceDataSource rustDataSource;

  BenchmarkRepositoryImpl({
    required this.dartDataSource,
    required this.rustDataSource,
  });

  @override
  Future<BenchmarkResult> benchmarkQuicksort(int arraySize) async {
    // Generate random array
    final random = Random();
    final data = List.generate(arraySize, (_) => random.nextInt(10000));

    // Benchmark Dart
    final dartStopwatch = Stopwatch()..start();
    final dartSorted = dartDataSource.quicksort(data);
    dartStopwatch.stop();
    final dartResult = dartSorted.take(10).toString();

    // Benchmark Rust
    final rustStopwatch = Stopwatch()..start();
    final rustResult = rustDataSource.quicksort(data);
    rustStopwatch.stop();

    return BenchmarkResult(
      name: 'Quicksort ($arraySize items)',
      dartDuration: dartStopwatch.elapsed,
      rustDuration: rustStopwatch.elapsed,
      dartResult: dartResult,
      rustResult: rustResult,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<BenchmarkResult> benchmarkPrimeGeneration(int limit) async {
    // Benchmark Dart
    final dartStopwatch = Stopwatch()..start();
    final dartResult = dartDataSource.generatePrimes(limit);
    dartStopwatch.stop();

    // Benchmark Rust
    final rustStopwatch = Stopwatch()..start();
    final rustResult = rustDataSource.generatePrimes(limit);
    rustStopwatch.stop();

    return BenchmarkResult(
      name: 'Prime Generation (up to $limit)',
      dartDuration: dartStopwatch.elapsed,
      rustDuration: rustStopwatch.elapsed,
      dartResult: dartResult,
      rustResult: rustResult,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<BenchmarkResult> benchmarkSha256(String text) async {
    // Benchmark Dart
    final dartStopwatch = Stopwatch()..start();
    final dartResult = dartDataSource.sha256Hash(text);
    dartStopwatch.stop();

    // Benchmark Rust
    final rustStopwatch = Stopwatch()..start();
    final rustResult = rustDataSource.sha256Hash(text);
    rustStopwatch.stop();

    return BenchmarkResult(
      name: 'SHA-256 Hash (${text.length} chars)',
      dartDuration: dartStopwatch.elapsed,
      rustDuration: rustStopwatch.elapsed,
      dartResult: dartResult.substring(0, 16) + '...',
      rustResult: rustResult.substring(0, 16) + '...',
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<BenchmarkResult> benchmarkFibonacci(int n) async {
    // Benchmark Dart
    final dartStopwatch = Stopwatch()..start();
    final dartResult = dartDataSource.fibonacciSequence(n);
    dartStopwatch.stop();

    // Benchmark Rust
    final rustStopwatch = Stopwatch()..start();
    final rustResult = rustDataSource.fibonacciSequence(n);
    rustStopwatch.stop();

    return BenchmarkResult(
      name: 'Fibonacci Sequence (n=$n)',
      dartDuration: dartStopwatch.elapsed,
      rustDuration: rustStopwatch.elapsed,
      dartResult: dartResult,
      rustResult: rustResult,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<BenchmarkResult> benchmarkMatrixMultiplication(int size) async {
    // Benchmark Dart
    final dartStopwatch = Stopwatch()..start();
    final dartResult = dartDataSource.matrixMultiply(size);
    dartStopwatch.stop();

    // Benchmark Rust
    final rustStopwatch = Stopwatch()..start();
    final rustResult = rustDataSource.matrixMultiply(size);
    rustStopwatch.stop();

    return BenchmarkResult(
      name: 'Matrix Multiplication (${size}x$size)',
      dartDuration: dartStopwatch.elapsed,
      rustDuration: rustStopwatch.elapsed,
      dartResult: dartResult,
      rustResult: rustResult,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<BenchmarkResult> benchmarkJsonParsing(String jsonData) async {
    // Benchmark Dart
    final dartStopwatch = Stopwatch()..start();
    final dartResult = dartDataSource.parseJson(jsonData);
    dartStopwatch.stop();

    // Benchmark Rust
    final rustStopwatch = Stopwatch()..start();
    final rustResult = rustDataSource.parseJson(jsonData);
    rustStopwatch.stop();

    return BenchmarkResult(
      name: 'JSON Parsing',
      dartDuration: dartStopwatch.elapsed,
      rustDuration: rustStopwatch.elapsed,
      dartResult: dartResult.length > 50 ? '${dartResult.substring(0, 50)}...' : dartResult,
      rustResult: rustResult.length > 50 ? '${rustResult.substring(0, 50)}...' : rustResult,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<BenchmarkResult> benchmarkTextAnalysis(String text) async {
    // Benchmark Dart
    final dartStopwatch = Stopwatch()..start();
    final dartResult = dartDataSource.analyzeText(text);
    dartStopwatch.stop();

    // Benchmark Rust
    final rustStopwatch = Stopwatch()..start();
    final rustResult = rustDataSource.analyzeText(text);
    rustStopwatch.stop();

    return BenchmarkResult(
      name: 'Text Analysis',
      dartDuration: dartStopwatch.elapsed,
      rustDuration: rustStopwatch.elapsed,
      dartResult: dartResult,
      rustResult: rustResult,
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<BenchmarkResult> benchmarkPiCalculation(int iterations) async {
    // Benchmark Dart
    final dartStopwatch = Stopwatch()..start();
    final dartPi = dartDataSource.calculatePi(iterations);
    dartStopwatch.stop();

    // Benchmark Rust
    final rustStopwatch = Stopwatch()..start();
    final rustPi = rustDataSource.calculatePi(iterations);
    rustStopwatch.stop();

    return BenchmarkResult(
      name: 'Pi Calculation ($iterations iterations)',
      dartDuration: dartStopwatch.elapsed,
      rustDuration: rustStopwatch.elapsed,
      dartResult: 'π ≈ ${dartPi.toStringAsFixed(6)}',
      rustResult: 'π ≈ ${rustPi.toStringAsFixed(6)}',
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<BenchmarkResult> benchmarkCompression(String text) async {
    // Benchmark Dart
    final dartStopwatch = Stopwatch()..start();
    final dartResult = dartDataSource.compressRle(text);
    dartStopwatch.stop();

    // Benchmark Rust
    final rustStopwatch = Stopwatch()..start();
    final rustResult = rustDataSource.compressRle(text);
    rustStopwatch.stop();

    final compressionRatio = (text.length - dartResult.length) / text.length * 100;

    return BenchmarkResult(
      name: 'RLE Compression',
      dartDuration: dartStopwatch.elapsed,
      rustDuration: rustStopwatch.elapsed,
      dartResult: '${dartResult.substring(0, dartResult.length > 30 ? 30 : dartResult.length)}... (${compressionRatio.toStringAsFixed(1)}% smaller)',
      rustResult: '${rustResult.substring(0, rustResult.length > 30 ? 30 : rustResult.length)}... (${compressionRatio.toStringAsFixed(1)}% smaller)',
      timestamp: DateTime.now(),
    );
  }
}
