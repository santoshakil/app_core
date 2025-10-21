import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../providers/benchmark_provider.dart';
import '../widgets/benchmark_button.dart';
import '../widgets/benchmark_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final benchmarkState = ref.watch(benchmarkProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Dart vs Rust FFI'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.secondaryColor,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.speed,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
            actions: [
              if (benchmarkState.results.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear_all),
                  onPressed: () {
                    ref.read(benchmarkProvider.notifier).clearResults();
                  },
                  tooltip: 'Clear all results',
                ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(context),
                  const SizedBox(height: 24),
                  Text(
                    'Performance Benchmarks',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                BenchmarkButton(
                  icon: Icons.sort,
                  title: 'Quicksort',
                  description: 'Sort 50,000 random integers',
                  color: Colors.purple,
                  isLoading: benchmarkState.isLoading,
                  onPressed: () {
                    ref.read(benchmarkProvider.notifier).runQuicksort(50000);
                  },
                ),
                BenchmarkButton(
                  icon: Icons.numbers,
                  title: 'Prime Numbers',
                  description: 'Generate primes up to 100,000',
                  color: Colors.orange,
                  isLoading: benchmarkState.isLoading,
                  onPressed: () {
                    ref.read(benchmarkProvider.notifier).runPrimeGeneration(100000);
                  },
                ),
                BenchmarkButton(
                  icon: Icons.lock,
                  title: 'SHA-256 Hash',
                  description: 'Hash a large text document',
                  color: Colors.red,
                  isLoading: benchmarkState.isLoading,
                  onPressed: () {
                    final largeText = List.generate(10000, (i) => 'Lorem ipsum dolor sit amet $i').join(' ');
                    ref.read(benchmarkProvider.notifier).runSha256(largeText);
                  },
                ),
                BenchmarkButton(
                  icon: Icons.calculate,
                  title: 'Fibonacci',
                  description: 'Calculate Fibonacci(50)',
                  color: Colors.teal,
                  isLoading: benchmarkState.isLoading,
                  onPressed: () {
                    ref.read(benchmarkProvider.notifier).runFibonacci(50);
                  },
                ),
                BenchmarkButton(
                  icon: Icons.grid_on,
                  title: 'Matrix Multiplication',
                  description: 'Multiply 100x100 matrices',
                  color: Colors.indigo,
                  isLoading: benchmarkState.isLoading,
                  onPressed: () {
                    ref.read(benchmarkProvider.notifier).runMatrixMultiplication(100);
                  },
                ),
                BenchmarkButton(
                  icon: Icons.code,
                  title: 'JSON Parsing',
                  description: 'Parse and manipulate JSON data',
                  color: Colors.green,
                  isLoading: benchmarkState.isLoading,
                  onPressed: () {
                    final json = jsonEncode({
                      'users': List.generate(
                        1000,
                        (i) => {
                          'id': i,
                          'name': 'User $i',
                          'email': 'user$i@example.com',
                          'age': 20 + (i % 50),
                        },
                      ),
                    });
                    ref.read(benchmarkProvider.notifier).runJsonParsing(json);
                  },
                ),
                BenchmarkButton(
                  icon: Icons.text_fields,
                  title: 'Text Analysis',
                  description: 'Analyze word count and statistics',
                  color: Colors.amber,
                  isLoading: benchmarkState.isLoading,
                  onPressed: () {
                    final text = List.generate(5000, (i) => 'The quick brown fox jumps over the lazy dog. ').join();
                    ref.read(benchmarkProvider.notifier).runTextAnalysis(text);
                  },
                ),
                BenchmarkButton(
                  icon: Icons.pie_chart,
                  title: 'Pi Calculation',
                  description: 'Monte Carlo with 1M iterations',
                  color: Colors.pink,
                  isLoading: benchmarkState.isLoading,
                  onPressed: () {
                    ref.read(benchmarkProvider.notifier).runPiCalculation(1000000);
                  },
                ),
                BenchmarkButton(
                  icon: Icons.compress,
                  title: 'RLE Compression',
                  description: 'Compress text with run-length encoding',
                  color: Colors.cyan,
                  isLoading: benchmarkState.isLoading,
                  onPressed: () {
                    final text = 'aaaaaabbbbbbccccccdddddd' * 1000;
                    ref.read(benchmarkProvider.notifier).runCompression(text);
                  },
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          if (benchmarkState.results.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Results',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final result = benchmarkState.results[benchmarkState.results.length - 1 - index];
                  return BenchmarkCard(
                    result: result,
                    onDelete: () {
                      ref.read(benchmarkProvider.notifier).removeResult(benchmarkState.results.length - 1 - index);
                    },
                  );
                },
                childCount: benchmarkState.results.length,
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      color: AppTheme.primaryColor.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.secondaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  'About This Demo',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.secondaryColor,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'This app demonstrates real-world performance differences between pure Dart and Rust via FFI. '
              'Each benchmark runs the same algorithm in both languages and compares execution time.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip('Clean Architecture', Colors.blue),
                _buildChip('SOLID Principles', Colors.green),
                _buildChip('Riverpod', Colors.purple),
                _buildChip('FFI', Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
