import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

void main() {
  group('PasswordMessages Extended Tests', () {
    test('should provide all language constants', () {
      // Test English messages
      expect(PasswordMessages.english.minLength, contains('{min}'));
      expect(PasswordMessages.english.maxLength, contains('{max}'));
      expect(PasswordMessages.english.requireUppercase, isNotEmpty);
      expect(PasswordMessages.english.requireLowercase, isNotEmpty);
      expect(PasswordMessages.english.requireNumbers, isNotEmpty);
      expect(PasswordMessages.english.requireSpecialChars, isNotEmpty);
      expect(PasswordMessages.english.noSpaces, isNotEmpty);
      expect(PasswordMessages.english.notCommon, isNotEmpty);
      expect(PasswordMessages.english.noRepeatedChars, isNotEmpty);
      expect(PasswordMessages.english.noSequentialChars, isNotEmpty);
      expect(PasswordMessages.english.veryWeak, isNotEmpty);
      expect(PasswordMessages.english.weak, isNotEmpty);
      expect(PasswordMessages.english.fair, isNotEmpty);
      expect(PasswordMessages.english.good, isNotEmpty);
      expect(PasswordMessages.english.strong, isNotEmpty);
      expect(PasswordMessages.english.veryStrong, isNotEmpty);
    });

    test('should provide Spanish messages', () {
      expect(PasswordMessages.spanish.minLength, contains('{min}'));
      expect(PasswordMessages.spanish.maxLength, contains('{max}'));
      expect(PasswordMessages.spanish.requireUppercase, contains('mayúscula'));
      expect(PasswordMessages.spanish.requireLowercase, contains('minúscula'));
      expect(PasswordMessages.spanish.requireNumbers, contains('número'));
      expect(PasswordMessages.spanish.requireSpecialChars, contains('carácter especial'));
      expect(PasswordMessages.spanish.noSpaces, contains('espacios'));
      expect(PasswordMessages.spanish.notCommon, contains('común'));
      expect(PasswordMessages.spanish.noRepeatedChars, contains('repetidos'));
      expect(PasswordMessages.spanish.noSequentialChars, contains('secuenciales'));
      expect(PasswordMessages.spanish.veryWeak, contains('Débil'));
      expect(PasswordMessages.spanish.weak, contains('Débil'));
      expect(PasswordMessages.spanish.fair, contains('Regular'));
      expect(PasswordMessages.spanish.good, contains('Buena'));
      expect(PasswordMessages.spanish.strong, contains('Fuerte'));
      expect(PasswordMessages.spanish.veryStrong, contains('Fuerte'));
    });

    test('should provide French messages', () {
      expect(PasswordMessages.french.minLength, contains('{min}'));
      expect(PasswordMessages.french.maxLength, contains('{max}'));
      expect(PasswordMessages.french.requireUppercase, contains('majuscule'));
      expect(PasswordMessages.french.requireLowercase, contains('minuscule'));
      expect(PasswordMessages.french.requireNumbers, contains('chiffre'));
      expect(PasswordMessages.french.requireSpecialChars, contains('caractère spécial'));
      expect(PasswordMessages.french.noSpaces, contains('espaces'));
      expect(PasswordMessages.french.notCommon, contains('commun'));
      expect(PasswordMessages.french.noRepeatedChars, contains('répétés'));
      expect(PasswordMessages.french.noSequentialChars, contains('séquentiels'));
      expect(PasswordMessages.french.veryWeak, contains('Faible'));
      expect(PasswordMessages.french.weak, contains('Faible'));
      expect(PasswordMessages.french.fair, contains('Moyen'));
      expect(PasswordMessages.french.good, contains('Bon'));
      expect(PasswordMessages.french.strong, contains('Fort'));
      expect(PasswordMessages.french.veryStrong, contains('Fort'));
    });

    test('should provide German messages', () {
      expect(PasswordMessages.german.minLength, contains('{min}'));
      expect(PasswordMessages.german.maxLength, contains('{max}'));
      expect(PasswordMessages.german.requireUppercase, contains('Großbuchstaben'));
      expect(PasswordMessages.german.requireLowercase, contains('Kleinbuchstaben'));
      expect(PasswordMessages.german.requireNumbers, contains('Zahl'));
      expect(PasswordMessages.german.requireSpecialChars, contains('Sonderzeichen'));
      expect(PasswordMessages.german.noSpaces, contains('Leerzeichen'));
      expect(PasswordMessages.german.notCommon, contains('häufig'));
      expect(PasswordMessages.german.noRepeatedChars, contains('wiederholte'));
      expect(PasswordMessages.german.noSequentialChars, contains('sequenzielle'));
      expect(PasswordMessages.german.veryWeak, contains('Schwach'));
      expect(PasswordMessages.german.weak, contains('Schwach'));
      expect(PasswordMessages.german.fair, contains('Mittel'));
      expect(PasswordMessages.german.good, contains('Gut'));
      expect(PasswordMessages.german.strong, contains('Stark'));
      expect(PasswordMessages.german.veryStrong, contains('Stark'));
    });

    test('should provide Portuguese messages', () {
      expect(PasswordMessages.portuguese.minLength, contains('{min}'));
      expect(PasswordMessages.portuguese.maxLength, contains('{max}'));
      expect(PasswordMessages.portuguese.requireUppercase, contains('maiúscula'));
      expect(PasswordMessages.portuguese.requireLowercase, contains('minúscula'));
      expect(PasswordMessages.portuguese.requireNumbers, contains('número'));
      expect(PasswordMessages.portuguese.requireSpecialChars, contains('caractere especial'));
      expect(PasswordMessages.portuguese.noSpaces, contains('espaços'));
      expect(PasswordMessages.portuguese.notCommon, contains('comum'));
      expect(PasswordMessages.portuguese.noRepeatedChars, contains('repetidos'));
      expect(PasswordMessages.portuguese.noSequentialChars, contains('sequenciais'));
      expect(PasswordMessages.portuguese.veryWeak, contains('Fraca'));
      expect(PasswordMessages.portuguese.weak, contains('Fraca'));
      expect(PasswordMessages.portuguese.fair, contains('Regular'));
      expect(PasswordMessages.portuguese.good, contains('Boa'));
      expect(PasswordMessages.portuguese.strong, contains('Forte'));
      expect(PasswordMessages.portuguese.veryStrong, contains('Forte'));
    });

    test('should provide Italian messages', () {
      expect(PasswordMessages.italian.minLength, contains('{min}'));
      expect(PasswordMessages.italian.maxLength, contains('{max}'));
      expect(PasswordMessages.italian.requireUppercase, contains('maiuscola'));
      expect(PasswordMessages.italian.requireLowercase, contains('minuscola'));
      expect(PasswordMessages.italian.requireNumbers, contains('numero'));
      expect(PasswordMessages.italian.requireSpecialChars, contains('carattere speciale'));
      expect(PasswordMessages.italian.noSpaces, contains('spazi'));
      expect(PasswordMessages.italian.notCommon, contains('comune'));
      expect(PasswordMessages.italian.noRepeatedChars, contains('ripetuti'));
      expect(PasswordMessages.italian.noSequentialChars, contains('sequenziali'));
      expect(PasswordMessages.italian.veryWeak, contains('Debole'));
      expect(PasswordMessages.italian.weak, contains('Debole'));
      expect(PasswordMessages.italian.fair, contains('Discreta'));
      expect(PasswordMessages.italian.good, contains('Buona'));
      expect(PasswordMessages.italian.strong, contains('Forte'));
      expect(PasswordMessages.italian.veryStrong, contains('Forte'));
    });

    test('should provide Persian messages', () {
      expect(PasswordMessages.persian.minLength, contains('{min}'));
      expect(PasswordMessages.persian.maxLength, contains('{max}'));
      expect(PasswordMessages.persian.requireUppercase, contains('بزرگ'));
      expect(PasswordMessages.persian.requireLowercase, contains('کوچک'));
      expect(PasswordMessages.persian.requireNumbers, contains('عدد'));
      expect(PasswordMessages.persian.requireSpecialChars, contains('خاص'));
      expect(PasswordMessages.persian.noSpaces, contains('فاصله'));
      expect(PasswordMessages.persian.notCommon, contains('رایج'));
      expect(PasswordMessages.persian.noRepeatedChars, contains('تکراری'));
      expect(PasswordMessages.persian.noSequentialChars, contains('متوالی'));
      expect(PasswordMessages.persian.veryWeak, contains('ضعیف'));
      expect(PasswordMessages.persian.weak, contains('ضعیف'));
      expect(PasswordMessages.persian.fair, contains('متوسط'));
      expect(PasswordMessages.persian.good, contains('خوب'));
      expect(PasswordMessages.persian.strong, contains('قوی'));
      expect(PasswordMessages.persian.veryStrong, contains('قوی'));
    });

    test('should handle getMessage with parameter substitution', () {
      final messages = PasswordMessages.english;
      
      // Test parameter substitution
      final minLengthMessage = messages.getMessage('minLength', params: {'min': '8'});
      expect(minLengthMessage, contains('8'));
      expect(minLengthMessage, contains('characters long'));
      
      final maxLengthMessage = messages.getMessage('maxLength', params: {'max': '128'});
      expect(maxLengthMessage, contains('128'));
      expect(maxLengthMessage, contains('characters long'));
    });

    test('should handle getMessage without parameters', () {
      final messages = PasswordMessages.english;
      
      final message = messages.getMessage('requireUppercase');
      expect(message, equals('Password must contain at least one uppercase letter'));
    });

    test('should handle getMessage with unknown key', () {
      final messages = PasswordMessages.english;
      
      final message = messages.getMessage('unknownKey');
      expect(message, equals('unknownKey'));
    });

    test('should handle getMessage with multiple parameters', () {
      final messages = PasswordMessages.english;
      
      final message = messages.getMessage('minLength', params: {'min': '12', 'max': '50'});
      expect(message, contains('12'));
      expect(message, isNot(contains('50'))); // Only min parameter is used
    });

    test('should handle getMessage with null parameters', () {
      final messages = PasswordMessages.english;
      
      final message = messages.getMessage('minLength', params: null);
      expect(message, contains('{min}'));
    });

    test('should handle getMessage with empty parameters', () {
      final messages = PasswordMessages.english;
      
      final message = messages.getMessage('minLength', params: {});
      expect(message, contains('{min}'));
    });

    test('should handle all message keys in _getMessageByKey', () {
      final messages = PasswordMessages.english;
      
      // Test all possible keys
      final keys = [
        'minLength', 'maxLength', 'requireUppercase', 'requireLowercase',
        'requireNumbers', 'requireSpecialChars', 'noSpaces', 'notCommon',
        'noRepeatedChars', 'noSequentialChars', 'veryWeak', 'weak',
        'fair', 'good', 'strong', 'veryStrong'
      ];
      
      for (final key in keys) {
        final message = messages.getMessage(key);
        expect(message, isNotEmpty);
        expect(message, isNot(equals(key))); // Should not return the key itself
      }
    });

    test('should handle strength level messages', () {
      final messages = PasswordMessages.english;
      
      expect(messages.getMessage('veryWeak'), equals('Very Weak'));
      expect(messages.getMessage('weak'), equals('Weak'));
      expect(messages.getMessage('fair'), equals('Fair'));
      expect(messages.getMessage('good'), equals('Good'));
      expect(messages.getMessage('strong'), equals('Strong'));
      expect(messages.getMessage('veryStrong'), equals('Very Strong'));
    });

    test('should handle validation rule messages', () {
      final messages = PasswordMessages.english;
      
      expect(messages.getMessage('minLength'), contains('at least'));
      expect(messages.getMessage('maxLength'), contains('no more than'));
      expect(messages.getMessage('requireUppercase'), contains('uppercase'));
      expect(messages.getMessage('requireLowercase'), contains('lowercase'));
      expect(messages.getMessage('requireNumbers'), contains('number'));
      expect(messages.getMessage('requireSpecialChars'), contains('special character'));
      expect(messages.getMessage('noSpaces'), contains('spaces'));
      expect(messages.getMessage('notCommon'), contains('common'));
      expect(messages.getMessage('noRepeatedChars'), contains('repeated'));
      expect(messages.getMessage('noSequentialChars'), contains('sequential'));
    });
  });
}
