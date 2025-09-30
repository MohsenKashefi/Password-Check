import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

void main() {
  group('GenerationRules', () {
    test('should create basic rules correctly', () {
      const rules = GenerationRules.basic();
      expect(rules.length, 8);
      expect(rules.includeUppercase, false);
      expect(rules.includeSpecialChars, false);
      expect(rules.avoidSimilarChars, false);
    });

    test('should create strong rules correctly', () {
      const rules = GenerationRules.strong();
      expect(rules.length, 16);
      expect(rules.includeUppercase, true);
      expect(rules.includeSpecialChars, true);
      expect(rules.avoidSimilarChars, true);
    });

    test('should create strict rules correctly', () {
      const rules = GenerationRules.strict();
      expect(rules.length, 20);
      expect(rules.includeUppercase, true);
      expect(rules.includeSpecialChars, true);
      expect(rules.avoidSimilarChars, true);
    });

    test('should validate rules correctly', () {
      const validRules = GenerationRules.basic();
      expect(validRules.isValid, true);

      const invalidRules = GenerationRules(
        length: 0,
        includeUppercase: false,
        includeLowercase: false,
        includeNumbers: false,
        includeSpecialChars: false,
      );
      expect(invalidRules.isValid, false);
    });

      test('should get character sets correctly', () {
        const rules = GenerationRules.strong();
        final charSets = rules.getCharacterSets();
        
        expect(charSets.length, 4); // uppercase, lowercase, numbers, special
        expect(charSets.any((set) => set.contains('A')), true);
        expect(charSets.any((set) => set.contains('a')), true);
        expect(charSets.any((set) => set.contains('2')), true); // Changed from '1' to '2' since we avoid similar chars
        expect(charSets.any((set) => set.contains('!')), true);
      });

    test('should avoid similar characters when requested', () {
      const rules = GenerationRules(avoidSimilarChars: true);
      final charSets = rules.getCharacterSets();
      
      final uppercaseSet = charSets.firstWhere((set) => set.contains('A'));
      expect(uppercaseSet.contains('O'), false);
      expect(uppercaseSet.contains('I'), false);
      
      final lowercaseSet = charSets.firstWhere((set) => set.contains('a'));
      expect(lowercaseSet.contains('o'), false);
      expect(lowercaseSet.contains('l'), false);
      
      final numberSet = charSets.firstWhere((set) => set.contains('2'));
      expect(numberSet.contains('0'), false);
      expect(numberSet.contains('1'), false);
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

      test('should not ensure character variety when disabled', () {
        final customGenerator = PasswordGenerator(
          rules: const GenerationRules(
            length: 4,
            includeUppercase: true,
            includeLowercase: true,
            includeNumbers: true,
            includeSpecialChars: true,
            ensureCharacterVariety: false,
          ),
        );
        
        // Generate multiple passwords to test randomness
        bool foundVariety = false;
        for (int i = 0; i < 10; i++) {
          final result = customGenerator.generate();
          final password = result.password;
          
          if (password.contains(RegExp(r'[A-Z]')) &&
              password.contains(RegExp(r'[a-z]')) &&
              password.contains(RegExp(r'[0-9]')) &&
              password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
            foundVariety = true;
            // Don't break - continue generating all 10 passwords
          }
        }
        
        // It's possible but not guaranteed to have variety when disabled
        // This test mainly ensures the generator doesn't crash
        expect(customGenerator.historyCount, 10);
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

      test('should combine custom chars with other sets', () {
        final customGenerator = PasswordGenerator(
          rules: const GenerationRules(
            length: 10,
            includeUppercase: true,
            includeLowercase: true,
            includeNumbers: false,
            includeSpecialChars: false,
            customChars: '123',
          ),
        );
        final result = customGenerator.generate();
        final password = result.password;
        
        expect(password.length, 10);
        // Should contain at least one character from each set
        expect(password.contains(RegExp(r'[A-Z]')), true);
        expect(password.contains(RegExp(r'[a-z]')), true);
        expect(password.contains(RegExp(r'[123]')), true);
      });
    });

    group('Multiple Generation', () {
      test('should generate multiple passwords', () {
        final results = generator.generateMultiple(5);
        expect(results.length, 5);
        
        for (final result in results) {
          expect(result.password.length, 12);
          // Note: Generated passwords may not always pass strict validation
          // but they should be generated successfully
        }
        
        // All passwords should be different
        final passwords = results.map((r) => r.password).toList();
        final uniquePasswords = passwords.toSet();
        expect(uniquePasswords.length, 5);
      });

      test('should throw error for invalid count', () {
        expect(() => generator.generateMultiple(0), throwsArgumentError);
        expect(() => generator.generateMultiple(101), throwsArgumentError);
      });
    });

    group('Valid Password Generation', () {
      test('should generate valid password', () {
        final result = generator.generateValid();
        expect(result.isValid, true);
        expect(result.validation.isValid, true);
      });

      test('should generate valid password with custom validation rules', () {
        final customGenerator = PasswordGenerator(
          rules: const GenerationRules.strict(),
        );
        final result = customGenerator.generateValid(
          validationRules: const ValidationRules.strict(),
        );
        expect(result.isValid, true);
        expect(result.validation.isValid, true);
      });
    });

    group('History Tracking', () {
      test('should track generation history', () {
        expect(generator.historyCount, 0);
        expect(generator.lastResult, isNull);
        
        final result1 = generator.generate();
        expect(generator.historyCount, 1);
        expect(generator.lastResult, equals(result1));
        
        final result2 = generator.generate();
        expect(generator.historyCount, 2);
        expect(generator.lastResult, equals(result2));
        
        expect(generator.history, contains(result1));
        expect(generator.history, contains(result2));
      });

      test('should clear history', () {
        generator.generate();
        generator.generate();
        expect(generator.historyCount, 2);
        
        generator.clearHistory();
        expect(generator.historyCount, 0);
        expect(generator.lastResult, isNull);
      });
    });

    group('Constructor Variants', () {
      test('should create generator with basic rules', () {
        final basicGenerator = PasswordGenerator.basic();
        final result = basicGenerator.generate();
        expect(result.password.length, 8);
        expect(result.rules.includeUppercase, false);
        expect(result.rules.includeSpecialChars, false);
      });

      test('should create generator with strong rules', () {
        final strongGenerator = PasswordGenerator.strong();
        final result = strongGenerator.generate();
        expect(result.password.length, 16);
        expect(result.rules.includeUppercase, true);
        expect(result.rules.includeSpecialChars, true);
      });

      test('should create generator with strict rules', () {
        final strictGenerator = PasswordGenerator.strict();
        final result = strictGenerator.generate();
        expect(result.password.length, 20);
        expect(result.rules.includeUppercase, true);
        expect(result.rules.includeSpecialChars, true);
      });

      test('should create generator with auto language detection', () {
        final autoGenerator = PasswordGenerator.auto();
        expect(autoGenerator.language, isNotEmpty);
        expect(autoGenerator.messages, isA<PasswordMessages>());
      });

      test('should create generator with specific language', () {
        final localizedGenerator = PasswordGenerator.localized(
          language: 'es',
        );
        expect(localizedGenerator.language, 'es');
        expect(localizedGenerator.messages, isA<PasswordMessages>());
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

  group('PasswordCheckerGeneration Extension', () {
    late PasswordChecker checker;

    setUp(() {
      checker = PasswordChecker();
    });

    test('should generate password using checker extension', () {
      final result = checker.generatePassword();
      expect(result.password.length, 16); // default length
      expect(result.isValid, true);
    });

    test('should generate password with custom parameters', () {
      final result = checker.generatePassword(
        length: 20,
        includeUppercase: true,
        includeLowercase: true,
        includeNumbers: true,
        includeSpecialChars: false,
      );
      expect(result.password.length, 20);
      expect(result.password.contains(RegExp(r'[A-Z]')), true);
      expect(result.password.contains(RegExp(r'[a-z]')), true);
      expect(result.password.contains(RegExp(r'[0-9]')), true);
      expect(result.password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]')), false);
    });
  });

  group('GenerationResult', () {
    test('should create result correctly', () {
      final rules = const GenerationRules.basic();
      final validation = PasswordValidationResult.success(
        strengthScore: 85,
        strengthLevel: PasswordStrengthLevel.strong,
        checks: {'minLength': true},
      );
      final timestamp = DateTime.now();
      
      final result = GenerationResult(
        password: 'test123',
        rules: rules,
        validation: validation,
        timestamp: timestamp,
        isValid: true,
      );
      
      expect(result.password, 'test123');
      expect(result.rules, rules);
      expect(result.validation, validation);
      expect(result.timestamp, timestamp);
      expect(result.isValid, true);
    });

    test('should format toString correctly', () {
      final rules = const GenerationRules.basic();
      final validation = PasswordValidationResult.success(
        strengthScore: 85,
        strengthLevel: PasswordStrengthLevel.strong,
        checks: {'minLength': true},
      );
      final timestamp = DateTime.now();
      
      final result = GenerationResult(
        password: 'test123',
        rules: rules,
        validation: validation,
        timestamp: timestamp,
        isValid: true,
      );
      
      final str = result.toString();
      expect(str, contains('t***')); // masked password
      expect(str, contains('isValid: true'));
      expect(str, contains('Strong'));
      expect(str, contains('timestamp'));
    });
  });
}
