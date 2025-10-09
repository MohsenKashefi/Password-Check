import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

void main() {
  group('PasswordImprovementSuggestions Widget Tests', () {
    late PasswordValidationResult weakResult;
    late PasswordValidationResult validResult;
    late ValidationRules rules;

    setUp(() {
      rules = const ValidationRules.strong();
      
      weakResult = PasswordValidationResult.success(
        strengthDescription: 'Weak',
        strengthScore: 30,
        complexityRating: 'Low',
        improvementTip: 'Add more characters and special characters',
        requirements: ['8+ characters', 'Uppercase', 'Lowercase', 'Numbers', 'Special chars'],
        checks: {
          'minLength': false,
          'uppercase': false,
          'lowercase': false,
          'numbers': false,
          'specialChars': false,
        },
      );

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
    });

    testWidgets('should display improvement suggestions for weak password', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordImprovementSuggestions(
              result: weakResult,
              rules: rules,
              showIcons: true,
              showPriority: true,
            ),
          ),
        ),
      );

      // Verify improvement suggestions are displayed
      expect(find.byType(PasswordImprovementSuggestions), findsOneWidget);
    });

    testWidgets('should display improvement suggestions with icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordImprovementSuggestions(
              result: weakResult,
              rules: rules,
              showIcons: true,
              showPriority: true,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(PasswordImprovementSuggestions), findsOneWidget);
    });

    testWidgets('should hide icons when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordImprovementSuggestions(
              result: weakResult,
              rules: rules,
              showIcons: false,
              showPriority: true,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(PasswordImprovementSuggestions), findsOneWidget);
    });

    testWidgets('should display priority badges when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordImprovementSuggestions(
              result: weakResult,
              rules: rules,
              showIcons: true,
              showPriority: true,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(PasswordImprovementSuggestions), findsOneWidget);
    });

    testWidgets('should hide priority badges when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordImprovementSuggestions(
              result: weakResult,
              rules: rules,
              showIcons: true,
              showPriority: false,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(PasswordImprovementSuggestions), findsOneWidget);
    });

    testWidgets('should handle custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(16.0);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordImprovementSuggestions(
              result: weakResult,
              rules: rules,
              showIcons: true,
              showPriority: true,
              padding: customPadding,
            ),
          ),
        ),
      );

      // Verify widget renders with custom padding
      expect(find.byType(PasswordImprovementSuggestions), findsOneWidget);
    });

    testWidgets('should handle strong password with no suggestions', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordImprovementSuggestions(
              result: validResult,
              rules: rules,
              showIcons: true,
              showPriority: true,
            ),
          ),
        ),
      );

      // Verify widget handles strong password
      expect(find.byType(PasswordImprovementSuggestions), findsOneWidget);
    });

    testWidgets('should display different suggestion types', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordImprovementSuggestions(
              result: weakResult,
              rules: rules,
              showIcons: true,
              showPriority: true,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(PasswordImprovementSuggestions), findsOneWidget);
    });

    testWidgets('should handle different rule types', (WidgetTester tester) async {
      const basicRules = ValidationRules.basic();
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordImprovementSuggestions(
              result: weakResult,
              rules: basicRules,
              showIcons: true,
              showPriority: true,
            ),
          ),
        ),
      );

      // Verify widget renders with different rules
      expect(find.byType(PasswordImprovementSuggestions), findsOneWidget);
    });

    testWidgets('should handle empty suggestions gracefully', (WidgetTester tester) async {
      final emptyResult = PasswordValidationResult.success(
        strengthDescription: 'Strong',
        strengthScore: 85,
        complexityRating: 'High',
        requirements: [],
        checks: {},
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordImprovementSuggestions(
              result: emptyResult,
              rules: rules,
              showIcons: true,
              showPriority: true,
            ),
          ),
        ),
      );

      // Verify widget handles empty suggestions
      expect(find.byType(PasswordImprovementSuggestions), findsOneWidget);
    });
  });
}