import 'dart:ffi';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_core/src/platform_loader.dart';
import '../../data/datasources/dart_performance_datasource.dart';
import '../../data/datasources/rust_performance_datasource.dart';
import '../../data/repositories/benchmark_repository_impl.dart';
import '../../domain/repositories/benchmark_repository.dart';
import '../../domain/usecases/run_benchmark.dart';

/// Provider for DynamicLibrary
/// Uses the same library loader as app_core
final dynamicLibraryProvider = Provider<DynamicLibrary>((ref) {
  // Use app_core's platform-specific library loader
  return loadLibrary();
});

/// Provider for Dart data source
final dartDataSourceProvider = Provider<DartPerformanceDataSource>((ref) {
  return DartPerformanceDataSource();
});

/// Provider for Rust data source
final rustDataSourceProvider = Provider<RustPerformanceDataSource>((ref) {
  final lib = ref.watch(dynamicLibraryProvider);
  return RustPerformanceDataSource(lib);
});

/// Provider for benchmark repository
final benchmarkRepositoryProvider = Provider<BenchmarkRepository>((ref) {
  final dartDataSource = ref.watch(dartDataSourceProvider);
  final rustDataSource = ref.watch(rustDataSourceProvider);

  return BenchmarkRepositoryImpl(
    dartDataSource: dartDataSource,
    rustDataSource: rustDataSource,
  );
});

/// Provider for run benchmark use case
final runBenchmarkProvider = Provider<RunBenchmark>((ref) {
  final repository = ref.watch(benchmarkRepositoryProvider);
  return RunBenchmark(repository);
});
