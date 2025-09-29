/// Configuration class for password validation rules.
class ValidationRules {
  /// Minimum password length.
  final int minLength;
  
  /// Maximum password length.
  final int maxLength;
  
  /// Whether to require uppercase letters.
  final bool requireUppercase;
  
  /// Whether to require lowercase letters.
  final bool requireLowercase;
  
  /// Whether to require numbers.
  final bool requireNumbers;
  
  /// Whether to require special characters.
  final bool requireSpecialChars;
  
  /// Whether to allow spaces.
  final bool allowSpaces;
  
  /// Whether to check against common passwords.
  final bool checkCommonPasswords;
  
  /// Whether to check for repeated characters.
  final bool checkRepeatedChars;
  
  /// Maximum number of repeated characters allowed.
  final int maxRepeatedChars;
  
  /// Whether to check for sequential characters.
  final bool checkSequentialChars;
  
  /// Maximum length of sequential characters allowed.
  final int maxSequentialLength;

  const ValidationRules({
    this.minLength = 8,
    this.maxLength = 128,
    this.requireUppercase = true,
    this.requireLowercase = true,
    this.requireNumbers = true,
    this.requireSpecialChars = true,
    this.allowSpaces = false,
    this.checkCommonPasswords = true,
    this.checkRepeatedChars = true,
    this.maxRepeatedChars = 3,
    this.checkSequentialChars = true,
    this.maxSequentialLength = 3,
  });

  /// Creates a basic set of validation rules.
  const ValidationRules.basic()
      : minLength = 6,
        maxLength = 128,
        requireUppercase = false,
        requireLowercase = true,
        requireNumbers = false,
        requireSpecialChars = false,
        allowSpaces = true,
        checkCommonPasswords = true,
        checkRepeatedChars = false,
        maxRepeatedChars = 0,
        checkSequentialChars = false,
        maxSequentialLength = 0;

  /// Creates a strong set of validation rules.
  const ValidationRules.strong()
      : minLength = 12,
        maxLength = 128,
        requireUppercase = true,
        requireLowercase = true,
        requireNumbers = true,
        requireSpecialChars = true,
        allowSpaces = false,
        checkCommonPasswords = true,
        checkRepeatedChars = true,
        maxRepeatedChars = 2,
        checkSequentialChars = true,
        maxSequentialLength = 2;

  /// Creates a very strict set of validation rules.
  const ValidationRules.strict()
      : minLength = 16,
        maxLength = 128,
        requireUppercase = true,
        requireLowercase = true,
        requireNumbers = true,
        requireSpecialChars = true,
        allowSpaces = false,
        checkCommonPasswords = true,
        checkRepeatedChars = true,
        maxRepeatedChars = 1,
        checkSequentialChars = true,
        maxSequentialLength = 1;
}
