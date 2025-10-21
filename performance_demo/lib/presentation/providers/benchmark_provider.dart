import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../domain/entities/benchmark_result.dart';

/// State for benchmark results
class BenchmarkState {
  final List<BenchmarkResult> results;
  final bool isLoading;
  final String? error;

  BenchmarkState({
    this.results = const [],
    this.isLoading = false,
    this.error,
  });

  BenchmarkState copyWith({
    List<BenchmarkResult>? results,
    bool? isLoading,
    String? error,
  }) {
    return BenchmarkState(
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Notifier for managing benchmark state
class BenchmarkNotifier extends StateNotifier<BenchmarkState> {
  final RunBenchmark _runBenchmarkUseCase;

  BenchmarkNotifier(this._runBenchmarkUseCase) : super(BenchmarkState());

  Future<void> runQuicksort(int size) async {
    await _executeBenchmark(() => _runBenchmarkUseCase.quicksort(size));
  }

  Future<void> runPrimeGeneration(int limit) async {
    await _executeBenchmark(() => _runBenchmarkUseCase.primeGeneration(limit));
  }

  Future<void> runSha256(String text) async {
    await _executeBenchmark(() => _runBenchmarkUseCase.sha256(text));
  }

  Future<void> runFibonacci(int n) async {
    await _executeBenchmark(() => _runBenchmarkUseCase.fibonacci(n));
  }

  Future<void> runMatrixMultiplication(int size) async {
    await _executeBenchmark(() => _runBenchmarkUseCase.matrixMultiplication(size));
  }

  Future<void> runJsonParsing(String json) async {
    await _executeBenchmark(() => _runBenchmarkUseCase.jsonParsing(json));
  }

  Future<void> runTextAnalysis(String text) async {
    await _executeBenchmark(() => _runBenchmarkUseCase.textAnalysis(text));
  }

  Future<void> runPiCalculation(int iterations) async {
    await _executeBenchmark(() => _runBenchmarkUseCase.piCalculation(iterations));
  }

  Future<void> runCompression(String text) async {
    await _executeBenchmark(() => _runBenchmarkUseCase.compression(text));
  }

  Future<void> _executeBenchmark(Future<BenchmarkResult> Function() benchmark) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await benchmark();
      state = state.copyWith(
        results: [...state.results, result],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearResults() {
    state = BenchmarkState();
  }

  void removeResult(int index) {
    final newResults = List<BenchmarkResult>.from(state.results);
    newResults.removeAt(index);
    state = state.copyWith(results: newResults);
  }
}

/// Provider for benchmark notifier
final benchmarkProvider = StateNotifierProvider<BenchmarkNotifier, BenchmarkState>((ref) {
  final runBenchmark = ref.watch(runBenchmarkProvider);
  return BenchmarkNotifier(runBenchmark);
});
