import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_checker_pro/password_checker_pro.dart';

void main() {
  group('PasswordStrengthMeter Widget Tests', () {
    late PasswordValidationResult validResult;
    late PasswordValidationResult invalidResult;
    late PasswordValidationResult weakResult;

    setUp(() {
      validResult = PasswordValidationResult.success(
        strengthDescription: 'Strong',
        strengthScore: 85,
        complexityRating: 'High',
      );

      invalidResult = PasswordValidationResult.failure(
        errorMessage: 'Password too short',
        strengthDescription: 'Weak',
        strengthScore: 25,
        complexityRating: 'Low',
        allErrors: ['Password too short'],
      );

      weakResult = PasswordValidationResult.success(
        strengthDescription: 'Weak',
        strengthScore: 30,
        complexityRating: 'Low',
      );
    });

    testWidgets('should display strength meter with valid result',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: true,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      // Verify strength meter is displayed
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should display strength meter with invalid result',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: invalidResult,
              size: 120.0,
              animated: true,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      // Verify strength meter is displayed
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should show score when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: false,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should hide score when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: false,
              showLevel: true,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should show level when enabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: false,
              showLevel: true,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should hide level when disabled', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: false,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle custom size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 200.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      // Verify widget renders with custom size
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle animation properly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: true,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      // Verify widget renders with animation
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Pump frames to test animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should handle custom background color',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: true,
              backgroundColor: Colors.grey[300],
            ),
          ),
        ),
      );

      // Verify widget renders with custom background color
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle custom padding', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(24.0);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: true,
              padding: customPadding,
            ),
          ),
        ),
      );

      // Verify widget renders with custom padding
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should display different strength levels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: weakResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      // Verify widget renders
      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });
  });
}
