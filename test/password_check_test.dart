import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

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
        expect(result.errors, isEmpty);
      });

      test('should reject password that is too short', () {
        final result = checker.validate('Short1!');
        expect(result.isValid, false);
        expect(result.errors, contains('Password must be at least 8 characters long'));
      });

      test('should reject password without uppercase', () {
        final result = checker.validate('mypassword123!');
        expect(result.isValid, false);
        expect(result.errors, contains('Password must contain at least one uppercase letter'));
      });

      test('should reject password without lowercase', () {
        final result = checker.validate('MYPASSWORD123!');
        expect(result.isValid, false);
        expect(result.errors, contains('Password must contain at least one lowercase letter'));
      });

      test('should reject password without numbers', () {
        final result = checker.validate('MyPassword!');
        expect(result.isValid, false);
        expect(result.errors, contains('Password must contain at least one number'));
      });

      test('should reject password without special characters', () {
        final result = checker.validate('MyPassword123');
        expect(result.isValid, false);
        expect(result.errors, contains('Password must contain at least one special character'));
      });

      test('should reject common passwords', () {
        final result = checker.validate('password');
        expect(result.isValid, false);
        expect(result.errors, contains('Password is too common and easily guessable'));
      });
    });

    group('Password Strength', () {
      test('should calculate strength score correctly', () {
        final weakResult = checker.validate('weak');
        final strongResult = checker.validate('MyVeryStrongPassword123!');
        
        expect(weakResult.strengthScore, lessThan(strongResult.strengthScore));
        expect(strongResult.strengthLevel, isA<PasswordStrengthLevel>());
      });

      test('should identify very weak passwords', () {
        final result = checker.validate('123');
        expect(result.strengthLevel, PasswordStrengthLevel.veryWeak);
      });

      test('should identify strong passwords', () {
        final result = checker.validate('MyVeryStrongPassword123!@#');
        expect(result.strengthLevel, isIn([
          PasswordStrengthLevel.strong,
          PasswordStrengthLevel.veryStrong
        ]));
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

      test('should work with strict rules', () {
        final strictChecker = PasswordChecker.strict();
        final result = strictChecker.validate('MyVeryStrictPassword123!@#');
        expect(result.isValid, true);
      });
    });

    group('Edge Cases', () {
      test('should handle empty password', () {
        final result = checker.validate('');
        expect(result.isValid, false);
        expect(result.errors, isNotEmpty);
      });

      test('should handle very long password', () {
        final longPassword = 'A' * 200;
        final result = checker.validate(longPassword);
        expect(result.isValid, false);
        expect(result.errors, contains('Password must be no more than 128 characters long'));
      });

      test('should handle password with spaces when not allowed', () {
        final result = checker.validate('My Password 123!');
        expect(result.isValid, false);
        expect(result.errors, contains('Password cannot contain spaces'));
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
  });

  group('PasswordValidationResult', () {
    test('should create success result correctly', () {
      final result = PasswordValidationResult.success(
        strengthScore: 85,
        strengthLevel: PasswordStrengthLevel.strong,
        checks: {'minLength': true, 'uppercase': true},
      );
      
      expect(result.isValid, true);
      expect(result.errors, isEmpty);
      expect(result.strengthScore, 85);
      expect(result.strengthLevel, PasswordStrengthLevel.strong);
    });

    test('should create failure result correctly', () {
      final result = PasswordValidationResult.failure(
        errors: ['Password too short'],
        checks: {'minLength': false},
      );
      
      expect(result.isValid, false);
      expect(result.errors, contains('Password too short'));
      expect(result.strengthScore, 0);
    });
  });
}
