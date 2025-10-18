import 'package:flutter_test/flutter_test.dart';
import 'package:app_core/app_core.dart';

void main() {
  setUpAll(() {
    initAppCore();
  });

  test('sum function', () {
    expect(AppCore.sum(10, 20), 30);
    expect(AppCore.sum(-5, 5), 0);
    expect(AppCore.sum(100, 200), 300);
  });

  test('multiply function', () {
    expect(AppCore.multiply(5, 6), 30);
    expect(AppCore.multiply(0, 10), 0);
    expect(AppCore.multiply(-2, 3), -6);
  });

  test('string operations', () {
    expect(AppCore.helloWorld(), 'Hello from Rust!');
    expect(AppCore.reverseString('hello'), 'olleh');
    expect(AppCore.toUppercase('flutter'), 'FLUTTER');
    expect(AppCore.concatenate('Hello, ', 'World!'), 'Hello, World!');
    expect(AppCore.stringLength('test'), 4);
  });

  test('version check', () {
    final version = AppCore.getVersion();
    expect(version, isNotEmpty);
    expect(version, '0.1.0');
  });
}
