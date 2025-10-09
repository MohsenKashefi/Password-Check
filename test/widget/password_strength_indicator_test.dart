import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

void main() {
  group('PasswordStrengthIndicator Widget Tests', () {
    late PasswordValidationResult validResult;
    late PasswordValidationResult invalidResult;

    setUp(() {
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

    testWidgets('should display strength indicator with valid result', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: validResult,
              showBreakdown: true,
              showSuggestions: true,
              animated: true,
            ),
          ),
        ),
      );

      // Verify strength indicator is displayed
      expect(find.byType(PasswordStrengthIndicator), findsOneWidget);
      expect(find.text('Password Strength'), findsOneWidget);
      expect(find.text('85/100'), findsOneWidget);
    });

    testWidgets('should display strength indicator with invalid result', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: invalidResult,
              showBreakdown: true,
              showSuggestions: true,
              animated: true,
            ),
          ),
        ),
      );

      // Verify strength indicator is displayed
      expect(find.byType(PasswordStrengthIndicator), findsOneWidget);
      expect(find.text('Password Strength'), findsOneWidget);
      expect(find.text('25/100'), findsOneWidget);
    });

    testWidgets('should show breakdown when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: validResult,
              showBreakdown: true,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify breakdown is shown
      expect(find.text('Strength Breakdown'), findsOneWidget);
      expect(find.text('Length'), findsOneWidget);
      expect(find.text('Character Variety'), findsOneWidget);
      expect(find.text('Complexity'), findsOneWidget);
      expect(find.text('Pattern Analysis'), findsOneWidget);
    });

    testWidgets('should hide breakdown when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: validResult,
              showBreakdown: false,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify breakdown is hidden
      expect(find.text('Strength Breakdown'), findsNothing);
    });

    testWidgets('should show suggestions when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: invalidResult,
              showBreakdown: false,
              showSuggestions: true,
              animated: false,
            ),
          ),
        ),
      );

      // Verify suggestions are shown
      expect(find.text('Improvement Suggestions'), findsOneWidget);
    });

    testWidgets('should hide suggestions when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: invalidResult,
              showBreakdown: false,
              showSuggestions: false,
              animated: false,
            ),
          ),
        ),
      );

      // Verify suggestions are hidden
      expect(find.text('Improvement Suggestions'), findsNothing);
    });

    testWidgets('should handle animation properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: validResult,
              showBreakdown: true,
              showSuggestions: true,
              animated: true,
            ),
          ),
        ),
      );

      // Verify widget renders with animation
      expect(find.byType(PasswordStrengthIndicator), findsOneWidget);
      
      // Pump frames to test animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should handle custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(16.0);
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: validResult,
              showBreakdown: true,
              showSuggestions: true,
              animated: false,
              padding: customPadding,
            ),
          ),
        ),
      );

      // Verify widget renders with custom padding
      expect(find.byType(PasswordStrengthIndicator), findsOneWidget);
    });

    testWidgets('should handle custom height', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: validResult,
              showBreakdown: true,
              showSuggestions: true,
              animated: false,
              height: 12.0,
            ),
          ),
        ),
      );

      // Verify widget renders with custom height
      expect(find.byType(PasswordStrengthIndicator), findsOneWidget);
    });

    testWidgets('should display strength icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: validResult,
              showBreakdown: true,
              showSuggestions: true,
              animated: false,
            ),
          ),
        ),
      );

      // Verify strength icons are displayed
      expect(find.byIcon(Icons.verified_user), findsOneWidget);
    });

    testWidgets('should display suggestion icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthIndicator(
              result: invalidResult,
              showBreakdown: false,
              showSuggestions: true,
              animated: false,
            ),
          ),
        ),
      );

      // Verify suggestion icons are displayed
      expect(find.byIcon(Icons.lightbulb_outline), findsWidgets);
    });
  });
}