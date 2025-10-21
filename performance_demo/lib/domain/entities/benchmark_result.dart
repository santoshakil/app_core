/// Represents a single benchmark result
class BenchmarkResult {
  final String name;
  final Duration dartDuration;
  final Duration rustDuration;
  final String dartResult;
  final String rustResult;
  final DateTime timestamp;

  BenchmarkResult({
    required this.name,
    required this.dartDuration,
    required this.rustDuration,
    required this.dartResult,
    required this.rustResult,
    required this.timestamp,
  });

  /// Performance improvement factor (how many times faster Rust is)
  double get speedupFactor {
    if (dartDuration.inMicroseconds == 0) return 0;
    return dartDuration.inMicroseconds / rustDuration.inMicroseconds;
  }

  /// Percentage improvement
  double get improvementPercentage {
    if (dartDuration.inMicroseconds == 0) return 0;
    return ((dartDuration.inMicroseconds - rustDuration.inMicroseconds) /
            dartDuration.inMicroseconds) *
        100;
  }

  /// Which implementation is faster
  String get winner {
    if (rustDuration < dartDuration) return 'Rust';
    if (dartDuration < rustDuration) return 'Dart';
    return 'Tie';
  }
}
