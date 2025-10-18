import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:example/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AppCore FFI Integration Tests', () {
    testWidgets('App launches and displays UI', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('AppCore FFI'), findsOneWidget);
      expect(find.text('Basic Operations'), findsOneWidget);
      expect(find.text('String Operations'), findsOneWidget);
      expect(find.text('Async Operations'), findsOneWidget);
      expect(find.text('Blocking Operations (Isolates)'), findsOneWidget);
    });

    testWidgets('Math operations work correctly', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Math Functions'));
      await tester.pumpAndSettle();

      expect(find.text('Sum: 30, Multiply: 30'), findsOneWidget);
    });

    testWidgets('Hello World function works', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Hello World'));
      await tester.pumpAndSettle();

      expect(find.text('Hello from Rust!'), findsOneWidget);
    });

    testWidgets('String operations work correctly', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      await tester.enterText(textField, 'test');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Test String Functions'));
      await tester.pumpAndSettle();

      expect(find.textContaining('test'), findsWidgets);
      expect(find.textContaining('tset'), findsWidgets);
      expect(find.textContaining('TEST'), findsWidgets);
      expect(find.textContaining('test World!'), findsWidgets);
    });
  });
}
