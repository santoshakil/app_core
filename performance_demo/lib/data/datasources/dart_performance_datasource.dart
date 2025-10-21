import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Data source for pure Dart implementations
class DartPerformanceDataSource {
  /// Quicksort implementation
  List<int> quicksort(List<int> data) {
    if (data.length <= 1) return data;

    final pivot = data[data.length ~/ 2];
    final less = data.where((x) => x < pivot).toList();
    final equal = data.where((x) => x == pivot).toList();
    final greater = data.where((x) => x > pivot).toList();

    return [...quicksort(less), ...equal, ...quicksort(greater)];
  }

  /// Bubble sort implementation
  List<int> bubbleSort(List<int> data) {
    final arr = List<int>.from(data);
    for (var i = 0; i < arr.length; i++) {
      for (var j = 0; j < arr.length - i - 1; j++) {
        if (arr[j] > arr[j + 1]) {
          final temp = arr[j];
          arr[j] = arr[j + 1];
          arr[j + 1] = temp;
        }
      }
    }
    return arr;
  }

  /// Generate prime numbers using Sieve of Eratosthenes
  String generatePrimes(int limit) {
    if (limit < 2) return 'Count: 0, First 10: []';

    final isPrime = List<bool>.filled(limit + 1, true);
    isPrime[0] = false;
    isPrime[1] = false;

    for (var i = 2; i <= sqrt(limit); i++) {
      if (isPrime[i]) {
        for (var j = i * i; j <= limit; j += i) {
          isPrime[j] = false;
        }
      }
    }

    final primes = <int>[];
    for (var i = 0; i < isPrime.length; i++) {
      if (isPrime[i]) primes.add(i);
    }

    final preview = primes.take(10).toList();
    return 'Count: ${primes.length}, First 10: $preview';
  }

  /// Calculate SHA-256 hash
  String sha256Hash(String text) {
    final bytes = utf8.encode(text);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Generate Fibonacci sequence
  String fibonacciSequence(int n) {
    if (n == 0) return '[0]';
    if (n == 1) return '[0, 1]';

    final fib = <int>[0, 1];
    for (var i = 2; i <= n; i++) {
      fib.add(fib[i - 1] + fib[i - 2]);
    }

    final preview = fib.reversed.take(10).toList().reversed.toList();
    return preview.toString();
  }

  /// Matrix multiplication
  String matrixMultiply(int size) {
    if (size == 0 || size > 500) return 'Invalid size';

    // Create two matrices
    final matrixA = List.generate(
      size,
      (i) => List.generate(size, (j) => ((i + j) % 10).toDouble()),
    );

    final matrixB = List.generate(
      size,
      (i) => List.generate(size, (j) => ((i * j) % 10).toDouble()),
    );

    // Multiply matrices
    final result = List.generate(
      size,
      (i) => List.generate(size, (j) {
        var sum = 0.0;
        for (var k = 0; k < size; k++) {
          sum += matrixA[i][k] * matrixB[k][j];
        }
        return sum;
      }),
    );

    return 'Matrix ${size}x$size multiplied. Sample result[0][0]: ${result[0][0]}';
  }

  /// Parse and manipulate JSON
  String parseJson(String jsonStr) {
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      data['processed_by_dart'] = true;
      data['timestamp'] = DateTime.now().toIso8601String();
      return jsonEncode(data);
    } catch (e) {
      return 'Error parsing JSON: $e';
    }
  }

  /// Text analysis
  String analyzeText(String text) {
    final words = text.split(RegExp(r'\s+'));
    final wordCount = words.length;
    final charCount = text.length;
    final lineCount = text.split('\n').length;

    final uniqueWords = words
        .map((w) => w.replaceAll(RegExp(r'[^\w]'), ''))
        .where((w) => w.isNotEmpty)
        .toSet();

    return 'Words: $wordCount, Chars: $charCount, Lines: $lineCount, Unique: ${uniqueWords.length}';
  }

  /// Calculate Pi using Monte Carlo method
  double calculatePi(int iterations) {
    final random = Random();
    var insideCircle = 0;

    for (var i = 0; i < iterations; i++) {
      final x = random.nextDouble();
      final y = random.nextDouble();

      if (x * x + y * y <= 1.0) {
        insideCircle++;
      }
    }

    return 4.0 * insideCircle / iterations;
  }

  /// Run-length encoding compression
  String compressRle(String input) {
    if (input.isEmpty) return '';

    final result = StringBuffer();
    final chars = input.split('');
    var i = 0;

    while (i < chars.length) {
      final current = chars[i];
      var count = 1;

      while (i + count < chars.length && chars[i + count] == current) {
        count++;
      }

      if (count > 1) {
        result.write('$count$current');
      } else {
        result.write(current);
      }

      i += count;
    }

    return result.toString();
  }
}
