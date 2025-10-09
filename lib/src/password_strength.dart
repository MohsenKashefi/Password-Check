import 'password_validation_result.dart';

/// Utility class for calculating password strength.
class PasswordStrength {
  /// Calculates password strength score (0-100).
  static int calculateScore(String password) {
    if (password.isEmpty) return 0;

    int score = 0;

    // Length score (0-25 points)
    score += _calculateLengthScore(password);

    // Character variety score (0-25 points)
    score += _calculateVarietyScore(password);

    // Complexity score (0-25 points)
    score += _calculateComplexityScore(password);

    // Pattern score (0-25 points)
    score += _calculatePatternScore(password);

    return score.clamp(0, 100);
  }

  /// Determines password strength level based on score.
  static PasswordStrengthLevel getStrengthLevel(int score) {
    if (score >= 90) return PasswordStrengthLevel.veryStrong;
    if (score >= 75) return PasswordStrengthLevel.strong;
    if (score >= 60) return PasswordStrengthLevel.good;
    if (score >= 40) return PasswordStrengthLevel.fair;
    if (score >= 20) return PasswordStrengthLevel.weak;
    return PasswordStrengthLevel.veryWeak;
  }

  /// Calculates length-based score.
  static int _calculateLengthScore(String password) {
    final length = password.length;
    if (length < 4) return 0;
    if (length < 8) return 5;
    if (length < 12) return 10;
    if (length < 16) return 15;
    if (length < 20) return 20;
    return 25;
  }

  /// Calculates character variety score.
  static int _calculateVarietyScore(String password) {
    int score = 0;

    // Check for different character types
    bool hasLower = password.contains(RegExp(r'[a-z]'));
    bool hasUpper = password.contains(RegExp(r'[A-Z]'));
    bool hasDigit = password.contains(RegExp(r'[0-9]'));
    bool hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    // Base score for character types
    if (hasLower) score += 5;
    if (hasUpper) score += 5;
    if (hasDigit) score += 5;
    if (hasSpecial) score += 5;

    // Bonus for having all types
    if (hasLower && hasUpper && hasDigit && hasSpecial) {
      score += 5;
    }

    return score;
  }

  /// Calculates complexity score based on character distribution.
  static int _calculateComplexityScore(String password) {
    if (password.length < 4) return 0;

    int score = 0;

    // Check for character distribution
    final charCounts = <String, int>{};
    for (final char in password.split('')) {
      charCounts[char] = (charCounts[char] ?? 0) + 1;
    }

    // Penalty for repeated characters
    final maxRepeats = charCounts.values.reduce((a, b) => a > b ? a : b);
    if (maxRepeats > password.length * 0.5) {
      score -= 10;
    }

    // Bonus for good character distribution
    final uniqueChars = charCounts.length;
    if (uniqueChars > password.length * 0.7) {
      score += 15;
    } else if (uniqueChars > password.length * 0.5) {
      score += 10;
    }

    return score.clamp(0, 25);
  }

  /// Calculates pattern-based score.
  static int _calculatePatternScore(String password) {
    int score = 25;

    // Penalty for common patterns
    if (_hasSequentialChars(password)) {
      score -= 10;
    }

    if (_hasKeyboardPatterns(password)) {
      score -= 10;
    }

    if (_hasRepeatedPatterns(password)) {
      score -= 5;
    }

    return score.clamp(0, 25);
  }

  /// Checks for sequential characters (abc, 123, etc.).
  static bool _hasSequentialChars(String password) {
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

      if (char1 >= 48 &&
          char1 <= 57 &&
          char2 >= 48 &&
          char2 <= 57 &&
          char3 >= 48 &&
          char3 <= 57) {
        if (char2 == char1 + 1 && char3 == char2 + 1) {
          return true;
        }
      }
    }

    return false;
  }

  /// Checks for keyboard patterns (qwerty, asdf, etc.).
  static bool _hasKeyboardPatterns(String password) {
    final lower = password.toLowerCase();
    final keyboardPatterns = [
      'qwerty',
      'asdf',
      'zxcv',
      '1234',
      'abcd',
      'qwertyuiop',
      'asdfghjkl',
      'zxcvbnm',
      'abcdefghijklmnopqrstuvwxyz',
      '0123456789'
    ];

    for (final pattern in keyboardPatterns) {
      if (lower.contains(pattern)) {
        return true;
      }
    }

    return false;
  }

  /// Checks for repeated patterns.
  static bool _hasRepeatedPatterns(String password) {
    if (password.length < 4) return false;

    // Check for repeated 2-3 character patterns
    for (int patternLength = 2; patternLength <= 3; patternLength++) {
      for (int i = 0; i <= password.length - patternLength * 2; i++) {
        final pattern = password.substring(i, i + patternLength);
        final nextPattern =
            password.substring(i + patternLength, i + patternLength * 2);
        if (pattern == nextPattern) {
          return true;
        }
      }
    }

    return false;
  }
}
