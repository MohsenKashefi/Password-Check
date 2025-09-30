import 'password_validation_result.dart';
import 'password_strength.dart';
import 'validation_rules.dart';
import 'i18n/password_messages.dart';
import 'i18n/language_detector.dart';
import 'i18n/custom_messages.dart';

/// Main class for password validation and strength checking.
class PasswordChecker {
  final ValidationRules _rules;
  final List<String> _commonPasswords;
  final PasswordMessages _messages;
  final String _language;

  /// Creates a PasswordChecker with custom validation rules.
  PasswordChecker({
    ValidationRules? rules,
    String? language,
    CustomMessages? customMessages,
  }) : _rules = rules ?? const ValidationRules(),
       _commonPasswords = _getCommonPasswords(),
       _language = language ?? LanguageDetector.detectSystemLanguage(),
       _messages = _getMessages(language, customMessages);

  /// Creates a PasswordChecker with automatic language detection.
  PasswordChecker.auto({
    ValidationRules? rules,
    CustomMessages? customMessages,
  }) : _rules = rules ?? const ValidationRules(),
       _commonPasswords = _getCommonPasswords(),
       _language = LanguageDetector.detectSystemLanguage(),
       _messages = _getMessages(null, customMessages);

  /// Creates a PasswordChecker with specific language.
  PasswordChecker.localized({
    required String language,
    ValidationRules? rules,
    CustomMessages? customMessages,
  }) : _rules = rules ?? const ValidationRules(),
       _commonPasswords = _getCommonPasswords(),
       _language = language,
       _messages = _getMessages(language, customMessages);

  /// Creates a PasswordChecker with basic validation rules.
  PasswordChecker.basic({
    String? language,
    CustomMessages? customMessages,
  }) : _rules = const ValidationRules.basic(),
       _commonPasswords = _getCommonPasswords(),
       _language = language ?? LanguageDetector.detectSystemLanguage(),
       _messages = _getMessages(language, customMessages);

  /// Creates a PasswordChecker with strong validation rules.
  PasswordChecker.strong({
    String? language,
    CustomMessages? customMessages,
  }) : _rules = const ValidationRules.strong(),
       _commonPasswords = _getCommonPasswords(),
       _language = language ?? LanguageDetector.detectSystemLanguage(),
       _messages = _getMessages(language, customMessages);

  /// Creates a PasswordChecker with strict validation rules.
  PasswordChecker.strict({
    String? language,
    CustomMessages? customMessages,
  }) : _rules = const ValidationRules.strict(),
       _commonPasswords = _getCommonPasswords(),
       _language = language ?? LanguageDetector.detectSystemLanguage(),
       _messages = _getMessages(language, customMessages);

  /// Gets the current language code.
  String get language => _language;

  /// Gets the current messages.
  PasswordMessages get messages => _messages;

  /// Helper method to get messages based on language and custom messages.
  static PasswordMessages _getMessages(String? language, CustomMessages? customMessages) {
    final baseMessages = language != null 
        ? LanguageDetector.getMessagesForLanguage(language)
        : LanguageDetector.getSystemMessages();
    
    if (customMessages != null) {
      return customMessages.applyTo(baseMessages);
    }
    
    return baseMessages;
  }

  /// Validates a password according to the configured rules.
  PasswordValidationResult validate(String password) {
    final errors = <String>[];
    final warnings = <String>[];
    final checks = <String, bool>{};

    // Length validation
    if (password.length < _rules.minLength) {
      errors.add(_messages.getMessage('minLength', params: {'min': _rules.minLength}));
      checks['minLength'] = false;
    } else {
      checks['minLength'] = true;
    }

    if (password.length > _rules.maxLength) {
      errors.add(_messages.getMessage('maxLength', params: {'max': _rules.maxLength}));
      checks['maxLength'] = false;
    } else {
      checks['maxLength'] = true;
    }

    // Character type validation
    if (_rules.requireUppercase && !password.contains(RegExp(r'[A-Z]'))) {
      errors.add(_messages.requireUppercase);
      checks['uppercase'] = false;
    } else {
      checks['uppercase'] = true;
    }

    if (_rules.requireLowercase && !password.contains(RegExp(r'[a-z]'))) {
      errors.add(_messages.requireLowercase);
      checks['lowercase'] = false;
    } else {
      checks['lowercase'] = true;
    }

    if (_rules.requireNumbers && !password.contains(RegExp(r'[0-9]'))) {
      errors.add(_messages.requireNumbers);
      checks['numbers'] = false;
    } else {
      checks['numbers'] = true;
    }

    if (_rules.requireSpecialChars && !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      errors.add(_messages.requireSpecialChars);
      checks['specialChars'] = false;
    } else {
      checks['specialChars'] = true;
    }

    // Space validation
    if (!_rules.allowSpaces && password.contains(' ')) {
      errors.add(_messages.noSpaces);
      checks['noSpaces'] = false;
    } else {
      checks['noSpaces'] = true;
    }

    // Common password check
    if (_rules.checkCommonPasswords && _isCommonPassword(password)) {
      errors.add(_messages.notCommon);
      checks['notCommon'] = false;
    } else {
      checks['notCommon'] = true;
    }

    // Repeated characters check
    if (_rules.checkRepeatedChars && _hasTooManyRepeatedChars(password)) {
      errors.add(_messages.noRepeatedChars);
      checks['noRepeatedChars'] = false;
    } else {
      checks['noRepeatedChars'] = true;
    }

    // Sequential characters check
    if (_rules.checkSequentialChars && _hasSequentialChars(password)) {
      warnings.add(_messages.noSequentialChars);
      checks['noSequentialChars'] = false;
    } else {
      checks['noSequentialChars'] = true;
    }

    // Calculate strength
    final strengthScore = PasswordStrength.calculateScore(password);
    final strengthLevel = PasswordStrength.getStrengthLevel(strengthScore);

    // Add strength warnings
    if (strengthLevel == PasswordStrengthLevel.veryWeak) {
      warnings.add('Password is very weak');
    } else if (strengthLevel == PasswordStrengthLevel.weak) {
      warnings.add('Password is weak');
    }

    if (errors.isEmpty) {
      return PasswordValidationResult.success(
        strengthScore: strengthScore,
        strengthLevel: strengthLevel,
        checks: checks,
        warnings: warnings,
      );
    } else {
      return PasswordValidationResult.failure(
        errors: errors,
        checks: checks,
        warnings: warnings,
        strengthScore: strengthScore,
        strengthLevel: strengthLevel,
      );
    }
  }

  /// Checks if password is in common passwords list.
  bool _isCommonPassword(String password) {
    return _commonPasswords.contains(password.toLowerCase());
  }

  /// Checks if password has too many repeated characters.
  bool _hasTooManyRepeatedChars(String password) {
    if (password.isEmpty) return false;
    
    final charCounts = <String, int>{};
    for (final char in password.split('')) {
      charCounts[char] = (charCounts[char] ?? 0) + 1;
    }
    
    return charCounts.values.any((count) => count > _rules.maxRepeatedChars);
  }

  /// Checks if password has sequential characters.
  bool _hasSequentialChars(String password) {
    if (password.length < 3) return false;
    
    final lower = password.toLowerCase();
    
    // Check for sequential letters
    for (int i = 0; i < lower.length - 2; i++) {
      final char1 = lower.codeUnitAt(i);
      final char2 = lower.codeUnitAt(i + 1);
      final char3 = lower.codeUnitAt(i + 2);
      
      if (char2 == char1 + 1 && char3 == char2 + 1) {
        return true;
      }
    }
    
    // Check for sequential numbers
    for (int i = 0; i < password.length - 2; i++) {
      final char1 = password.codeUnitAt(i);
      final char2 = password.codeUnitAt(i + 1);
      final char3 = password.codeUnitAt(i + 2);
      
      if (char1 >= 48 && char1 <= 57 &&
          char2 >= 48 && char2 <= 57 &&
          char3 >= 48 && char3 <= 57) {
        if (char2 == char1 + 1 && char3 == char2 + 1) {
          return true;
        }
      }
    }
    
    return false;
  }

  /// Gets a list of common passwords.
  static List<String> _getCommonPasswords() {
    return [
      'password', '123456', '123456789', '12345678', '12345',
      '1234567', '1234567890', 'qwerty', 'abc123', 'password123',
      'admin', 'letmein', 'welcome', 'monkey', '1234567890',
      'password1', 'qwerty123', 'dragon', 'master', 'hello',
      'freedom', 'whatever', 'qazwsx', 'trustno1', '654321',
      'jordan23', 'harley', 'password123', 'hunter', 'ranger',
      'jordan', 'hannah', 'michelle', 'charlie', 'andrew',
      'matthew', 'joshua', 'jennifer', 'amanda', 'jessica',
      'daniel', 'christopher', 'anthony', 'mark', 'donald',
      'steven', 'paul', 'andrew', 'joshua', 'kenneth',
      'kevin', 'brian', 'george', 'timothy', 'ronald',
      'jason', 'edward', 'jeffrey', 'ryan', 'jacob',
      'gary', 'nicholas', 'eric', 'jonathan', 'stephen',
      'larry', 'justin', 'scott', 'brandon', 'benjamin',
      'samuel', 'frank', 'raymond', 'alexander', 'patrick',
      'jack', 'dennis', 'jerry', 'tyler', 'aaron',
      'jose', 'henry', 'douglas', 'adam', 'peter',
      'nathan', 'zachary', 'walter', 'kyle', 'harold',
      'carl', 'jeremy', 'arthur', 'gerald', 'lawrence',
      'sean', 'christian', 'ethan', 'austin', 'joe',
      'albert', 'jesse', 'willie', 'ralph', 'mason',
      'roy', 'eugene', 'wayne', 'louis', 'philip',
      'bobby', 'johnny', 'austin', 'joe', 'albert',
      'jesse', 'willie', 'ralph', 'mason', 'roy',
      'eugene', 'wayne', 'louis', 'philip', 'bobby',
      'johnny', 'austin', 'joe', 'albert', 'jesse',
      'willie', 'ralph', 'mason', 'roy', 'eugene',
      'wayne', 'louis', 'philip', 'bobby', 'johnny',
    ];
  }
}
