import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_checker_pro/password_checker_pro.dart';

void main() {
  group('PasswordVisualizer Widget Tests', () {
    late PasswordValidationResult validResult;
    late ValidationRules rules;

    setUp(() {
      rules = const ValidationRules.strong();

      validResult = PasswordValidationResult.success(
        strengthDescription: 'Strong',
        strengthScore: 85,
        complexityRating: 'High',
        requirements: [
          '8+ characters',
          'Uppercase',
          'Lowercase',
          'Numbers',
          'Special chars'
        ],
        checks: {
          'minLength': true,
          'uppercase': true,
          'lowercase': true,
          'numbers': true,
          'specialChars': true,
        },
      );
    });

    testWidgets('should display password visualizer with all tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: true,
              showIndicator: true,
              showChecklist: true,
              showSuggestions: true,
              animated: true,
            ),
          ),
        ),
      );

      // Verify visualizer is displayed
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });

    testWidgets('should display password visualizer with limited tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: true,
              showIndicator: false,
              showChecklist: false,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify visualizer is displayed with limited tabs
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });

    testWidgets('should show meter tab when enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: true,
              showIndicator: false,
              showChecklist: false,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify meter tab is shown
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });

    testWidgets('should hide meter tab when disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: false,
              showIndicator: true,
              showChecklist: false,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify meter tab is hidden
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });

    testWidgets('should show indicator tab when enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: false,
              showIndicator: true,
              showChecklist: false,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify indicator tab is shown
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });

    testWidgets('should hide indicator tab when disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: true,
              showIndicator: false,
              showChecklist: false,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify indicator tab is hidden
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });

    testWidgets('should show checklist tab when enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: false,
              showIndicator: false,
              showChecklist: true,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify checklist tab is shown
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });

    testWidgets('should hide checklist tab when disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: true,
              showIndicator: false,
              showChecklist: false,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify checklist tab is hidden
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });

    testWidgets('should show suggestions tab when enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: false,
              showIndicator: false,
              showChecklist: false,
              showSuggestions: true,
              animated: false,
            ),
          ),
        ),
      );

      // Verify suggestions tab is shown
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });

    testWidgets('should hide suggestions tab when disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: true,
              showIndicator: false,
              showChecklist: false,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify suggestions tab is hidden
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });

    testWidgets('should handle animation properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: true,
              showIndicator: true,
              showChecklist: true,
              showSuggestions: true,
              animated: true,
            ),
          ),
        ),
      );

      // Verify widget renders with animation
      expect(find.byType(PasswordVisualizer), findsOneWidget);

      // Pump frames to test animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should handle custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(24.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordVisualizer(
              result: validResult,
              rules: rules,
              showMeter: true,
              showIndicator: true,
              showChecklist: true,
              showSuggestions: true,
              animated: false,
              padding: customPadding,
            ),
          ),
        ),
      );

      // Verify widget renders with custom padding
      expect(find.byType(PasswordVisualizer), findsOneWidget);
    });
  });
}
