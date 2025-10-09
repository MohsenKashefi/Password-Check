import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

void main() {
  group('PasswordStrengthMeter Extended Tests', () {
    late PasswordValidationResult validResult;
    late PasswordValidationResult weakResult;
    late PasswordValidationResult strongResult;

    setUp(() {
      validResult = PasswordValidationResult.success(
        strengthDescription: 'Strong',
        strengthScore: 85,
        complexityRating: 'High',
      );

      weakResult = PasswordValidationResult.success(
        strengthDescription: 'Weak',
        strengthScore: 30,
        complexityRating: 'Low',
      );

      strongResult = PasswordValidationResult.success(
        strengthDescription: 'Very Strong',
        strengthScore: 95,
        complexityRating: 'Very High',
      );
    });

    testWidgets('should handle different strength levels',
        (WidgetTester tester) async {
      // Test very weak
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: PasswordValidationResult.success(
                strengthDescription: 'Very Weak',
                strengthScore: 10,
                complexityRating: 'Very Low',
              ),
              size: 100.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Test fair
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: PasswordValidationResult.success(
                strengthDescription: 'Fair',
                strengthScore: 50,
                complexityRating: 'Medium',
              ),
              size: 100.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Test good
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: PasswordValidationResult.success(
                strengthDescription: 'Good',
                strengthScore: 70,
                complexityRating: 'High',
              ),
              size: 100.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle edge case scores', (WidgetTester tester) async {
      // Test score 0
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: PasswordValidationResult.success(
                strengthDescription: 'Very Weak',
                strengthScore: 0,
                complexityRating: 'Very Low',
              ),
              size: 100.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Test score 100
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: PasswordValidationResult.success(
                strengthDescription: 'Very Strong',
                strengthScore: 100,
                complexityRating: 'Very High',
              ),
              size: 100.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle different size configurations',
        (WidgetTester tester) async {
      // Test small size
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 50.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Test large size
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

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle different background colors',
        (WidgetTester tester) async {
      // Test with custom background color
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: true,
              backgroundColor: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Test with null background color
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: true,
              backgroundColor: null,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle different padding configurations',
        (WidgetTester tester) async {
      // Test with custom padding
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: true,
              padding: const EdgeInsets.all(32.0),
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Test with zero padding
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: true,
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle animation states', (WidgetTester tester) async {
      // Test with animation enabled
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

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Pump frames to test animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 1000));

      // Test with animation disabled
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle score and level visibility combinations',
        (WidgetTester tester) async {
      // Test both score and level visible
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Test only score visible
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

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Test only level visible
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

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Test neither score nor level visible
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 120.0,
              animated: false,
              showScore: false,
              showLevel: false,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle widget updates', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: weakResult,
              size: 120.0,
              animated: true,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Update with different result
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: strongResult,
              size: 120.0,
              animated: true,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Pump frames to test animation update
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('should handle different complexity ratings',
        (WidgetTester tester) async {
      final complexityRatings = [
        'Very Low',
        'Low',
        'Medium',
        'High',
        'Very High'
      ];

      for (final rating in complexityRatings) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordStrengthMeter(
                result: PasswordValidationResult.success(
                  strengthDescription: 'Test',
                  strengthScore: 50,
                  complexityRating: rating,
                ),
                size: 120.0,
                animated: false,
                showScore: true,
                showLevel: true,
              ),
            ),
          ),
        );

        expect(find.byType(PasswordStrengthMeter), findsOneWidget);
      }
    });

    testWidgets('should handle different strength descriptions',
        (WidgetTester tester) async {
      final descriptions = [
        'Very Weak',
        'Weak',
        'Fair',
        'Good',
        'Strong',
        'Very Strong'
      ];

      for (final description in descriptions) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: PasswordStrengthMeter(
                result: PasswordValidationResult.success(
                  strengthDescription: description,
                  strengthScore: 50,
                  complexityRating: 'Medium',
                ),
                size: 120.0,
                animated: false,
                showScore: true,
                showLevel: true,
              ),
            ),
          ),
        );

        expect(find.byType(PasswordStrengthMeter), findsOneWidget);
      }
    });

    testWidgets('should handle reasonable size values',
        (WidgetTester tester) async {
      // Test small size
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 50.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Test large size
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordStrengthMeter(
              result: validResult,
              size: 300.0,
              animated: false,
              showScore: true,
              showLevel: true,
            ),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);
    });

    testWidgets('should handle widget disposal', (WidgetTester tester) async {
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

      expect(find.byType(PasswordStrengthMeter), findsOneWidget);

      // Remove widget to test disposal
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
          ),
        ),
      );

      expect(find.byType(PasswordStrengthMeter), findsNothing);
    });
  });
}
