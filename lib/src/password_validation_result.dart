/// Result of password validation containing detailed information.
class PasswordValidationResult {
  /// Whether the password is valid according to all rules.
  final bool isValid;
  
  /// List of validation errors.
  final List<String> errors;
  
  /// List of validation warnings.
  final List<String> warnings;
  
  /// Password strength score (0-100).
  final int strengthScore;
  
  /// Password strength level.
  final PasswordStrengthLevel strengthLevel;
  
  /// Detailed breakdown of validation checks.
  final Map<String, bool> checks;

  const PasswordValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    required this.strengthScore,
    required this.strengthLevel,
    required this.checks,
  });

  /// Creates a successful validation result.
  factory PasswordValidationResult.success({
    required int strengthScore,
    required PasswordStrengthLevel strengthLevel,
    required Map<String, bool> checks,
    List<String> warnings = const [],
  }) {
    return PasswordValidationResult(
      isValid: true,
      errors: [],
      warnings: warnings,
      strengthScore: strengthScore,
      strengthLevel: strengthLevel,
      checks: checks,
    );
  }

  /// Creates a failed validation result.
  factory PasswordValidationResult.failure({
    required List<String> errors,
    required Map<String, bool> checks,
    List<String> warnings = const [],
    int strengthScore = 0,
    PasswordStrengthLevel strengthLevel = PasswordStrengthLevel.veryWeak,
  }) {
    return PasswordValidationResult(
      isValid: false,
      errors: errors,
      warnings: warnings,
      strengthScore: strengthScore,
      strengthLevel: strengthLevel,
      checks: checks,
    );
  }

  @override
  String toString() {
    return 'PasswordValidationResult{'
        'isValid: $isValid, '
        'errors: $errors, '
        'warnings: $warnings, '
        'strengthScore: $strengthScore, '
        'strengthLevel: $strengthLevel, '
        'checks: $checks'
        '}';
  }
}

/// Password strength levels.
enum PasswordStrengthLevel {
  veryWeak,
  weak,
  fair,
  good,
  strong,
  veryStrong,
}

/// Extension to get human-readable strength level names.
extension PasswordStrengthLevelExtension on PasswordStrengthLevel {
  String get displayName {
    switch (this) {
      case PasswordStrengthLevel.veryWeak:
        return 'Very Weak';
      case PasswordStrengthLevel.weak:
        return 'Weak';
      case PasswordStrengthLevel.fair:
        return 'Fair';
      case PasswordStrengthLevel.good:
        return 'Good';
      case PasswordStrengthLevel.strong:
        return 'Strong';
      case PasswordStrengthLevel.veryStrong:
        return 'Very Strong';
    }
  }
}
