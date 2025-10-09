import 'package:flutter_test/flutter_test.dart';
import 'package:password_checker_pro/password_checker_pro.dart';

void main() {
  group('PasswordValidationResult Comprehensive Tests', () {
    group('Basic Functionality', () {
      test('should create success result with all properties', () {
        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          requirements: ['8+ characters', 'Uppercase', 'Lowercase', 'Numbers'],
          checks: {
            'minLength': true,
            'uppercase': true,
            'lowercase': true,
            'numbers': true,
          },
          improvementTip: 'Add special characters for better security',
          vulnerabilities: ['No special characters'],
        );

        expect(result.isValid, isTrue);
        expect(result.strengthDescription, equals('Strong'));
        expect(result.strengthScore, equals(85));
        expect(result.complexityRating, equals('High'));
        expect(result.requirements, contains('8+ characters'));
        expect(result.checks['minLength'], isTrue);
        expect(result.improvementTip, contains('special characters'));
        expect(result.vulnerabilities, contains('No special characters'));
      });

      test('should create failure result with all properties', () {
        final result = PasswordValidationResult.failure(
          errorMessage: 'Password too short',
          strengthDescription: 'Weak',
          strengthScore: 25,
          complexityRating: 'Low',
          allErrors: ['Password too short', 'Missing uppercase'],
          checks: {
            'minLength': false,
            'uppercase': false,
          },
          requirements: ['8+ characters', 'Uppercase'],
          improvementTip: 'Use at least 8 characters and add uppercase letters',
          vulnerabilities: ['Too short', 'No uppercase'],
        );

        expect(result.isValid, isFalse);
        expect(result.errorMessage, equals('Password too short'));
        expect(result.strengthDescription, equals('Weak'));
        expect(result.strengthScore, equals(25));
        expect(result.complexityRating, equals('Low'));
        expect(result.allErrors, contains('Password too short'));
        expect(result.checks['minLength'], isFalse);
        expect(result.improvementTip, contains('8 characters'));
        expect(result.vulnerabilities, contains('Too short'));
      });

      test('should create result with all constructor parameters', () {
        final result = PasswordValidationResult(
          isValid: true,
          errorMessage: 'Test error',
          warningMessage: 'Test warning',
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          improvementTip: 'Add special characters',
          requirements: ['8+ characters', 'Uppercase'],
          vulnerabilities: ['No special characters'],
          allErrors: ['Error 1', 'Error 2'],
          allWarnings: ['Warning 1', 'Warning 2'],
          checks: {'minLength': true, 'uppercase': false},
        );

        expect(result.isValid, isTrue);
        expect(result.errorMessage, equals('Test error'));
        expect(result.warningMessage, equals('Test warning'));
        expect(result.strengthDescription, equals('Strong'));
        expect(result.strengthScore, equals(85));
        expect(result.complexityRating, equals('High'));
        expect(result.improvementTip, equals('Add special characters'));
        expect(result.requirements, equals(['8+ characters', 'Uppercase']));
        expect(result.vulnerabilities, equals(['No special characters']));
        expect(result.allErrors, equals(['Error 1', 'Error 2']));
        expect(result.allWarnings, equals(['Warning 1', 'Warning 2']));
        expect(result.checks, equals({'minLength': true, 'uppercase': false}));
      });

      test('should create result with minimal constructor parameters', () {
        final result = PasswordValidationResult(
          isValid: false,
          strengthDescription: 'Weak',
          strengthScore: 25,
          complexityRating: 'Low',
        );

        expect(result.isValid, isFalse);
        expect(result.errorMessage, isNull);
        expect(result.warningMessage, isNull);
        expect(result.strengthDescription, equals('Weak'));
        expect(result.strengthScore, equals(25));
        expect(result.complexityRating, equals('Low'));
        expect(result.improvementTip, isNull);
        expect(result.requirements, isEmpty);
        expect(result.vulnerabilities, isEmpty);
        expect(result.allErrors, isEmpty);
        expect(result.allWarnings, isEmpty);
        expect(result.checks, isEmpty);
      });
    });

    group('User-Friendly Getters', () {
      test('should provide user-friendly getters', () {
        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          improvementTip: 'Add special characters',
          warningMessage: 'Consider adding numbers',
        );

        expect(result.strengthDisplay, equals('Strong'));
        expect(result.errorDisplay, isNull);
        expect(result.warningDisplay, equals('Consider adding numbers'));
        expect(result.improvementDisplay, equals('Add special characters'));
      });

      test('should determine security status correctly', () {
        // Secure password
        final secureResult = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          vulnerabilities: [],
        );

        expect(secureResult.isSecure, isTrue);

        // Insecure password - low score
        final weakResult = PasswordValidationResult.success(
          strengthDescription: 'Weak',
          strengthScore: 30,
          complexityRating: 'Low',
          vulnerabilities: [],
        );

        expect(weakResult.isSecure, isFalse);

        // Insecure password - has vulnerabilities
        final vulnerableResult = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          vulnerabilities: ['Contains common words'],
        );

        expect(vulnerableResult.isSecure, isFalse);
      });

      test('should handle edge case security scores', () {
        // Exactly 80 score - should be secure if no vulnerabilities
        final edgeResult = PasswordValidationResult.success(
          strengthDescription: 'Good',
          strengthScore: 80,
          complexityRating: 'High',
          vulnerabilities: [],
        );

        expect(edgeResult.isSecure, isTrue);

        // 79 score - should not be secure
        final belowEdgeResult = PasswordValidationResult.success(
          strengthDescription: 'Good',
          strengthScore: 79,
          complexityRating: 'High',
          vulnerabilities: [],
        );

        expect(belowEdgeResult.isSecure, isFalse);
      });
    });

    group('Edge Cases and Boundary Conditions', () {
      test('should handle empty requirements list', () {
        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          requirements: [],
          checks: {},
        );

        expect(result.requirements, isEmpty);
        expect(result.checks, isEmpty);
      });

      test('should handle null optional properties', () {
        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          requirements: ['8+ characters'],
          checks: {'minLength': true},
        );

        expect(result.improvementTip, isNull);
        expect(result.vulnerabilities, isEmpty);
      });

      test('should handle all strength levels', () {
        final levels = [
          ('Very Weak', 10, 'Very Low'),
          ('Weak', 30, 'Low'),
          ('Fair', 50, 'Medium'),
          ('Good', 70, 'High'),
          ('Strong', 85, 'High'),
          ('Very Strong', 95, 'Very High'),
        ];

        for (final (description, score, rating) in levels) {
          final result = PasswordValidationResult.success(
            strengthDescription: description,
            strengthScore: score,
            complexityRating: rating,
            requirements: ['8+ characters'],
            checks: {'minLength': true},
          );

          expect(result.strengthDescription, equals(description));
          expect(result.strengthScore, equals(score));
          expect(result.complexityRating, equals(rating));
        }
      });

      test('should handle edge case scores', () {
        // Test score 0
        final result0 = PasswordValidationResult.success(
          strengthDescription: 'Very Weak',
          strengthScore: 0,
          complexityRating: 'Very Low',
          requirements: [],
          checks: {},
        );

        expect(result0.strengthScore, equals(0));

        // Test score 100
        final result100 = PasswordValidationResult.success(
          strengthDescription: 'Very Strong',
          strengthScore: 100,
          complexityRating: 'Very High',
          requirements: ['8+ characters'],
          checks: {'minLength': true},
        );

        expect(result100.strengthScore, equals(100));
      });

      test('should handle large numbers in score', () {
        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 999,
          complexityRating: 'Very High',
          requirements: ['8+ characters'],
          checks: {'minLength': true},
        );

        expect(result.strengthScore, equals(999));
      });

      test('should handle negative score', () {
        final result = PasswordValidationResult.failure(
          errorMessage: 'Invalid password',
          strengthDescription: 'Invalid',
          strengthScore: -10,
          complexityRating: 'Invalid',
          allErrors: ['Invalid password'],
          checks: {},
        );

        expect(result.strengthScore, equals(-10));
      });
    });

    group('Complex Data Structures', () {
      test('should handle complex checks map', () {
        final checks = {
          'minLength': true,
          'maxLength': true,
          'uppercase': false,
          'lowercase': true,
          'numbers': false,
          'specialChars': true,
          'noSpaces': true,
          'notCommon': false,
          'noRepeatedChars': true,
          'noSequentialChars': false,
        };

        final result = PasswordValidationResult.success(
          strengthDescription: 'Good',
          strengthScore: 70,
          complexityRating: 'High',
          requirements: ['8+ characters', 'Uppercase', 'Numbers'],
          checks: checks,
        );

        expect(result.checks, equals(checks));
        expect(result.checks['minLength'], isTrue);
        expect(result.checks['uppercase'], isFalse);
      });

      test('should handle multiple errors', () {
        final errors = [
          'Password too short',
          'Missing uppercase letter',
          'Missing number',
          'Missing special character',
          'Password is too common',
        ];

        final result = PasswordValidationResult.failure(
          errorMessage: errors.first,
          strengthDescription: 'Very Weak',
          strengthScore: 5,
          complexityRating: 'Very Low',
          allErrors: errors,
          checks: {
            'minLength': false,
            'uppercase': false,
            'numbers': false,
            'specialChars': false,
            'notCommon': false,
          },
          requirements: [
            '8+ characters',
            'Uppercase',
            'Numbers',
            'Special chars'
          ],
        );

        expect(result.allErrors, equals(errors));
        expect(result.allErrors.length, equals(5));
      });

      test('should handle multiple vulnerabilities', () {
        final vulnerabilities = [
          'Too short',
          'No uppercase',
          'No numbers',
          'No special characters',
          'Common password',
          'Sequential characters',
        ];

        final result = PasswordValidationResult.failure(
          errorMessage: 'Multiple issues',
          strengthDescription: 'Very Weak',
          strengthScore: 5,
          complexityRating: 'Very Low',
          allErrors: ['Multiple issues'],
          checks: {},
          vulnerabilities: vulnerabilities,
        );

        expect(result.vulnerabilities, equals(vulnerabilities));
        expect(result.vulnerabilities.length, equals(6));
      });

      test('should handle very long requirements list', () {
        final longRequirements =
            List.generate(100, (index) => 'Requirement ${index + 1}');

        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          requirements: longRequirements,
          checks: {'minLength': true},
        );

        expect(result.requirements.length, equals(100));
        expect(result.requirements.first, equals('Requirement 1'));
        expect(result.requirements.last, equals('Requirement 100'));
      });

      test('should handle very long checks map', () {
        final longChecks = Map.fromEntries(List.generate(
            50, (index) => MapEntry('check$index', index % 2 == 0)));

        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          requirements: ['8+ characters'],
          checks: longChecks,
        );

        expect(result.checks.length, equals(50));
        expect(result.checks['check0'], isTrue);
        expect(result.checks['check1'], isFalse);
      });
    });

    group('String Handling and Internationalization', () {
      test('should handle long improvement tips', () {
        final longTip =
            'Your password needs improvement. Consider adding uppercase letters, numbers, and special characters. Avoid common words and sequential patterns. Use a mix of different character types for better security.';

        final result = PasswordValidationResult.success(
          strengthDescription: 'Weak',
          strengthScore: 30,
          complexityRating: 'Low',
          requirements: ['8+ characters'],
          checks: {'minLength': true},
          improvementTip: longTip,
        );

        expect(result.improvementTip, equals(longTip));
        expect(result.improvementTip!.length, greaterThan(100));
      });

      test('should handle special characters in messages', () {
        final result = PasswordValidationResult.failure(
          errorMessage: 'Password contains invalid characters: @#\$%',
          strengthDescription: 'Invalid',
          strengthScore: 0,
          complexityRating: 'Invalid',
          allErrors: ['Password contains invalid characters: @#\$%'],
          checks: {},
          requirements: ['Valid characters only'],
        );

        expect(result.errorMessage, contains('@#\$%'));
        expect(result.allErrors.first, contains('@#\$%'));
      });

      test('should handle unicode characters in messages', () {
        final result = PasswordValidationResult.failure(
          errorMessage: 'رمز عبور باید حداقل 8 کاراکتر باشد',
          strengthDescription: 'ضعیف',
          strengthScore: 20,
          complexityRating: 'پایین',
          allErrors: ['رمز عبور باید حداقل 8 کاراکتر باشد'],
          checks: {'minLength': false},
          requirements: ['حداقل 8 کاراکتر'],
        );

        expect(result.errorMessage, contains('رمز عبور'));
        expect(result.strengthDescription, contains('ضعیف'));
        expect(result.complexityRating, contains('پایین'));
      });

      test('should handle empty strings in properties', () {
        final result = PasswordValidationResult.failure(
          errorMessage: '',
          strengthDescription: '',
          strengthScore: 0,
          complexityRating: '',
          allErrors: [''],
          checks: {},
          requirements: [''],
        );

        expect(result.errorMessage, isEmpty);
        expect(result.strengthDescription, isEmpty);
        expect(result.complexityRating, isEmpty);
        expect(result.allErrors.first, isEmpty);
        expect(result.requirements.first, isEmpty);
      });
    });

    group('Factory Methods', () {
      test('should handle success factory with all parameters', () {
        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          improvementTip: 'Add special characters',
          requirements: ['8+ characters', 'Uppercase'],
          vulnerabilities: ['No special characters'],
          warningMessage: 'Consider adding numbers',
          allWarnings: ['Warning 1', 'Warning 2'],
          checks: {'minLength': true, 'uppercase': false},
        );

        expect(result.isValid, isTrue);
        expect(result.errorMessage, isNull);
        expect(result.warningMessage, equals('Consider adding numbers'));
        expect(result.strengthDescription, equals('Strong'));
        expect(result.strengthScore, equals(85));
        expect(result.complexityRating, equals('High'));
        expect(result.improvementTip, equals('Add special characters'));
        expect(result.requirements, equals(['8+ characters', 'Uppercase']));
        expect(result.vulnerabilities, equals(['No special characters']));
        expect(result.allWarnings, equals(['Warning 1', 'Warning 2']));
        expect(result.checks, equals({'minLength': true, 'uppercase': false}));
      });

      test('should handle failure factory with all parameters', () {
        final result = PasswordValidationResult.failure(
          errorMessage: 'Password too short',
          strengthDescription: 'Weak',
          strengthScore: 25,
          complexityRating: 'Low',
          improvementTip: 'Use at least 8 characters',
          requirements: ['8+ characters'],
          vulnerabilities: ['Too short'],
          warningMessage: 'Consider adding uppercase',
          allErrors: ['Error 1', 'Error 2'],
          allWarnings: ['Warning 1'],
          checks: {'minLength': false, 'uppercase': false},
        );

        expect(result.isValid, isFalse);
        expect(result.errorMessage, equals('Password too short'));
        expect(result.warningMessage, equals('Consider adding uppercase'));
        expect(result.strengthDescription, equals('Weak'));
        expect(result.strengthScore, equals(25));
        expect(result.complexityRating, equals('Low'));
        expect(result.improvementTip, equals('Use at least 8 characters'));
        expect(result.requirements, equals(['8+ characters']));
        expect(result.vulnerabilities, equals(['Too short']));
        expect(result.allErrors, equals(['Error 1', 'Error 2']));
        expect(result.allWarnings, equals(['Warning 1']));
        expect(result.checks, equals({'minLength': false, 'uppercase': false}));
      });

      test('should handle empty collections in factories', () {
        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          requirements: [],
          vulnerabilities: [],
          allWarnings: [],
          checks: {},
        );

        expect(result.requirements, isEmpty);
        expect(result.vulnerabilities, isEmpty);
        expect(result.allWarnings, isEmpty);
        expect(result.checks, isEmpty);
      });

      test('should handle null optional parameters in factories', () {
        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
        );

        expect(result.improvementTip, isNull);
        expect(result.warningMessage, isNull);
      });
    });

    group('Collection Immutability', () {
      test('should provide unmodifiable collections', () {
        final result = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          allWarnings: ['Warning 1'],
          checks: {'minLength': true},
        );

        // Test that collections are unmodifiable
        expect(() => result.allErrors.add('New error'), throwsUnsupportedError);
        expect(() => result.allWarnings.add('New warning'),
            throwsUnsupportedError);
        expect(() => result.checks['newCheck'] = true, throwsUnsupportedError);
      });
    });

    group('String Representation', () {
      test('should format toString correctly with all fields', () {
        final result = PasswordValidationResult(
          isValid: true,
          errorMessage: 'Test error',
          warningMessage: 'Test warning',
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          improvementTip: 'Add special characters',
          requirements: ['8+ characters'],
          vulnerabilities: ['No special characters'],
        );

        final toString = result.toString();

        expect(toString, contains('isValid: true'));
        expect(toString, contains('errorMessage: Test error'));
        expect(toString, contains('warningMessage: Test warning'));
        expect(toString, contains('strengthDescription: Strong'));
        expect(toString, contains('strengthScore: 85'));
        expect(toString, contains('complexityRating: High'));
        expect(toString, contains('improvementTip: Add special characters'));
        expect(toString, contains('requirements: [8+ characters]'));
        expect(toString, contains('vulnerabilities: [No special characters]'));
      });

      test('should format toString correctly with null fields', () {
        final result = PasswordValidationResult(
          isValid: false,
          strengthDescription: 'Weak',
          strengthScore: 25,
          complexityRating: 'Low',
        );

        final toString = result.toString();

        expect(toString, contains('isValid: false'));
        expect(toString, contains('errorMessage: null'));
        expect(toString, contains('warningMessage: null'));
        expect(toString, contains('strengthDescription: Weak'));
        expect(toString, contains('strengthScore: 25'));
        expect(toString, contains('complexityRating: Low'));
        expect(toString, contains('improvementTip: null'));
        expect(toString, contains('requirements: []'));
        expect(toString, contains('vulnerabilities: []'));
      });
    });
  });

  group('PasswordStrengthLevel Tests', () {
    test('should have correct enum values', () {
      expect(PasswordStrengthLevel.values, hasLength(6));
      expect(PasswordStrengthLevel.values,
          contains(PasswordStrengthLevel.veryWeak));
      expect(
          PasswordStrengthLevel.values, contains(PasswordStrengthLevel.weak));
      expect(
          PasswordStrengthLevel.values, contains(PasswordStrengthLevel.fair));
      expect(
          PasswordStrengthLevel.values, contains(PasswordStrengthLevel.good));
      expect(
          PasswordStrengthLevel.values, contains(PasswordStrengthLevel.strong));
      expect(PasswordStrengthLevel.values,
          contains(PasswordStrengthLevel.veryStrong));
    });

    test('should provide localized display names', () {
      final messages = PasswordMessages.english;

      expect(PasswordStrengthLevel.veryWeak.getLocalizedDisplayName(messages),
          equals('Very Weak'));
      expect(PasswordStrengthLevel.weak.getLocalizedDisplayName(messages),
          equals('Weak'));
      expect(PasswordStrengthLevel.fair.getLocalizedDisplayName(messages),
          equals('Fair'));
      expect(PasswordStrengthLevel.good.getLocalizedDisplayName(messages),
          equals('Good'));
      expect(PasswordStrengthLevel.strong.getLocalizedDisplayName(messages),
          equals('Strong'));
      expect(PasswordStrengthLevel.veryStrong.getLocalizedDisplayName(messages),
          equals('Very Strong'));
    });

    test('should work with different language messages', () {
      final spanishMessages = PasswordMessages.spanish;

      expect(
          PasswordStrengthLevel.veryWeak
              .getLocalizedDisplayName(spanishMessages),
          equals('Muy Débil'));
      expect(
          PasswordStrengthLevel.weak.getLocalizedDisplayName(spanishMessages),
          equals('Débil'));
      expect(
          PasswordStrengthLevel.fair.getLocalizedDisplayName(spanishMessages),
          equals('Regular'));
      expect(
          PasswordStrengthLevel.good.getLocalizedDisplayName(spanishMessages),
          equals('Buena'));
      expect(
          PasswordStrengthLevel.strong.getLocalizedDisplayName(spanishMessages),
          equals('Fuerte'));
      expect(
          PasswordStrengthLevel.veryStrong
              .getLocalizedDisplayName(spanishMessages),
          equals('Muy Fuerte'));
    });

    test('should work with French messages', () {
      final frenchMessages = PasswordMessages.french;

      expect(
          PasswordStrengthLevel.veryWeak
              .getLocalizedDisplayName(frenchMessages),
          equals('Très Faible'));
      expect(PasswordStrengthLevel.weak.getLocalizedDisplayName(frenchMessages),
          equals('Faible'));
      expect(PasswordStrengthLevel.fair.getLocalizedDisplayName(frenchMessages),
          equals('Moyen'));
      expect(PasswordStrengthLevel.good.getLocalizedDisplayName(frenchMessages),
          equals('Bon'));
      expect(
          PasswordStrengthLevel.strong.getLocalizedDisplayName(frenchMessages),
          equals('Fort'));
      expect(
          PasswordStrengthLevel.veryStrong
              .getLocalizedDisplayName(frenchMessages),
          equals('Très Fort'));
    });

    test('should work with German messages', () {
      final germanMessages = PasswordMessages.german;

      expect(
          PasswordStrengthLevel.veryWeak
              .getLocalizedDisplayName(germanMessages),
          equals('Sehr Schwach'));
      expect(PasswordStrengthLevel.weak.getLocalizedDisplayName(germanMessages),
          equals('Schwach'));
      expect(PasswordStrengthLevel.fair.getLocalizedDisplayName(germanMessages),
          equals('Mittel'));
      expect(PasswordStrengthLevel.good.getLocalizedDisplayName(germanMessages),
          equals('Gut'));
      expect(
          PasswordStrengthLevel.strong.getLocalizedDisplayName(germanMessages),
          equals('Stark'));
      expect(
          PasswordStrengthLevel.veryStrong
              .getLocalizedDisplayName(germanMessages),
          equals('Sehr Stark'));
    });

    test('should work with Portuguese messages', () {
      final portugueseMessages = PasswordMessages.portuguese;

      expect(
          PasswordStrengthLevel.veryWeak
              .getLocalizedDisplayName(portugueseMessages),
          equals('Muito Fraca'));
      expect(
          PasswordStrengthLevel.weak
              .getLocalizedDisplayName(portugueseMessages),
          equals('Fraca'));
      expect(
          PasswordStrengthLevel.fair
              .getLocalizedDisplayName(portugueseMessages),
          equals('Regular'));
      expect(
          PasswordStrengthLevel.good
              .getLocalizedDisplayName(portugueseMessages),
          equals('Boa'));
      expect(
          PasswordStrengthLevel.strong
              .getLocalizedDisplayName(portugueseMessages),
          equals('Forte'));
      expect(
          PasswordStrengthLevel.veryStrong
              .getLocalizedDisplayName(portugueseMessages),
          equals('Muito Forte'));
    });

    test('should work with Italian messages', () {
      final italianMessages = PasswordMessages.italian;

      expect(
          PasswordStrengthLevel.veryWeak
              .getLocalizedDisplayName(italianMessages),
          equals('Molto Debole'));
      expect(
          PasswordStrengthLevel.weak.getLocalizedDisplayName(italianMessages),
          equals('Debole'));
      expect(
          PasswordStrengthLevel.fair.getLocalizedDisplayName(italianMessages),
          equals('Discreta'));
      expect(
          PasswordStrengthLevel.good.getLocalizedDisplayName(italianMessages),
          equals('Buona'));
      expect(
          PasswordStrengthLevel.strong.getLocalizedDisplayName(italianMessages),
          equals('Forte'));
      expect(
          PasswordStrengthLevel.veryStrong
              .getLocalizedDisplayName(italianMessages),
          equals('Molto Forte'));
    });

    test('should work with Persian messages', () {
      final persianMessages = PasswordMessages.persian;

      expect(
          PasswordStrengthLevel.veryWeak
              .getLocalizedDisplayName(persianMessages),
          equals('خیلی ضعیف'));
      expect(
          PasswordStrengthLevel.weak.getLocalizedDisplayName(persianMessages),
          equals('ضعیف'));
      expect(
          PasswordStrengthLevel.fair.getLocalizedDisplayName(persianMessages),
          equals('متوسط'));
      expect(
          PasswordStrengthLevel.good.getLocalizedDisplayName(persianMessages),
          equals('خوب'));
      expect(
          PasswordStrengthLevel.strong.getLocalizedDisplayName(persianMessages),
          equals('قوی'));
      expect(
          PasswordStrengthLevel.veryStrong
              .getLocalizedDisplayName(persianMessages),
          equals('خیلی قوی'));
    });
  });
}
