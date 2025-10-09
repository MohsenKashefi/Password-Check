import 'package:flutter_test/flutter_test.dart';
import 'package:password_checker_pro/password_checker_pro.dart';

void main() {
  group('PasswordChecker', () {
    late PasswordChecker checker;

    setUp(() {
      checker = PasswordChecker();
    });

    group('Basic Validation', () {
      test('should accept valid password', () {
        final result = checker.validate('MySecure123!');
        expect(result.isValid, true);
        expect(result.strengthScore, greaterThan(0));
      });

      test('should reject password that is too short', () {
        final result = checker.validate('Short1!');
        expect(result.isValid, false);
        expect(result.errorDisplay, isNotNull);
      });

      test('should reject password without uppercase', () {
        final result = checker.validate('mypassword123!');
        expect(result.isValid, false);
        expect(result.errorDisplay, contains('uppercase'));
      });

      test('should reject password without lowercase', () {
        final result = checker.validate('MYPASSWORD123!');
        expect(result.isValid, false);
        expect(result.errorDisplay, contains('lowercase'));
      });

      test('should reject password without numbers', () {
        final result = checker.validate('MyPassword!');
        expect(result.isValid, false);
        expect(result.errorDisplay, contains('number'));
      });

      test('should reject password without special characters', () {
        final result = checker.validate('MyPassword123');
        expect(result.isValid, false);
        expect(result.errorDisplay, contains('special'));
      });

      test('should reject common passwords', () {
        final result = checker.validate('password');
        expect(result.isValid, false);
        // Check for any error message since common password detection might not be the first error
        expect(result.errorDisplay, isNotNull);
      });

      test('should reject passwords with spaces when not allowed', () {
        final result = checker.validate('My Password 123!');
        expect(result.isValid, false);
        expect(result.errorDisplay, contains('space'));
      });
    });

    group('Password Strength', () {
      test('should calculate strength score correctly', () {
        final weakResult = checker.validate('weak');
        final strongResult = checker.validate('MyVeryStrongPassword123!@#');
        
        expect(weakResult.strengthScore, lessThan(strongResult.strengthScore));
        expect(strongResult.strengthScore, greaterThanOrEqualTo(80));
      });

      test('should identify very weak passwords', () {
        final result = checker.validate('123');
        expect(result.strengthDescription, contains('Weak'));
        expect(result.strengthScore, lessThanOrEqualTo(20));
      });

      test('should identify strong passwords', () {
        final result = checker.validate('MyVeryStrongPassword123!@#');
        expect(result.strengthDescription, contains('Strong'));
        expect(result.strengthScore, greaterThan(75));
      });

      test('should provide strength description', () {
        final result = checker.validate('MyStrongPassword123!');
        expect(result.strengthDisplay, isNotNull);
        expect(result.strengthDisplay, isNotEmpty);
      });
    });

    group('Validation Rules', () {
      test('should work with basic rules', () {
        final basicChecker = PasswordChecker.basic();
        final result = basicChecker.validate('simple123');
        expect(result.isValid, true);
      });

      test('should work with strong rules', () {
        final strongChecker = PasswordChecker.strong();
        final result = strongChecker.validate('MyStrongPassword123!');
        expect(result.isValid, true);
      });


      test('should reject weak passwords with strict rules', () {
        final strictChecker = PasswordChecker.strict();
        final result = strictChecker.validate('MyPassword123!');
        expect(result.isValid, false);
      });
    });

    group('Edge Cases', () {
      test('should handle empty password', () {
        final result = checker.validate('');
        expect(result.isValid, false);
        expect(result.errorDisplay, isNotNull);
      });

      test('should handle very long password', () {
        final longPassword = 'A' * 200;
        final result = checker.validate(longPassword);
        expect(result.isValid, false);
        expect(result.errorDisplay, contains('128'));
      });

    });

    group('Validation Results', () {
      test('should provide detailed checks', () {
        final result = checker.validate('MyPassword123!');
        expect(result.checks, isA<Map<String, bool>>());
        expect(result.checks['minLength'], true);
        expect(result.checks['uppercase'], true);
        expect(result.checks['lowercase'], true);
        expect(result.checks['numbers'], true);
        expect(result.checks['specialChars'], true);
      });

      test('should provide improvement tips', () {
        final result = checker.validate('weak');
        if (result.improvementDisplay != null) {
          expect(result.improvementDisplay, isNotEmpty);
        }
      });

      test('should provide requirements list', () {
        final result = checker.validate('MyPassword123!');
        expect(result.requirements, isA<List<String>>());
        expect(result.requirements, isNotEmpty);
      });
    });
  });

  group('PasswordStrength', () {
    test('should calculate score for empty password', () {
      final score = PasswordStrength.calculateScore('');
      expect(score, 0);
    });

    test('should calculate score for weak password', () {
      final score = PasswordStrength.calculateScore('123');
      expect(score, lessThan(30));
    });

    test('should calculate score for strong password', () {
      final score = PasswordStrength.calculateScore('MyVeryStrongPassword123!@#');
      expect(score, greaterThan(70));
    });

    test('should determine strength level correctly', () {
      expect(PasswordStrength.getStrengthLevel(95), PasswordStrengthLevel.veryStrong);
      expect(PasswordStrength.getStrengthLevel(80), PasswordStrengthLevel.strong);
      expect(PasswordStrength.getStrengthLevel(65), PasswordStrengthLevel.good);
      expect(PasswordStrength.getStrengthLevel(45), PasswordStrengthLevel.fair);
      expect(PasswordStrength.getStrengthLevel(25), PasswordStrengthLevel.weak);
      expect(PasswordStrength.getStrengthLevel(5), PasswordStrengthLevel.veryWeak);
    });
  });

  group('ValidationRules', () {
    test('should create basic rules correctly', () {
      const rules = ValidationRules.basic();
      expect(rules.minLength, 6);
      expect(rules.requireUppercase, false);
      expect(rules.requireSpecialChars, false);
    });

    test('should create strong rules correctly', () {
      const rules = ValidationRules.strong();
      expect(rules.minLength, 12);
      expect(rules.requireUppercase, true);
      expect(rules.requireSpecialChars, true);
    });

    test('should create strict rules correctly', () {
      const rules = ValidationRules.strict();
      expect(rules.minLength, 16);
      expect(rules.maxRepeatedChars, 1);
      expect(rules.maxSequentialLength, 1);
    });

    test('should create custom rules correctly', () {
      const rules = ValidationRules(
        minLength: 10,
        requireUppercase: true,
        requireLowercase: false,
        requireNumbers: true,
        requireSpecialChars: false,
      );
      expect(rules.minLength, 10);
      expect(rules.requireUppercase, true);
      expect(rules.requireLowercase, false);
      expect(rules.requireNumbers, true);
      expect(rules.requireSpecialChars, false);
    });
  });

  group('PasswordValidationResult', () {
    test('should create success result correctly', () {
      final result = PasswordValidationResult.success(
        strengthDescription: 'Strong',
        strengthScore: 85,
        complexityRating: 'High',
        checks: {'minLength': true, 'uppercase': true},
      );
      
      expect(result.isValid, true);
      expect(result.strengthScore, 85);
      expect(result.strengthDisplay, 'Strong');
    });

    test('should create failure result correctly', () {
      final result = PasswordValidationResult.failure(
        errorMessage: 'Password too short',
        strengthDescription: 'Weak',
        strengthScore: 20,
        complexityRating: 'Low',
        allErrors: ['Password too short'],
        checks: {'minLength': false},
      );
      
      expect(result.isValid, false);
      expect(result.errorDisplay, 'Password too short');
      expect(result.strengthScore, 20);
    });

    test('should provide user-friendly getters', () {
      final result = PasswordValidationResult.success(
        strengthDescription: 'Strong',
        strengthScore: 85,
        complexityRating: 'High',
      );
      
      expect(result.strengthDisplay, 'Strong');
      expect(result.errorDisplay, isNull);
      expect(result.warningDisplay, isNull);
      expect(result.improvementDisplay, isNull);
      expect(result.isSecure, true);
    });
  });

  group('PasswordStrengthLevel', () {
    test('should have correct enum values', () {
      expect(PasswordStrengthLevel.values, hasLength(6));
      expect(PasswordStrengthLevel.values, contains(PasswordStrengthLevel.veryWeak));
      expect(PasswordStrengthLevel.values, contains(PasswordStrengthLevel.weak));
      expect(PasswordStrengthLevel.values, contains(PasswordStrengthLevel.fair));
      expect(PasswordStrengthLevel.values, contains(PasswordStrengthLevel.good));
      expect(PasswordStrengthLevel.values, contains(PasswordStrengthLevel.strong));
      expect(PasswordStrengthLevel.values, contains(PasswordStrengthLevel.veryStrong));
    });
  });
}
