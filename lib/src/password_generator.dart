import 'dart:math';
import 'password_validation_result.dart';
import 'password_strength.dart';
import 'validation_rules.dart';
import 'password_checker.dart';

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

  /// Creates basic generation rules (8 characters, mixed case, numbers).
  const GenerationRules.basic()
      : length = 8,
        includeUppercase = true,
        includeLowercase = true,
        includeNumbers = true,
        includeSpecialChars = false,
        includeSpaces = false,
        avoidSimilarChars = false,
        avoidAmbiguousChars = false,
        customChars = null,
        ensureCharacterVariety = false;

  /// Creates strong generation rules (12 characters, all character types).
  const GenerationRules.strong()
      : length = 12,
        includeUppercase = true,
        includeLowercase = true,
        includeNumbers = true,
        includeSpecialChars = true,
        includeSpaces = false,
        avoidSimilarChars = true,
        avoidAmbiguousChars = true,
        customChars = null,
        ensureCharacterVariety = true;

  /// Creates strict generation rules (16 characters, maximum security).
  const GenerationRules.strict()
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

  @override
  String toString() {
    return 'GenerationRules{'
        'length: $length, '
        'includeUppercase: $includeUppercase, '
        'includeLowercase: $includeLowercase, '
        'includeNumbers: $includeNumbers, '
        'includeSpecialChars: $includeSpecialChars, '
        'includeSpaces: $includeSpaces, '
        'avoidSimilarChars: $avoidSimilarChars, '
        'avoidAmbiguousChars: $avoidAmbiguousChars, '
        'customChars: $customChars, '
        'ensureCharacterVariety: $ensureCharacterVariety}';
  }
}

/// Result of password generation containing the generated password and metadata.
class GenerationResult {
  /// The generated password.
  final String password;

  /// The strength score of the generated password (0-100).
  final int strengthScore;

  /// The strength level of the generated password.
  final PasswordStrengthLevel strengthLevel;

  /// The generation rules used.
  final GenerationRules rules;

  /// Timestamp when the password was generated.
  final DateTime timestamp;

  /// Whether the password meets the specified validation rules.
  final bool isValid;

  /// Validation result if validation was performed.
  final PasswordValidationResult? validationResult;

  const GenerationResult({
    required this.password,
    required this.strengthScore,
    required this.strengthLevel,
    required this.rules,
    required this.timestamp,
    this.isValid = true,
    this.validationResult,
  });

  @override
  String toString() {
    return 'GenerationResult{'
        'password: ${password.length > 10 ? '${password.substring(0, 10)}...' : password}, '
        'strengthScore: $strengthScore, '
        'strengthLevel: $strengthLevel, '
        'isValid: $isValid, '
        'timestamp: $timestamp}';
  }
}

/// Main class for password generation.
class PasswordGenerator {
  final GenerationRules _rules;
  final List<GenerationResult> _history;

  /// Creates a PasswordGenerator with custom generation rules.
  PasswordGenerator({
    GenerationRules? rules,
  })  : _rules = rules ?? const GenerationRules(),
        _history = [];

  /// Creates a PasswordGenerator with basic generation rules.
  PasswordGenerator.basic()
      : _rules = const GenerationRules.basic(),
        _history = [];

  /// Creates a PasswordGenerator with strong generation rules.
  PasswordGenerator.strong()
      : _rules = const GenerationRules.strong(),
        _history = [];

  /// Creates a PasswordGenerator with strict generation rules.
  PasswordGenerator.strict()
      : _rules = const GenerationRules.strict(),
        _history = [];

  /// Gets the current generation rules.
  GenerationRules get rules => _rules;

  /// Gets the generation history.
  List<GenerationResult> get history => List.unmodifiable(_history);

  /// Generates a new password according to the configured rules.
  GenerationResult generate() {
    final password = _generatePassword();
    final strengthScore = PasswordStrength.calculateScore(password);
    final strengthLevel = PasswordStrength.getStrengthLevel(strengthScore);

    final result = GenerationResult(
      password: password,
      strengthScore: strengthScore,
      strengthLevel: strengthLevel,
      rules: _rules,
      timestamp: DateTime.now(),
    );

    _history.add(result);
    return result;
  }

  /// Generates a password and validates it against the given rules.
  GenerationResult generateAndValidate(ValidationRules validationRules) {
    final result = generate();
    final checker = PasswordChecker(rules: validationRules);
    final validationResult = checker.validate(result.password);

    final validatedResult = GenerationResult(
      password: result.password,
      strengthScore: result.strengthScore,
      strengthLevel: result.strengthLevel,
      rules: result.rules,
      timestamp: result.timestamp,
      isValid: validationResult.isValid,
      validationResult: validationResult,
    );

    // Replace the last entry in history
    if (_history.isNotEmpty) {
      _history[_history.length - 1] = validatedResult;
    }

    return validatedResult;
  }

  /// Generates multiple passwords at once.
  List<GenerationResult> generateMultiple(int count) {
    final results = <GenerationResult>[];
    for (int i = 0; i < count; i++) {
      results.add(generate());
    }
    return results;
  }

  /// Clears the generation history.
  void clearHistory() {
    _history.clear();
  }

  /// Gets the last generated password.
  String? get lastPassword =>
      _history.isNotEmpty ? _history.last.password : null;

  /// Gets the average strength score of all generated passwords.
  double get averageStrengthScore {
    if (_history.isEmpty) return 0.0;
    final total = _history.fold(0, (sum, result) => sum + result.strengthScore);
    return total / _history.length;
  }

  /// Gets the strongest password from history.
  GenerationResult? get strongestPassword {
    if (_history.isEmpty) return null;
    return _history.reduce((a, b) => a.strengthScore > b.strengthScore ? a : b);
  }

  /// Gets the weakest password from history.
  GenerationResult? get weakestPassword {
    if (_history.isEmpty) return null;
    return _history.reduce((a, b) => a.strengthScore < b.strengthScore ? a : b);
  }

  /// Generates a password using the specified character sets.
  String _generatePassword() {
    final charSets = <String>[];
    final requiredChars = <String>[];

    // Build character sets based on rules
    if (_rules.includeUppercase) {
      final uppercase = _rules.avoidSimilarChars
          ? 'ABCDEFGHJKLMNPQRSTUVWXYZ' // Excludes I, O
          : 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      charSets.add(uppercase);
      if (_rules.ensureCharacterVariety) {
        requiredChars.add(uppercase[Random().nextInt(uppercase.length)]);
      }
    }

    if (_rules.includeLowercase) {
      final lowercase = _rules.avoidSimilarChars
          ? 'abcdefghijkmnpqrstuvwxyz' // Excludes l, o
          : 'abcdefghijklmnopqrstuvwxyz';
      charSets.add(lowercase);
      if (_rules.ensureCharacterVariety) {
        requiredChars.add(lowercase[Random().nextInt(lowercase.length)]);
      }
    }

    if (_rules.includeNumbers) {
      final numbers = _rules.avoidSimilarChars
          ? '23456789' // Excludes 0, 1
          : '0123456789';
      charSets.add(numbers);
      if (_rules.ensureCharacterVariety) {
        requiredChars.add(numbers[Random().nextInt(numbers.length)]);
      }
    }

    if (_rules.includeSpecialChars) {
      final specialChars = _rules.avoidAmbiguousChars
          ? '!@#\$%^&*()_+-=[]{}|;:,.<>?' // Excludes ambiguous chars
          : '!@#\$%^&*()_+-=[]{}|;:,.<>?/\\"\'`~';
      charSets.add(specialChars);
      if (_rules.ensureCharacterVariety) {
        requiredChars.add(specialChars[Random().nextInt(specialChars.length)]);
      }
    }

    if (_rules.includeSpaces) {
      charSets.add(' ');
      if (_rules.ensureCharacterVariety) {
        requiredChars.add(' ');
      }
    }

    if (_rules.customChars != null && _rules.customChars!.isNotEmpty) {
      charSets.add(_rules.customChars!);
    }

    if (charSets.isEmpty) {
      throw ArgumentError('At least one character set must be included');
    }

    // Combine all character sets
    final allChars = charSets.join();

    // Generate password
    final password = StringBuffer();
    final random = Random.secure();

    // Add required characters first
    for (final char in requiredChars) {
      password.write(char);
    }

    // Fill remaining length
    final remainingLength = _rules.length - requiredChars.length;
    for (int i = 0; i < remainingLength; i++) {
      password.write(allChars[random.nextInt(allChars.length)]);
    }

    // Shuffle the password to randomize required character positions
    final passwordChars = password.toString().split('');
    passwordChars.shuffle(random);

    return passwordChars.join();
  }
}
