import 'dart:math';
import 'dart:typed_data';
import 'password_validation_result.dart';
import 'password_strength.dart';
import 'validation_rules.dart';
import 'password_checker.dart';
import 'i18n/password_messages.dart';
import 'i18n/language_detector.dart';
import 'i18n/custom_messages.dart';

/// Configuration for password generation rules.
class GenerationRules {
  /// Length of the generated password.
  final int length;
  
  /// Whether to include uppercase letters.
  final bool includeUppercase;
  
  /// Whether to include lowercase letters.
  final bool includeLowercase;
  
  /// Whether to include numbers.
  final bool includeNumbers;
  
  /// Whether to include special characters.
  final bool includeSpecialChars;
  
  /// Whether to include spaces.
  final bool includeSpaces;
  
  /// Whether to avoid similar characters (0, O, l, 1, etc.).
  final bool avoidSimilarChars;
  
  /// Whether to avoid ambiguous characters.
  final bool avoidAmbiguousChars;
  
  /// Custom character set to include.
  final String? customChars;
  
  /// Whether to ensure at least one character from each included set.
  final bool ensureCharacterVariety;

  const GenerationRules({
    this.length = 12,
    this.includeUppercase = true,
    this.includeLowercase = true,
    this.includeNumbers = true,
    this.includeSpecialChars = true,
    this.includeSpaces = false,
    this.avoidSimilarChars = true,
    this.avoidAmbiguousChars = true,
    this.customChars,
    this.ensureCharacterVariety = true,
  });

  /// Creates basic generation rules.
  const GenerationRules.basic()
      : length = 8,
        includeUppercase = false,
        includeLowercase = true,
        includeNumbers = true,
        includeSpecialChars = false,
        includeSpaces = true,
        avoidSimilarChars = false,
        avoidAmbiguousChars = false,
        customChars = null,
        ensureCharacterVariety = false;

  /// Creates strong generation rules.
  const GenerationRules.strong()
      : length = 16,
        includeUppercase = true,
        includeLowercase = true,
        includeNumbers = true,
        includeSpecialChars = true,
        includeSpaces = false,
        avoidSimilarChars = true,
        avoidAmbiguousChars = true,
        customChars = null,
        ensureCharacterVariety = true;

  /// Creates strict generation rules.
  const GenerationRules.strict()
      : length = 20,
        includeUppercase = true,
        includeLowercase = true,
        includeNumbers = true,
        includeSpecialChars = true,
        includeSpaces = false,
        avoidSimilarChars = true,
        avoidAmbiguousChars = true,
        customChars = null,
        ensureCharacterVariety = true;

  /// Creates custom generation rules.
  const GenerationRules.custom({
    required this.length,
    required this.includeUppercase,
    required this.includeLowercase,
    required this.includeNumbers,
    required this.includeSpecialChars,
    this.includeSpaces = false,
    this.avoidSimilarChars = true,
    this.avoidAmbiguousChars = true,
    this.customChars,
    this.ensureCharacterVariety = true,
  });

  /// Validates the generation rules.
  bool get isValid {
    if (length < 1 || length > 256) return false;
    if (!includeUppercase && !includeLowercase && !includeNumbers && 
        !includeSpecialChars && customChars == null) return false;
    return true;
  }

  /// Gets the character sets to use for generation.
  List<String> getCharacterSets() {
    final sets = <String>[];
    
    if (includeUppercase) {
      sets.add(_getUppercaseChars());
    }
    if (includeLowercase) {
      sets.add(_getLowercaseChars());
    }
    if (includeNumbers) {
      sets.add(_getNumberChars());
    }
    if (includeSpecialChars) {
      sets.add(_getSpecialChars());
    }
    if (includeSpaces) {
      sets.add(' ');
    }
    if (customChars != null && customChars!.isNotEmpty) {
      sets.add(customChars!);
    }
    
    return sets;
  }

  String _getUppercaseChars() {
    if (avoidSimilarChars) {
      return 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    }
    return 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  }

  String _getLowercaseChars() {
    if (avoidSimilarChars) {
      return 'abcdefghijkmnpqrstuvwxyz';
    }
    return 'abcdefghijklmnopqrstuvwxyz';
  }

  String _getNumberChars() {
    if (avoidSimilarChars) {
      return '23456789';
    }
    return '0123456789';
  }

  String _getSpecialChars() {
    if (avoidAmbiguousChars) {
      return r'!@#$%^&*()_+-=[]{}|;:,.<>?';
    }
    return r'!@#$%^&*()_+-=[]{}|;:,.<>?~`';
  }
}

/// Result of password generation containing the password and metadata.
class GenerationResult {
  /// The generated password.
  final String password;
  
  /// Generation rules used.
  final GenerationRules rules;
  
  /// Validation result of the generated password.
  final PasswordValidationResult validation;
  
  /// Timestamp when the password was generated.
  final DateTime timestamp;
  
  /// Whether the password meets the validation requirements.
  final bool isValid;

  const GenerationResult({
    required this.password,
    required this.rules,
    required this.validation,
    required this.timestamp,
    required this.isValid,
  });

  @override
  String toString() {
    return 'GenerationResult{'
        'password: ${password.length > 0 ? '${password.substring(0, 1)}***' : 'empty'}, '
        'isValid: $isValid, '
        'strength: ${validation.strengthLevel.displayName}, '
        'timestamp: $timestamp'
        '}';
  }
}

/// Main class for generating secure passwords.
class PasswordGenerator {
  final GenerationRules _rules;
  final PasswordMessages _messages;
  final String _language;
  final List<GenerationResult> _history;

  /// Creates a PasswordGenerator with custom generation rules.
  PasswordGenerator({
    GenerationRules? rules,
    String? language,
    CustomMessages? customMessages,
  }) : _rules = rules ?? const GenerationRules(),
       _language = language ?? LanguageDetector.detectSystemLanguage(),
       _messages = _getMessages(language, customMessages),
       _history = [];

  /// Creates a PasswordGenerator with automatic language detection.
  PasswordGenerator.auto({
    GenerationRules? rules,
    CustomMessages? customMessages,
  }) : _rules = rules ?? const GenerationRules(),
       _language = LanguageDetector.detectSystemLanguage(),
       _messages = _getMessages(null, customMessages),
       _history = [];

  /// Creates a PasswordGenerator with specific language.
  PasswordGenerator.localized({
    required String language,
    GenerationRules? rules,
    CustomMessages? customMessages,
  }) : _rules = rules ?? const GenerationRules(),
       _language = language,
       _messages = _getMessages(language, customMessages),
       _history = [];

  /// Creates a PasswordGenerator with basic generation rules.
  PasswordGenerator.basic({
    String? language,
    CustomMessages? customMessages,
  }) : _rules = const GenerationRules.basic(),
       _language = language ?? LanguageDetector.detectSystemLanguage(),
       _messages = _getMessages(language, customMessages),
       _history = [];

  /// Creates a PasswordGenerator with strong generation rules.
  PasswordGenerator.strong({
    String? language,
    CustomMessages? customMessages,
  }) : _rules = const GenerationRules.strong(),
       _language = language ?? LanguageDetector.detectSystemLanguage(),
       _messages = _getMessages(language, customMessages),
       _history = [];

  /// Creates a PasswordGenerator with strict generation rules.
  PasswordGenerator.strict({
    String? language,
    CustomMessages? customMessages,
  }) : _rules = const GenerationRules.strict(),
       _language = language ?? LanguageDetector.detectSystemLanguage(),
       _messages = _getMessages(language, customMessages),
       _history = [];

  /// Gets the current language code.
  String get language => _language;

  /// Gets the current messages.
  PasswordMessages get messages => _messages;

  /// Gets the generation history.
  List<GenerationResult> get history => List.unmodifiable(_history);

  /// Gets the current generation rules.
  GenerationRules get rules => _rules;

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

  /// Generates a secure password using the configured rules.
  GenerationResult generate() {
    if (!_rules.isValid) {
      throw ArgumentError('Invalid generation rules');
    }

    final password = _generatePassword();
    final validation = _validateGeneratedPassword(password);
    final result = GenerationResult(
      password: password,
      rules: _rules,
      validation: validation,
      timestamp: DateTime.now(),
      isValid: validation.isValid,
    );

    _history.add(result);
    return result;
  }

  /// Generates multiple passwords at once.
  List<GenerationResult> generateMultiple(int count) {
    if (count < 1 || count > 100) {
      throw ArgumentError('Count must be between 1 and 100');
    }

    final results = <GenerationResult>[];
    for (int i = 0; i < count; i++) {
      results.add(generate());
    }
    return results;
  }

  /// Generates a password that meets specific validation rules.
  GenerationResult generateValid({ValidationRules? validationRules}) {
    final rules = validationRules ?? const ValidationRules.strong();
    final maxAttempts = 100;
    
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final result = generate();
      if (result.validation.isValid) {
        return result;
      }
    }
    
    // If we can't generate a valid password, return the last attempt
    return _history.last;
  }

  /// Clears the generation history.
  void clearHistory() {
    _history.clear();
  }

  /// Gets the most recent generation result.
  GenerationResult? get lastResult => _history.isNotEmpty ? _history.last : null;

  /// Gets the count of generated passwords.
  int get historyCount => _history.length;

  /// Generates the actual password string.
  String _generatePassword() {
    final charSets = _rules.getCharacterSets();
    if (charSets.isEmpty) {
      throw StateError('No character sets available for generation');
    }

    final allChars = charSets.join();
    final password = StringBuffer();
    
    // Ensure character variety if requested
    if (_rules.ensureCharacterVariety) {
      _ensureCharacterVariety(password, charSets);
    }
    
    // Fill remaining length with random characters
    final remainingLength = _rules.length - password.length;
    for (int i = 0; i < remainingLength; i++) {
      password.write(_getRandomChar(allChars));
    }
    
    // Shuffle the password to randomize character positions
    return _shuffleString(password.toString());
  }

  /// Ensures at least one character from each included set.
  void _ensureCharacterVariety(StringBuffer password, List<String> charSets) {
    for (final charSet in charSets) {
      if (charSet.isNotEmpty) {
        password.write(_getRandomChar(charSet));
      }
    }
  }

  /// Gets a random character from the given character set.
  String _getRandomChar(String charSet) {
    final random = Random.secure();
    final index = random.nextInt(charSet.length);
    return charSet[index];
  }

  /// Shuffles the characters in a string.
  String _shuffleString(String input) {
    final chars = input.split('');
    final random = Random.secure();
    
    for (int i = chars.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = chars[i];
      chars[i] = chars[j];
      chars[j] = temp;
    }
    
    return chars.join();
  }

  /// Validates the generated password.
  PasswordValidationResult _validateGeneratedPassword(String password) {
    // Create a temporary checker to validate the generated password
    final tempChecker = PasswordChecker(
      rules: const ValidationRules.strong(),
      language: _language,
    );
    
    return tempChecker.validate(password);
  }
}

/// Extension to add password generation capabilities to PasswordChecker.
extension PasswordCheckerGeneration on PasswordChecker {
  /// Generates a password using the checker's validation rules.
  GenerationResult generatePassword({
    int length = 16,
    bool includeUppercase = true,
    bool includeLowercase = true,
    bool includeNumbers = true,
    bool includeSpecialChars = true,
    bool includeSpaces = false,
    bool avoidSimilarChars = true,
    bool avoidAmbiguousChars = true,
    String? customChars,
    bool ensureCharacterVariety = true,
  }) {
    final rules = GenerationRules(
      length: length,
      includeUppercase: includeUppercase,
      includeLowercase: includeLowercase,
      includeNumbers: includeNumbers,
      includeSpecialChars: includeSpecialChars,
      includeSpaces: includeSpaces,
      avoidSimilarChars: avoidSimilarChars,
      avoidAmbiguousChars: avoidAmbiguousChars,
      customChars: customChars,
      ensureCharacterVariety: ensureCharacterVariety,
    );

    final generator = PasswordGenerator(
      rules: rules,
      language: language,
    );

    return generator.generate();
  }
}
