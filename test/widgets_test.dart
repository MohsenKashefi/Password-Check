import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

void main() {
  group('Password Widgets Tests', () {
    late PasswordValidationResult validResult;
    late PasswordValidationResult invalidResult;
    late ValidationRules rules;

    setUp(() {
      rules = const ValidationRules.strong();
      
      validResult = PasswordValidationResult.success(
        strengthScore: 85,
        strengthLevel: PasswordStrengthLevel.strong,
        checks: {
          'minLength': true,
          'maxLength': true,
          'uppercase': true,
          'lowercase': true,
          'numbers': true,
          'specialChars': true,
          'noSpaces': true,
          'notCommon': true,
          'noRepeatedChars': true,
          'noSequentialChars': true,
        },
      );

      invalidResult = PasswordValidationResult.failure(
        errors: ['Password must be at least 8 characters long'],
        checks: {
          'minLength': false,
          'maxLength': true,
          'uppercase': false,
          'lowercase': false,
          'numbers': false,
          'specialChars': false,
          'noSpaces': true,
          'notCommon': false,
          'noRepeatedChars': false,
          'noSequentialChars': false,
        },
      );
    });

    group('PasswordStrengthIndicator', () {
      testWidgets('should display strength indicator', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordStrengthIndicator(
                result: validResult,
                animated: false,
              ),
            ),
          ),
        );

        expect(find.text('Password Strength'), findsOneWidget);
        expect(find.text('85/100'), findsOneWidget);
        expect(find.text('Strong'), findsOneWidget);
      });

      testWidgets('should show breakdown when enabled', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordStrengthIndicator(
                result: validResult,
                showBreakdown: true,
                animated: false,
              ),
            ),
          ),
        );

        expect(find.text('Strength Breakdown'), findsOneWidget);
        expect(find.text('Length'), findsOneWidget);
        expect(find.text('Character Variety'), findsOneWidget);
      });

      testWidgets('should show suggestions when enabled', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordStrengthIndicator(
                result: invalidResult,
                showSuggestions: true,
                animated: false,
              ),
            ),
          ),
        );

        expect(find.text('Improvement Suggestions'), findsOneWidget);
      });
    });

    group('PasswordRequirementsChecklist', () {
      testWidgets('should display requirements checklist', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordRequirementsChecklist(
                result: validResult,
                rules: rules,
                animated: false,
              ),
            ),
          ),
        );

        expect(find.text('Password Requirements'), findsOneWidget);
        expect(find.text('100% Complete'), findsOneWidget);
      });

      testWidgets('should show progress when enabled', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordRequirementsChecklist(
                result: invalidResult,
                rules: rules,
                showProgress: true,
                animated: false,
              ),
            ),
          ),
        );

        expect(find.text('Password Requirements'), findsOneWidget);
        expect(find.text('At least 8 characters'), findsOneWidget);
      });
    });

    group('PasswordStrengthMeter', () {
      testWidgets('should display circular strength meter', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordStrengthMeter(
                result: validResult,
                animated: false,
              ),
            ),
          ),
        );

        expect(find.text('85/100'), findsOneWidget);
        expect(find.text('Strong'), findsOneWidget);
      });

      testWidgets('should show score when enabled', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordStrengthMeter(
                result: validResult,
                showScore: true,
                showLevel: false,
                animated: false,
              ),
            ),
          ),
        );

        expect(find.text('85/100'), findsOneWidget);
        expect(find.text('Strong'), findsNothing);
      });
    });

    group('PasswordImprovementSuggestions', () {
      testWidgets('should display improvement suggestions', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordImprovementSuggestions(
                result: invalidResult,
                rules: rules,
              ),
            ),
          ),
        );

        expect(find.text('Improvement Suggestions'), findsOneWidget);
      });

      testWidgets('should show priority badges when enabled', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordImprovementSuggestions(
                result: invalidResult,
                rules: rules,
                showPriority: true,
              ),
            ),
          ),
        );

        expect(find.text('High'), findsWidgets);
      });
    });

    group('PasswordVisualizer', () {
      testWidgets('should display comprehensive visualizer', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordVisualizer(
                result: validResult,
                rules: rules,
                animated: false,
              ),
            ),
          ),
        );

        expect(find.text('Password Analysis'), findsOneWidget);
        expect(find.text('85'), findsOneWidget);
        expect(find.text('Score'), findsOneWidget);
      });

      testWidgets('should show all tabs', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordVisualizer(
                result: validResult,
                rules: rules,
                animated: false,
              ),
            ),
          ),
        );

        expect(find.text('Strength'), findsOneWidget);
        expect(find.text('Requirements'), findsOneWidget);
        expect(find.text('Breakdown'), findsOneWidget);
        expect(find.text('Suggestions'), findsOneWidget);
      });
    });

    group('Widget Integration', () {
      testWidgets('should work with different validation results', (WidgetTester tester) async {
        final results = [
          PasswordValidationResult.success(
            strengthScore: 20,
            strengthLevel: PasswordStrengthLevel.veryWeak,
            checks: {'minLength': false, 'uppercase': false},
          ),
          PasswordValidationResult.success(
            strengthScore: 50,
            strengthLevel: PasswordStrengthLevel.fair,
            checks: {'minLength': true, 'uppercase': true, 'numbers': false},
          ),
          PasswordValidationResult.success(
            strengthScore: 90,
            strengthLevel: PasswordStrengthLevel.veryStrong,
            checks: {
              'minLength': true,
              'uppercase': true,
              'lowercase': true,
              'numbers': true,
              'specialChars': true,
            },
          ),
        ];

        for (final result in results) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    PasswordStrengthIndicator(
                      result: result,
                      animated: false,
                    ),
                    PasswordRequirementsChecklist(
                      result: result,
                      rules: rules,
                      animated: false,
                    ),
                  ],
                ),
              ),
            ),
          );

          await tester.pump();
        }
      });

      testWidgets('should handle empty validation results', (WidgetTester tester) async {
        final emptyResult = PasswordValidationResult.failure(
          errors: [],
          checks: {},
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordVisualizer(
                result: emptyResult,
                rules: rules,
                animated: false,
              ),
            ),
          ),
        );

        expect(find.text('Password Analysis'), findsOneWidget);
      });
    });
  });
}
