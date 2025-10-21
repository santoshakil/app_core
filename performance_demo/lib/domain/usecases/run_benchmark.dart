import '../entities/benchmark_result.dart';
import '../repositories/benchmark_repository.dart';

/// Use case for running benchmarks
class RunBenchmark {
  final BenchmarkRepository repository;

  RunBenchmark(this.repository);

  Future<BenchmarkResult> quicksort(int arraySize) {
    return repository.benchmarkQuicksort(arraySize);
  }

  Future<BenchmarkResult> primeGeneration(int limit) {
    return repository.benchmarkPrimeGeneration(limit);
  }

  Future<BenchmarkResult> sha256(String text) {
    return repository.benchmarkSha256(text);
  }

  Future<BenchmarkResult> fibonacci(int n) {
    return repository.benchmarkFibonacci(n);
  }

  Future<BenchmarkResult> matrixMultiplication(int size) {
    return repository.benchmarkMatrixMultiplication(size);
  }

  Future<BenchmarkResult> jsonParsing(String jsonData) {
    return repository.benchmarkJsonParsing(jsonData);
  }

  Future<BenchmarkResult> textAnalysis(String text) {
    return repository.benchmarkTextAnalysis(text);
  }

  Future<BenchmarkResult> piCalculation(int iterations) {
    return repository.benchmarkPiCalculation(iterations);
  }

  Future<BenchmarkResult> compression(String text) {
    return repository.benchmarkCompression(text);
  }
}
