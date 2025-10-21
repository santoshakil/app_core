import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/entities/benchmark_result.dart';

class BenchmarkCard extends StatelessWidget {
  final BenchmarkResult result;
  final VoidCallback? onDelete;

  const BenchmarkCard({
    super.key,
    required this.result,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final speedup = result.speedupFactor;
    final winner = result.winner;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    result.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor,
                        ),
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: onDelete,
                    color: Colors.white54,
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Performance bars
            _buildPerformanceBar(
              context,
              'Dart',
              result.dartDuration,
              Colors.blue,
              result.dartDuration,
            ),
            const SizedBox(height: 12),
            _buildPerformanceBar(
              context,
              'Rust',
              result.rustDuration,
              AppTheme.accentColor,
              result.dartDuration,
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Statistics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(
                  context,
                  'Winner',
                  winner,
                  winner == 'Rust' ? AppTheme.accentColor : Colors.blue,
                ),
                _buildStat(
                  context,
                  'Speedup',
                  '${speedup.toStringAsFixed(2)}x',
                  AppTheme.secondaryColor,
                ),
                _buildStat(
                  context,
                  'Improvement',
                  '${result.improvementPercentage.toStringAsFixed(1)}%',
                  AppTheme.primaryColor,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Results preview
            _buildResultPreview(context, 'Dart', result.dartResult),
            const SizedBox(height: 8),
            _buildResultPreview(context, 'Rust', result.rustResult),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceBar(
    BuildContext context,
    String label,
    Duration duration,
    Color color,
    Duration maxDuration,
  ) {
    final percentage = duration.inMicroseconds / maxDuration.inMicroseconds;
    final durationText = _formatDuration(duration);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              durationText,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.white.withOpacity(0.1),
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildStat(BuildContext context, String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildResultPreview(BuildContext context, String label, String result) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: label == 'Dart' ? Colors.blue.withOpacity(0.2) : AppTheme.accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: label == 'Dart' ? Colors.blue : AppTheme.accentColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              result,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMilliseconds >= 1000) {
      return '${(duration.inMilliseconds / 1000).toStringAsFixed(2)}s';
    } else if (duration.inMicroseconds >= 1000) {
      return '${(duration.inMicroseconds / 1000).toStringAsFixed(2)}ms';
    } else {
      return '${duration.inMicroseconds}μs';
    }
  }
}
