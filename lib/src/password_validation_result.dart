import 'i18n/password_messages.dart';

/// Result of password validation containing detailed information.
class PasswordValidationResult {
  // Core validation
  final bool isValid;
  final String? errorMessage;        // First error only (localized)
  final String? warningMessage;    // First warning only (localized)
  
  // Strength analysis
  final String strengthDescription; // "Strong", "Weak" (localized)
  final int strengthScore;          // 0-100
  final String complexityRating;    // "High", "Medium", "Low" (localized)
  
  // Smart insights
  final String? improvementTip;     // "Add 2 more characters" (localized)
  final List<String> requirements;  // ["8+ characters", "Uppercase"] (localized)
  final List<String> vulnerabilities; // ["Contains common words"] (localized)
  
  // Internal fields for detailed analysis
  final List<String> _allErrors;
  final List<String> _allWarnings;
  final Map<String, bool> _checks;

  const PasswordValidationResult({
    required this.isValid,
    this.errorMessage,
    this.warningMessage,
    required this.strengthDescription,
    required this.strengthScore,
    required this.complexityRating,
    this.improvementTip,
    this.requirements = const [],
    this.vulnerabilities = const [],
    List<String> allErrors = const [],
    List<String> allWarnings = const [],
    Map<String, bool> checks = const {},
  }) : _allErrors = allErrors,
       _allWarnings = allWarnings,
       _checks = checks;

  /// Creates a successful validation result.
  factory PasswordValidationResult.success({
    required String strengthDescription,
    required int strengthScore,
    required String complexityRating,
    String? improvementTip,
    List<String> requirements = const [],
    List<String> vulnerabilities = const [],
    String? warningMessage,
    List<String> allWarnings = const [],
    Map<String, bool> checks = const {},
  }) {
    return PasswordValidationResult(
      isValid: true,
      strengthDescription: strengthDescription,
      strengthScore: strengthScore,
      complexityRating: complexityRating,
      improvementTip: improvementTip,
      requirements: requirements,
      vulnerabilities: vulnerabilities,
      warningMessage: warningMessage,
      allWarnings: allWarnings,
      checks: checks,
    );
  }

  /// Creates a failed validation result.
  factory PasswordValidationResult.failure({
    required String errorMessage,
    required String strengthDescription,
    required int strengthScore,
    required String complexityRating,
    String? improvementTip,
    List<String> requirements = const [],
    List<String> vulnerabilities = const [],
    String? warningMessage,
    List<String> allErrors = const [],
    List<String> allWarnings = const [],
    Map<String, bool> checks = const {},
  }) {
    return PasswordValidationResult(
      isValid: false,
      errorMessage: errorMessage,
      strengthDescription: strengthDescription,
      strengthScore: strengthScore,
      complexityRating: complexityRating,
      improvementTip: improvementTip,
      requirements: requirements,
      vulnerabilities: vulnerabilities,
      warningMessage: warningMessage,
      allErrors: allErrors,
      allWarnings: allWarnings,
      checks: checks,
    );
  }

  // User-friendly getters (NO hardcoded text)
  String get strengthDisplay => strengthDescription;
  String? get errorDisplay => errorMessage;
  String? get warningDisplay => warningMessage;
  String? get improvementDisplay => improvementTip;
  bool get isSecure => strengthScore >= 80 && vulnerabilities.isEmpty;

  // Additional getters for advanced usage
  List<String> get allErrors => List.unmodifiable(_allErrors);
  List<String> get allWarnings => List.unmodifiable(_allWarnings);
  Map<String, bool> get checks => Map.unmodifiable(_checks);

  @override
  String toString() {
    return 'PasswordValidationResult{'
        'isValid: $isValid, '
        'errorMessage: $errorMessage, '
        'warningMessage: $warningMessage, '
        'strengthDescription: $strengthDescription, '
        'strengthScore: $strengthScore, '
        'complexityRating: $complexityRating, '
        'improvementTip: $improvementTip, '
        'requirements: $requirements, '
        'vulnerabilities: $vulnerabilities}';
  }
}

/// Enum representing password strength levels.
enum PasswordStrengthLevel {
  veryWeak,
  weak,
  fair,
  good,
  strong,
  veryStrong,
}

/// Extension to provide localized display names for strength levels.
extension PasswordStrengthLevelExtension on PasswordStrengthLevel {
  /// Gets the localized display name for this strength level.
  String getLocalizedDisplayName(PasswordMessages messages) {
    switch (this) {
      case PasswordStrengthLevel.veryWeak:
        return messages.veryWeak;
      case PasswordStrengthLevel.weak:
        return messages.weak;
      case PasswordStrengthLevel.fair:
        return messages.fair;
      case PasswordStrengthLevel.good:
        return messages.good;
      case PasswordStrengthLevel.strong:
        return messages.strong;
      case PasswordStrengthLevel.veryStrong:
        return messages.veryStrong;
    }
  }
}