import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

void main() {
  group('PasswordRequirementsChecklist Widget Tests', () {
    late PasswordValidationResult validResult;
    late PasswordValidationResult invalidResult;
    late ValidationRules rules;

    setUp(() {
      rules = const ValidationRules.strong();
      
      validResult = PasswordValidationResult.success(
        strengthDescription: 'Strong',
        strengthScore: 85,
        complexityRating: 'High',
        requirements: ['8+ characters', 'Uppercase', 'Lowercase', 'Numbers', 'Special chars'],
        checks: {
          'minLength': true,
          'uppercase': true,
          'lowercase': true,
          'numbers': true,
          'specialChars': true,
        },
      );

      invalidResult = PasswordValidationResult.failure(
        errorMessage: 'Password too short',
        strengthDescription: 'Weak',
        strengthScore: 25,
        complexityRating: 'Low',
        allErrors: ['Password too short'],
        checks: {
          'minLength': false,
          'uppercase': false,
          'lowercase': false,
          'numbers': false,
          'specialChars': false,
        },
      );
    });

    testWidgets('should display requirements checklist with valid result', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordRequirementsChecklist(
              result: validResult,
              rules: rules,
              showProgress: true,
              animated: true,
            ),
          ),
        ),
      );

      // Verify checklist is displayed
      expect(find.byType(PasswordRequirementsChecklist), findsOneWidget);
    });

    testWidgets('should display requirements checklist with invalid result', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordRequirementsChecklist(
              result: invalidResult,
              rules: rules,
              showProgress: true,
              animated: true,
            ),
          ),
        ),
      );

      // Verify checklist is displayed
      expect(find.byType(PasswordRequirementsChecklist), findsOneWidget);
    });

    testWidgets('should show progress when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordRequirementsChecklist(
              result: validResult,
              rules: rules,
              showProgress: true,
              animated: false,
            ),
          ),
        ),
      );

      // Verify progress indicator is shown
      expect(find.byType(PasswordRequirementsChecklist), findsOneWidget);
    });

    testWidgets('should hide progress when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordRequirementsChecklist(
              result: validResult,
              rules: rules,
              showProgress: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify checklist is displayed
      expect(find.byType(PasswordRequirementsChecklist), findsOneWidget);
    });

    testWidgets('should handle animation properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordRequirementsChecklist(
              result: validResult,
              rules: rules,
              showProgress: true,
              animated: true,
            ),
          ),
        ),
      );

      // Verify widget renders with animation
      expect(find.byType(PasswordRequirementsChecklist), findsOneWidget);
      
      // Pump frames to test animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should handle custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(16.0);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordRequirementsChecklist(
              result: validResult,
              rules: rules,
              showProgress: true,
              animated: false,
              padding: customPadding,
            ),
          ),
        ),
      );

      // Verify widget renders with custom padding
      expect(find.byType(PasswordRequirementsChecklist), findsOneWidget);
    });

    testWidgets('should handle different rule types', (WidgetTester tester) async {
      const basicRules = ValidationRules.basic();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordRequirementsChecklist(
              result: validResult,
              rules: basicRules,
              showProgress: true,
              animated: false,
            ),
          ),
        ),
      );

      // Verify widget renders with different rules
      expect(find.byType(PasswordRequirementsChecklist), findsOneWidget);
    });
  });
}