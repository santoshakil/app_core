import '../entities/benchmark_result.dart';

/// Repository interface for benchmark operations
abstract class BenchmarkRepository {
  /// Sort a large array using quicksort
  Future<BenchmarkResult> benchmarkQuicksort(int arraySize);

  /// Generate prime numbers
  Future<BenchmarkResult> benchmarkPrimeGeneration(int limit);

  /// Calculate SHA-256 hash
  Future<BenchmarkResult> benchmarkSha256(String text);

  /// Generate Fibonacci sequence
  Future<BenchmarkResult> benchmarkFibonacci(int n);

  /// Multiply matrices
  Future<BenchmarkResult> benchmarkMatrixMultiplication(int size);

  /// Parse and manipulate JSON
  Future<BenchmarkResult> benchmarkJsonParsing(String jsonData);

  /// Analyze text
  Future<BenchmarkResult> benchmarkTextAnalysis(String text);

  /// Calculate Pi using Monte Carlo
  Future<BenchmarkResult> benchmarkPiCalculation(int iterations);

  /// Compress text using RLE
  Future<BenchmarkResult> benchmarkCompression(String text);
}
