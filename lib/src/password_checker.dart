import 'password_validation_result.dart';
import 'password_strength.dart';
import 'validation_rules.dart';
import 'i18n/password_messages.dart';
import 'i18n/language_detector.dart';
import 'i18n/custom_messages.dart';
import 'history/password_history.dart';

/// Main class for password validation and strength checking.
class PasswordChecker {
  final ValidationRules _rules;
  final List<String> _commonPasswords;
  final PasswordMessages _messages;
  PasswordHistory? _history;

  /// Creates a PasswordChecker with custom validation rules.
  PasswordChecker({
    ValidationRules? rules,
    String? language,
    CustomMessages? customMessages,
  })  : _rules = rules ?? const ValidationRules(),
        _commonPasswords = _getCommonPasswords(),
        _messages = _getMessages(language, customMessages);

  /// Creates a PasswordChecker with basic validation rules.
  PasswordChecker.basic({
    String? language,
    CustomMessages? customMessages,
  })  : _rules = const ValidationRules.basic(),
        _commonPasswords = _getCommonPasswords(),
        _messages = _getMessages(language, customMessages);

  /// Creates a PasswordChecker with strong validation rules.
  PasswordChecker.strong({
    String? language,
    CustomMessages? customMessages,
  })  : _rules = const ValidationRules.strong(),
        _commonPasswords = _getCommonPasswords(),
        _messages = _getMessages(language, customMessages);

  /// Creates a PasswordChecker with strict validation rules.
  PasswordChecker.strict({
    String? language,
    CustomMessages? customMessages,
  })  : _rules = const ValidationRules.strict(),
        _commonPasswords = _getCommonPasswords(),
        _messages = _getMessages(language, customMessages);

  /// Gets the current messages.
  PasswordMessages get messages => _messages;

  /// Gets the current password history.
  PasswordHistory? get history => _history;

  /// Enables password history tracking with the given configuration.
  PasswordChecker withHistory(PasswordHistoryConfig config) {
    _history = PasswordHistory(config);
    return this;
  }

  /// Enables password history tracking with simple configuration.
  PasswordChecker withSimpleHistory() {
    return withHistory(PasswordHistoryConfig.simple);
  }

  /// Enables password history tracking with enterprise configuration.
  PasswordChecker withEnterpriseHistory() {
    return withHistory(PasswordHistoryConfig.enterprise);
  }

  /// Validates a password according to the configured rules.
  PasswordValidationResult validate(String password) {
    final errors = <String>[];
    final warnings = <String>[];
    final checks = <String, bool>{};
    final requirements = <String>[];
    final vulnerabilities = <String>[];

    // Check password history if enabled
    if (_history != null) {
      final historyResult = _history!.checkPassword(password);
      if (historyResult.isRejected) {
        errors
            .add(historyResult.reason ?? 'Password rejected by history check');
        checks['historyCheck'] = false;
      } else {
        checks['historyCheck'] = true;
      }
    }

    // Length validation
    if (password.length < _rules.minLength) {
      errors.add(
          _messages.getMessage('minLength', params: {'min': _rules.minLength}));
      checks['minLength'] = false;
    } else {
      checks['minLength'] = true;
    }

    if (password.length > _rules.maxLength) {
      errors.add(
          _messages.getMessage('maxLength', params: {'max': _rules.maxLength}));
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

    if (_rules.requireSpecialChars &&
        !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
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

    // Build requirements list
    _buildRequirementsList(requirements, checks);

    // Analyze vulnerabilities
    _analyzeVulnerabilities(password, vulnerabilities);

    // Calculate strength
    final strengthScore = PasswordStrength.calculateScore(password);
    final strengthLevel = PasswordStrength.getStrengthLevel(strengthScore);
    final strengthDescription = _getStrengthDescription(strengthLevel);
    final complexityRating = _getComplexityRating(strengthScore);
    final improvementTip = _getImprovementTip(password, checks, strengthScore);

    if (errors.isNotEmpty) {
      return PasswordValidationResult.failure(
        errorMessage: errors.first,
        strengthDescription: strengthDescription,
        strengthScore: strengthScore,
        complexityRating: complexityRating,
        improvementTip: improvementTip,
        requirements: requirements,
        vulnerabilities: vulnerabilities,
        warningMessage: warnings.isNotEmpty ? warnings.first : null,
        allErrors: errors,
        allWarnings: warnings,
        checks: checks,
      );
    } else {
      return PasswordValidationResult.success(
        strengthDescription: strengthDescription,
        strengthScore: strengthScore,
        complexityRating: complexityRating,
        improvementTip: improvementTip,
        requirements: requirements,
        vulnerabilities: vulnerabilities,
        warningMessage: warnings.isNotEmpty ? warnings.first : null,
        allWarnings: warnings,
        checks: checks,
      );
    }
  }

  /// Checks if a password is in the common passwords list.
  bool _isCommonPassword(String password) {
    return _commonPasswords.contains(password.toLowerCase());
  }

  /// Checks if password has too many repeated characters.
  bool _hasTooManyRepeatedChars(String password) {
    if (_rules.maxRepeatedChars <= 0) return false;

    final charCount = <String, int>{};
    for (final char in password.split('')) {
      charCount[char] = (charCount[char] ?? 0) + 1;
      if (charCount[char]! > _rules.maxRepeatedChars) {
        return true;
      }
    }
    return false;
  }

  /// Checks if password has sequential characters.
  bool _hasSequentialChars(String password) {
    if (_rules.maxSequentialLength <= 0) return false;

    final lowerPassword = password.toLowerCase();

    // Check for sequential letters (abc, bcd, etc.)
    for (int i = 0;
        i <= lowerPassword.length - _rules.maxSequentialLength;
        i++) {
      final sequence =
          lowerPassword.substring(i, i + _rules.maxSequentialLength);
      if (_isSequential(sequence)) {
        return true;
      }
    }

    return false;
  }

  /// Checks if a string is sequential (abc, 123, etc.).
  bool _isSequential(String str) {
    if (str.length < 2) return false;

    final chars = str.split('');
    for (int i = 1; i < chars.length; i++) {
      final prev = chars[i - 1].codeUnitAt(0);
      final curr = chars[i].codeUnitAt(0);

      if (curr != prev + 1) {
        return false;
      }
    }

    return true;
  }

  /// Gets a list of common passwords.
  static List<String> _getCommonPasswords() {
    return [
      'password',
      '123456',
      '123456789',
      'qwerty',
      'abc123',
      'password123',
      'admin',
      'letmein',
      'welcome',
      'monkey',
      '1234567890',
      'password1',
      'qwerty123',
      'dragon',
      'master',
      'hello',
      'freedom',
      'whatever',
      'qazwsx',
      'trustno1',
      'jordan',
      'jennifer',
      'zxcvbnm',
      'asdfgh',
      'hunter',
      'buster',
      'soccer',
      'harley',
      'batman',
      'andrew',
      'tigger',
      'sunshine',
      'iloveyou',
      '2000',
      'charlie',
      'robert',
      'thomas',
      'hockey',
      'ranger',
      'daniel',
      'hannah',
      'maggie',
      'jessica',
      'charlie',
      'michelle',
      'jordan',
      'andrew',
      'david',
      'joshua',
      'michael',
      'jennifer',
      'jessica',
      'sarah',
      'hannah',
      'maggie',
      'michelle',
      'jordan',
      'andrew',
      'david',
      'joshua',
    ];
  }

  /// Builds the requirements list based on validation checks.
  void _buildRequirementsList(
      List<String> requirements, Map<String, bool> checks) {
    if (checks['minLength'] == true) {
      requirements.add(
          _messages.getMessage('minLength', params: {'min': _rules.minLength}));
    }
    if (checks['uppercase'] == true) {
      requirements.add(_messages.requireUppercase);
    }
    if (checks['lowercase'] == true) {
      requirements.add(_messages.requireLowercase);
    }
    if (checks['numbers'] == true) {
      requirements.add(_messages.requireNumbers);
    }
    if (checks['specialChars'] == true) {
      requirements.add(_messages.requireSpecialChars);
    }
    if (checks['notCommon'] == true) {
      requirements.add(_messages.notCommon);
    }
    if (checks['historyCheck'] == true && _history != null) {
      requirements.add('Not previously used');
    }
  }

  /// Analyzes password vulnerabilities.
  void _analyzeVulnerabilities(String password, List<String> vulnerabilities) {
    if (_isCommonPassword(password)) {
      vulnerabilities.add(_messages.notCommon);
    }
    if (_hasTooManyRepeatedChars(password)) {
      vulnerabilities.add(_messages.noRepeatedChars);
    }
    if (_hasSequentialChars(password)) {
      vulnerabilities.add(_messages.noSequentialChars);
    }
    if (password.length < 8) {
      vulnerabilities
          .add(_messages.getMessage('minLength', params: {'min': 8}));
    }
  }

  /// Gets localized strength description.
  String _getStrengthDescription(PasswordStrengthLevel level) {
    switch (level) {
      case PasswordStrengthLevel.veryWeak:
        return _messages.veryWeak;
      case PasswordStrengthLevel.weak:
        return _messages.weak;
      case PasswordStrengthLevel.fair:
        return _messages.fair;
      case PasswordStrengthLevel.good:
        return _messages.good;
      case PasswordStrengthLevel.strong:
        return _messages.strong;
      case PasswordStrengthLevel.veryStrong:
        return _messages.veryStrong;
    }
  }

  /// Gets complexity rating based on strength score.
  String _getComplexityRating(int strengthScore) {
    if (strengthScore >= 80) return _messages.strong;
    if (strengthScore >= 60) return _messages.good;
    if (strengthScore >= 40) return _messages.fair;
    if (strengthScore >= 20) return _messages.weak;
    return _messages.veryWeak;
  }

  /// Generates improvement tip based on password analysis.
  String? _getImprovementTip(
      String password, Map<String, bool> checks, int strengthScore) {
    if (strengthScore >= 80) return null; // No improvement needed

    if (checks['minLength'] == false) {
      return _messages
          .getMessage('minLength', params: {'min': _rules.minLength});
    }
    if (checks['uppercase'] == false) {
      return _messages.requireUppercase;
    }
    if (checks['lowercase'] == false) {
      return _messages.requireLowercase;
    }
    if (checks['numbers'] == false) {
      return _messages.requireNumbers;
    }
    if (checks['specialChars'] == false) {
      return _messages.requireSpecialChars;
    }
    if (checks['notCommon'] == false) {
      return _messages.notCommon;
    }

    return null;
  }

  /// Gets messages for the specified language with optional custom overrides.
  static PasswordMessages _getMessages(
      String? language, CustomMessages? customMessages) {
    final detectedLanguage =
        language ?? LanguageDetector.detectSystemLanguage();
    final baseMessages =
        LanguageDetector.getMessagesForLanguage(detectedLanguage);

    if (customMessages != null) {
      return customMessages.applyTo(baseMessages);
    }

    return baseMessages;
  }

  /// Adds a password to the history if history tracking is enabled.
  Future<void> addToHistory(String password,
      {Map<String, dynamic>? metadata}) async {
    if (_history != null) {
      await _history!.addPassword(password, metadata: metadata);
    }
  }

  /// Clears the password history if history tracking is enabled.
  void clearHistory() {
    if (_history != null) {
      _history!.clearHistory();
    }
  }

  /// Validates a password and adds it to history if validation passes.
  Future<PasswordValidationResult> validateAndAddToHistory(
    String password, {
    Map<String, dynamic>? metadata,
  }) async {
    final result = validate(password);

    // Only add to history if validation passes
    if (result.isValid && _history != null) {
      await addToHistory(password, metadata: metadata);
    }

    return result;
  }
}
