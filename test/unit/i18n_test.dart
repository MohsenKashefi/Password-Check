import 'package:flutter_test/flutter_test.dart';
import 'package:password_checker_pro/password_checker_pro.dart';

void main() {
  group('Internationalization Tests', () {
    group('PasswordMessages', () {
      test('should provide English messages by default', () {
        const messages = PasswordMessages.english;
        expect(messages.minLength, 'Password must be at least {min} characters long');
        expect(messages.requireUppercase, 'Password must contain at least one uppercase letter');
        expect(messages.requireLowercase, 'Password must contain at least one lowercase letter');
        expect(messages.requireNumbers, 'Password must contain at least one number');
        expect(messages.requireSpecialChars, 'Password must contain at least one special character');
        expect(messages.veryWeak, 'Very Weak');
        expect(messages.weak, 'Weak');
        expect(messages.fair, 'Fair');
        expect(messages.good, 'Good');
        expect(messages.strong, 'Strong');
        expect(messages.veryStrong, 'Very Strong');
      });

      test('should provide Spanish messages', () {
        const messages = PasswordMessages.spanish;
        expect(messages.minLength, 'La contraseña debe tener al menos {min} caracteres');
        expect(messages.requireUppercase, 'La contraseña debe contener al menos una letra mayúscula');
        expect(messages.veryWeak, 'Muy Débil');
        expect(messages.strong, 'Fuerte');
      });

      test('should provide French messages', () {
        const messages = PasswordMessages.french;
        expect(messages.minLength, 'Le mot de passe doit contenir au moins {min} caractères');
        expect(messages.requireUppercase, 'Le mot de passe doit contenir au moins une lettre majuscule');
        expect(messages.veryWeak, 'Très Faible');
        expect(messages.strong, 'Fort');
      });

      test('should provide German messages', () {
        const messages = PasswordMessages.german;
        expect(messages.minLength, 'Das Passwort muss mindestens {min} Zeichen lang sein');
        expect(messages.requireUppercase, 'Das Passwort muss mindestens einen Großbuchstaben enthalten');
        expect(messages.veryWeak, 'Sehr Schwach');
        expect(messages.strong, 'Stark');
      });

      test('should provide Portuguese messages', () {
        const messages = PasswordMessages.portuguese;
        expect(messages.minLength, 'A senha deve ter pelo menos {min} caracteres');
        expect(messages.requireUppercase, 'A senha deve conter pelo menos uma letra maiúscula');
        expect(messages.veryWeak, 'Muito Fraca');
        expect(messages.strong, 'Forte');
      });

      test('should provide Italian messages', () {
        const messages = PasswordMessages.italian;
        expect(messages.minLength, 'La password deve essere di almeno {min} caratteri');
        expect(messages.requireUppercase, 'La password deve contenere almeno una lettera maiuscola');
        expect(messages.veryWeak, 'Molto Debole');
        expect(messages.strong, 'Forte');
      });

      test('should provide Persian messages', () {
        const messages = PasswordMessages.persian;
        expect(messages.minLength, 'رمز عبور باید حداقل {min} کاراکتر باشد');
        expect(messages.requireUppercase, 'رمز عبور باید حداقل یک حرف بزرگ داشته باشد');
        expect(messages.veryWeak, 'خیلی ضعیف');
        expect(messages.strong, 'قوی');
      });

      test('should substitute parameters in messages', () {
        const messages = PasswordMessages.english;
        final message = messages.getMessage('minLength', params: {'min': 8});
        expect(message, 'Password must be at least 8 characters long');
      });

      test('should handle missing parameters gracefully', () {
        const messages = PasswordMessages.english;
        final message = messages.getMessage('minLength', params: {'max': 10});
        expect(message, 'Password must be at least {min} characters long');
      });
    });

    group('LanguageDetector', () {
      test('should detect supported languages', () {
        expect(LanguageDetector.isLanguageSupported('en'), true);
        expect(LanguageDetector.isLanguageSupported('es'), true);
        expect(LanguageDetector.isLanguageSupported('fr'), true);
        expect(LanguageDetector.isLanguageSupported('de'), true);
        expect(LanguageDetector.isLanguageSupported('pt'), true);
        expect(LanguageDetector.isLanguageSupported('it'), true);
        expect(LanguageDetector.isLanguageSupported('fa'), true);
        expect(LanguageDetector.isLanguageSupported('per'), true);
        expect(LanguageDetector.isLanguageSupported('zh'), false);
        expect(LanguageDetector.isLanguageSupported('ja'), false);
      });

      test('should get messages for supported languages', () {
        final englishMessages = LanguageDetector.getMessagesForLanguage('en');
        final spanishMessages = LanguageDetector.getMessagesForLanguage('es');
        final frenchMessages = LanguageDetector.getMessagesForLanguage('fr');
        final germanMessages = LanguageDetector.getMessagesForLanguage('de');
        final portugueseMessages = LanguageDetector.getMessagesForLanguage('pt');
        final italianMessages = LanguageDetector.getMessagesForLanguage('it');
        final persianMessages = LanguageDetector.getMessagesForLanguage('fa');
        
        expect(englishMessages.minLength, contains('Password must be'));
        expect(spanishMessages.minLength, contains('contraseña'));
        expect(frenchMessages.minLength, contains('mot de passe'));
        expect(germanMessages.minLength, contains('Passwort'));
        expect(portugueseMessages.minLength, contains('senha'));
        expect(italianMessages.minLength, contains('password'));
        expect(persianMessages.minLength, contains('رمز عبور'));
      });

      test('should fallback to English for unsupported languages', () {
        final messages = LanguageDetector.getMessagesForLanguage('zh');
        expect(messages.minLength, contains('Password must be'));
      });

      test('should get language names', () {
        expect(LanguageDetector.getLanguageName('en'), 'English');
        expect(LanguageDetector.getLanguageName('es'), 'Español');
        expect(LanguageDetector.getLanguageName('fr'), 'Français');
        expect(LanguageDetector.getLanguageName('de'), 'Deutsch');
        expect(LanguageDetector.getLanguageName('pt'), 'Português');
        expect(LanguageDetector.getLanguageName('it'), 'Italiano');
        expect(LanguageDetector.getLanguageName('fa'), 'فارسی');
        expect(LanguageDetector.getLanguageName('per'), 'فارسی');
        expect(LanguageDetector.getLanguageName('zh'), 'English'); // fallback
      });

      test('should get supported languages list', () {
        final supportedLanguages = LanguageDetector.getSupportedLanguages();
        expect(supportedLanguages, hasLength(8));
        expect(supportedLanguages, contains('en'));
        expect(supportedLanguages, contains('es'));
        expect(supportedLanguages, contains('fr'));
        expect(supportedLanguages, contains('de'));
        expect(supportedLanguages, contains('pt'));
        expect(supportedLanguages, contains('it'));
        expect(supportedLanguages, contains('fa'));
        expect(supportedLanguages, contains('per'));
      });
    });

    group('CustomMessages', () {
      test('should create custom messages from map', () {
        final customMessages = CustomMessages.fromMap({
          'minLength': 'Custom minimum length message',
          'requireUppercase': 'Custom uppercase message',
          'strong': 'Custom strong message',
        });

        expect(customMessages.getMessage('minLength'), 'Custom minimum length message');
        expect(customMessages.getMessage('requireUppercase'), 'Custom uppercase message');
        expect(customMessages.getMessage('strong'), 'Custom strong message');
        expect(customMessages.hasMessage('minLength'), true);
        expect(customMessages.hasMessage('notCommon'), false);
      });

      test('should create custom messages from JSON', () {
        final customMessages = CustomMessages.fromJson({
          'minLength': 'JSON minimum length message',
          'requireUppercase': 'JSON uppercase message',
        });

        expect(customMessages.getMessage('minLength'), 'JSON minimum length message');
        expect(customMessages.getMessage('requireUppercase'), 'JSON uppercase message');
      });

      test('should merge custom messages', () {
        final messages1 = CustomMessages.fromMap({'minLength': 'Message 1'});
        final messages2 = CustomMessages.fromMap({'requireUppercase': 'Message 2'});
        final merged = messages1.merge(messages2);

        expect(merged.getMessage('minLength'), 'Message 1');
        expect(merged.getMessage('requireUppercase'), 'Message 2');
      });

      test('should apply custom messages to base messages', () {
        final customMessages = CustomMessages.fromMap({
          'minLength': 'Custom minimum length message',
          'strong': 'Custom strong message',
        });

        final baseMessages = PasswordMessages.english;
        final appliedMessages = customMessages.applyTo(baseMessages);

        expect(appliedMessages.minLength, 'Custom minimum length message');
        expect(appliedMessages.strong, 'Custom strong message');
        expect(appliedMessages.requireUppercase, baseMessages.requireUppercase);
      });

      test('should handle empty custom messages', () {
        final customMessages = CustomMessages.fromMap({});
        final baseMessages = PasswordMessages.english;
        final appliedMessages = customMessages.applyTo(baseMessages);

        expect(appliedMessages.minLength, baseMessages.minLength);
        expect(appliedMessages.requireUppercase, baseMessages.requireUppercase);
      });
    });

    group('PasswordChecker with i18n', () {
      test('should use English messages by default', () {
        final checker = PasswordChecker();
        final result = checker.validate('short');

        expect(result.errorDisplay, contains('Password must be at least 8 characters long'));
      });

      test('should use Spanish messages when specified', () {
        final checker = PasswordChecker(language: 'es');
        final result = checker.validate('short');

        expect(result.errorDisplay, contains('La contraseña debe tener al menos 8 caracteres'));
      });

      test('should use French messages when specified', () {
        final checker = PasswordChecker(language: 'fr');
        final result = checker.validate('short');

        expect(result.errorDisplay, contains('Le mot de passe doit contenir au moins 8 caractères'));
      });

      test('should use German messages when specified', () {
        final checker = PasswordChecker(language: 'de');
        final result = checker.validate('short');

        expect(result.errorDisplay, contains('Das Passwort muss mindestens 8 Zeichen lang sein'));
      });

      test('should use Portuguese messages when specified', () {
        final checker = PasswordChecker(language: 'pt');
        final result = checker.validate('short');

        expect(result.errorDisplay, contains('A senha deve ter pelo menos 8 caracteres'));
      });

      test('should use Italian messages when specified', () {
        final checker = PasswordChecker(language: 'it');
        final result = checker.validate('short');

        expect(result.errorDisplay, contains('La password deve essere di almeno 8 caratteri'));
      });

      test('should use Persian messages when specified', () {
        final checker = PasswordChecker(language: 'fa');
        final result = checker.validate('کوتاه');

        expect(result.errorDisplay, contains('رمز عبور باید حداقل 8 کاراکتر باشد'));
      });

      test('should use custom messages when provided', () {
        final customMessages = CustomMessages.fromMap({
          'minLength': 'Custom minimum length message',
        });

        final checker = PasswordChecker(customMessages: customMessages);
        final result = checker.validate('short');

        expect(result.errorDisplay, contains('Custom minimum length message'));
      });

      test('should use localized strength level names', () {
        final checker = PasswordChecker(language: 'es');
        final result = checker.validate('MyStrongPassword123!');

        expect(result.strengthDescription, contains('Fuerte'));
      });

      test('should work with system language detection', () {
        final checker = PasswordChecker();
        final result = checker.validate('short');

        // Should use system language or fallback to English
        expect(result.errorDisplay, isNotEmpty);
      });

      test('should work with language parameter', () {
        final checker = PasswordChecker(language: 'es');
        final result = checker.validate('short');

        expect(result.errorDisplay, contains('La contraseña debe tener al menos 8 caracteres'));
      });
    });

    group('PasswordStrengthLevel with i18n', () {
      test('should get localized display names', () {
        const messages = PasswordMessages.spanish;
        
        expect(PasswordStrengthLevel.veryWeak.getLocalizedDisplayName(messages), 'Muy Débil');
        expect(PasswordStrengthLevel.weak.getLocalizedDisplayName(messages), 'Débil');
        expect(PasswordStrengthLevel.fair.getLocalizedDisplayName(messages), 'Regular');
        expect(PasswordStrengthLevel.good.getLocalizedDisplayName(messages), 'Buena');
        expect(PasswordStrengthLevel.strong.getLocalizedDisplayName(messages), 'Fuerte');
        expect(PasswordStrengthLevel.veryStrong.getLocalizedDisplayName(messages), 'Muy Fuerte');
      });

      test('should fallback to English display names', () {
        const messages = PasswordMessages.english;
        
        expect(PasswordStrengthLevel.veryWeak.getLocalizedDisplayName(messages), 'Very Weak');
        expect(PasswordStrengthLevel.strong.getLocalizedDisplayName(messages), 'Strong');
      });

      test('should work with all supported languages', () {
        final languages = ['en', 'es', 'fr', 'de', 'pt', 'it', 'fa'];
        
        for (final lang in languages) {
          final checker = PasswordChecker(language: lang);
          final result = checker.validate('MyStrongPassword123!');
          
          expect(result.strengthDescription, isNotEmpty);
        }
      });
    });

    group('Message Parameter Substitution', () {
      test('should substitute single parameter', () {
        const messages = PasswordMessages.english;
        final message = messages.getMessage('minLength', params: {'min': 12});
        expect(message, 'Password must be at least 12 characters long');
      });

      test('should substitute multiple parameters', () {
        const messages = PasswordMessages.english;
        final message = messages.getMessage('maxLength', params: {'max': 50});
        expect(message, 'Password must be no more than 50 characters long');
      });

      test('should handle missing parameters', () {
        const messages = PasswordMessages.english;
        final message = messages.getMessage('minLength', params: {});
        expect(message, 'Password must be at least {min} characters long');
      });

      test('should work with different languages', () {
        final spanishMessages = PasswordMessages.spanish;
        final message = spanishMessages.getMessage('minLength', params: {'min': 10});
        expect(message, 'La contraseña debe tener al menos 10 caracteres');
      });
    });
  });
}
