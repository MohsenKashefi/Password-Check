import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

void main() {
  group('GenerationRules', () {
    test('should create basic rules correctly', () {
      const rules = GenerationRules.basic();
      expect(rules.length, 8);
      expect(rules.includeUppercase, true);
      expect(rules.includeLowercase, true);
      expect(rules.includeNumbers, true);
      expect(rules.includeSpecialChars, false);
      expect(rules.avoidSimilarChars, false);
      expect(rules.ensureCharacterVariety, false);
    });

    test('should create strong rules correctly', () {
      const rules = GenerationRules.strong();
      expect(rules.length, 12);
      expect(rules.includeUppercase, true);
      expect(rules.includeLowercase, true);
      expect(rules.includeNumbers, true);
      expect(rules.includeSpecialChars, true);
      expect(rules.avoidSimilarChars, true);
      expect(rules.ensureCharacterVariety, true);
    });

    test('should create strict rules correctly', () {
      const rules = GenerationRules.strict();
      expect(rules.length, 16);
      expect(rules.includeUppercase, true);
      expect(rules.includeLowercase, true);
      expect(rules.includeNumbers, true);
      expect(rules.includeSpecialChars, true);
      expect(rules.avoidSimilarChars, true);
      expect(rules.ensureCharacterVariety, true);
    });

    test('should create custom rules correctly', () {
      const rules = GenerationRules(
        length: 20,
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: false,
        includeSpecialChars: true,
        avoidSimilarChars: true,
        ensureCharacterVariety: true,
      );
      expect(rules.length, 20);
      expect(rules.includeUppercase, true);
      expect(rules.includeLowercase, true);
      expect(rules.includeNumbers, false);
      expect(rules.includeSpecialChars, true);
      expect(rules.avoidSimilarChars, true);
      expect(rules.ensureCharacterVariety, true);
    });
  });

  group('PasswordGenerator', () {
    late PasswordGenerator generator;

    setUp(() {
      generator = PasswordGenerator();
    });

    group('Basic Generation', () {
      test('should generate password with correct length', () {
        final result = generator.generate();
        expect(result.password.length, 12); // default length
        expect(result.rules, isA<GenerationRules>());
        expect(result.timestamp, isA<DateTime>());
        expect(result.isValid, true);
      });

      test('should generate password with custom length', () {
        final customGenerator = PasswordGenerator(
          rules: const GenerationRules(length: 20),
        );
        final result = customGenerator.generate();
        expect(result.password.length, 20);
      });

      test('should generate different passwords on multiple calls', () {
        final result1 = generator.generate();
        final result2 = generator.generate();
        expect(result1.password, isNot(equals(result2.password)));
      });

      test('should generate password with only specified character types', () {
        final customGenerator = PasswordGenerator(
          rules: const GenerationRules(
            length: 10,
            includeUppercase: true,
            includeLowercase: false,
            includeNumbers: false,
            includeSpecialChars: false,
          ),
        );
        final result = customGenerator.generate();
        final password = result.password;
        
        expect(password.length, 10);
        expect(password.contains(RegExp(r'[A-Z]')), true);
        expect(password.contains(RegExp(r'[a-z]')), false);
        expect(password.contains(RegExp(r'[0-9]')), false);
        expect(password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]')), false);
      });
    });

    group('Character Variety', () {
      test('should ensure character variety when requested', () {
        final customGenerator = PasswordGenerator(
          rules: const GenerationRules(
            length: 4,
            includeUppercase: true,
            includeLowercase: true,
            includeNumbers: true,
            includeSpecialChars: true,
            ensureCharacterVariety: true,
          ),
        );
        final result = customGenerator.generate();
        final password = result.password;
        
        expect(password.contains(RegExp(r'[A-Z]')), true);
        expect(password.contains(RegExp(r'[a-z]')), true);
        expect(password.contains(RegExp(r'[0-9]')), true);
        expect(password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]')), true);
      });

    });

    group('Custom Character Sets', () {
      test('should use custom character set', () {
        final customGenerator = PasswordGenerator(
          rules: const GenerationRules(
            length: 10,
            includeUppercase: false,
            includeLowercase: false,
            includeNumbers: false,
            includeSpecialChars: false,
            customChars: 'ABC123',
          ),
        );
        final result = customGenerator.generate();
        final password = result.password;
        
        expect(password.length, 10);
        expect(password.contains(RegExp(r'[ABC123]')), true);
        expect(password.contains(RegExp(r'[^ABC123]')), false);
      });

    });

    group('Multiple Generation', () {
      test('should generate multiple passwords', () {
        final results = generator.generateMultiple(5);
        expect(results.length, 5);
        
        for (final result in results) {
          expect(result.password.length, 12);
          expect(result.isValid, true);
        }
        
        // All passwords should be different
        final passwords = results.map((r) => r.password).toList();
        final uniquePasswords = passwords.toSet();
        expect(uniquePasswords.length, 5);
      });

      test('should handle edge cases for count', () {
        // Test with count 0 - should return empty list
        final emptyResults = generator.generateMultiple(0);
        expect(emptyResults, isEmpty);
        
        // Test with negative count - should return empty list
        final negativeResults = generator.generateMultiple(-1);
        expect(negativeResults, isEmpty);
      });
    });

    group('Valid Password Generation', () {
      test('should generate and validate password', () {
        final result = generator.generateAndValidate(const ValidationRules.strong());
        expect(result.isValid, true);
        expect(result.validationResult, isNotNull);
        expect(result.validationResult!.isValid, true);
      });

      test('should generate and validate password with custom validation rules', () {
        final customGenerator = PasswordGenerator(
          rules: const GenerationRules(
            length: 20,
            includeUppercase: true,
            includeLowercase: true,
            includeNumbers: true,
            includeSpecialChars: true,
            ensureCharacterVariety: true,
          ),
        );
        final result = customGenerator.generateAndValidate(const ValidationRules.strong());
        expect(result.isValid, true);
        expect(result.validationResult, isNotNull);
        expect(result.validationResult!.isValid, true);
      });
    });

    group('History Tracking', () {
      test('should track generation history', () {
        expect(generator.history.length, 0);
        
        final result1 = generator.generate();
        expect(generator.history.length, 1);
        expect(generator.history, contains(result1));
        
        final result2 = generator.generate();
        expect(generator.history.length, 2);
        expect(generator.history, contains(result2));
      });

      test('should clear history', () {
        generator.generate();
        generator.generate();
        expect(generator.history.length, 2);
        
        generator.clearHistory();
        expect(generator.history.length, 0);
      });

      test('should provide last password', () {
        final result1 = generator.generate();
        expect(generator.lastPassword, equals(result1.password));
        
        final result2 = generator.generate();
        expect(generator.lastPassword, equals(result2.password));
      });
    });

    group('Constructor Variants', () {
      test('should create generator with basic rules', () {
        final basicGenerator = PasswordGenerator.basic();
        final result = basicGenerator.generate();
        expect(result.password.length, 8);
        expect(result.rules.includeUppercase, true);
        expect(result.rules.includeSpecialChars, false);
      });

      test('should create generator with strong rules', () {
        final strongGenerator = PasswordGenerator.strong();
        final result = strongGenerator.generate();
        expect(result.password.length, 12);
        expect(result.rules.includeUppercase, true);
        expect(result.rules.includeSpecialChars, true);
      });

      test('should create generator with strict rules', () {
        final strictGenerator = PasswordGenerator.strict();
        final result = strictGenerator.generate();
        expect(result.password.length, 16);
        expect(result.rules.includeUppercase, true);
        expect(result.rules.includeSpecialChars, true);
      });
    });

    group('Error Handling', () {
      test('should throw error for invalid generation rules', () {
        final invalidGenerator = PasswordGenerator(
          rules: const GenerationRules(
            length: 0,
            includeUppercase: false,
            includeLowercase: false,
            includeNumbers: false,
            includeSpecialChars: false,
          ),
        );
        expect(() => invalidGenerator.generate(), throwsArgumentError);
      });
    });
  });

  group('GenerationResult', () {
    test('should create result correctly', () {
      final rules = const GenerationRules.basic();
      final validation = PasswordValidationResult.success(
        strengthDescription: 'Strong',
        strengthScore: 85,
        complexityRating: 'High',
        checks: {'minLength': true},
      );
      final timestamp = DateTime.now();
      
      final result = GenerationResult(
        password: 'test123',
        strengthScore: 85,
        strengthLevel: PasswordStrengthLevel.strong,
        rules: rules,
        timestamp: timestamp,
        isValid: true,
        validationResult: validation,
      );
      
      expect(result.password, 'test123');
      expect(result.strengthScore, 85);
      expect(result.strengthLevel, PasswordStrengthLevel.strong);
      expect(result.rules, rules);
      expect(result.validationResult, validation);
      expect(result.timestamp, timestamp);
      expect(result.isValid, true);
    });

      test('should format toString correctly', () {
        final rules = const GenerationRules.basic();
        final validation = PasswordValidationResult.success(
          strengthDescription: 'Strong',
          strengthScore: 85,
          complexityRating: 'High',
          checks: {'minLength': true},
        );
        final timestamp = DateTime.now();
        
        final result = GenerationResult(
          password: 'test123',
          strengthScore: 85,
          strengthLevel: PasswordStrengthLevel.strong,
          rules: rules,
          timestamp: timestamp,
          isValid: true,
          validationResult: validation,
        );
        
        final str = result.toString();
        expect(str, contains('test123'));
        expect(str, contains('isValid: true'));
        expect(str, contains('PasswordStrengthLevel.strong'));
        expect(str, contains('timestamp'));
      });
  });
}
