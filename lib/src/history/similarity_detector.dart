import 'dart:math';

/// Utility class for detecting password similarity
class SimilarityDetector {
  /// Calculate similarity between two passwords using Levenshtein distance
  static double calculateSimilarity(String password1, String password2) {
    if (password1 == password2) return 1.0;
    if (password1.isEmpty || password2.isEmpty) return 0.0;

    final distance = _levenshteinDistance(password1, password2);
    final maxLength = max(password1.length, password2.length);
    
    return 1.0 - (distance / maxLength);
  }

  /// Check if password is too similar to any password in history
  static bool isTooSimilar(
    String password, 
    List<String> history, 
    double threshold
  ) {
    for (final historyPassword in history) {
      final similarity = calculateSimilarity(password, historyPassword);
      if (similarity >= threshold) {
        return true;
      }
    }
    return false;
  }

  /// Find the most similar password in history
  static String? findMostSimilar(
    String password, 
    List<String> history
  ) {
    if (history.isEmpty) return null;

    String? mostSimilar;
    double maxSimilarity = 0.0;

    for (final historyPassword in history) {
      final similarity = calculateSimilarity(password, historyPassword);
      if (similarity > maxSimilarity) {
        maxSimilarity = similarity;
        mostSimilar = historyPassword;
      }
    }

    return mostSimilar;
  }

  /// Generate password suggestions based on history
  static List<String> generateSuggestions(
    String password, 
    List<String> history
  ) {
    final suggestions = <String>[];
    
    // Add year variations
    final currentYear = DateTime.now().year;
    suggestions.add('$password$currentYear');
    suggestions.add('$password${currentYear + 1}');
    
    // Add special character variations
    suggestions.add('$password@123');
    suggestions.add('$password#456');
    suggestions.add('$password!789');
    
    // Add prefix variations
    suggestions.add('Secure$password');
    suggestions.add('My$password');
    suggestions.add('New$password');
    
    // Add suffix variations
    suggestions.add('${password}Pass');
    suggestions.add('${password}Key');
    suggestions.add('${password}Code');
    
    // Filter out suggestions that are too similar to history
    return suggestions.where((suggestion) {
      return !isTooSimilar(suggestion, history, 0.7);
    }).take(5).toList();
  }

  /// Calculate Levenshtein distance between two strings
  static int _levenshteinDistance(String s1, String s2) {
    final matrix = List.generate(
      s1.length + 1,
      (i) => List.generate(s2.length + 1, (j) => 0),
    );

    // Initialize first row and column
    for (int i = 0; i <= s1.length; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= s2.length; j++) {
      matrix[0][j] = j;
    }

    // Fill the matrix
    for (int i = 1; i <= s1.length; i++) {
      for (int j = 1; j <= s2.length; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,      // deletion
          matrix[i][j - 1] + 1,      // insertion
          matrix[i - 1][j - 1] + cost, // substitution
        ].reduce(min);
      }
    }

    return matrix[s1.length][s2.length];
  }

  /// Calculate fuzzy similarity (more lenient than exact Levenshtein)
  static double calculateFuzzySimilarity(String password1, String password2) {
    if (password1 == password2) return 1.0;
    
    // Normalize strings (lowercase, remove spaces)
    final norm1 = password1.toLowerCase().replaceAll(' ', '');
    final norm2 = password2.toLowerCase().replaceAll(' ', '');
    
    if (norm1 == norm2) return 1.0;
    
    // Check if one contains the other
    if (norm1.contains(norm2) || norm2.contains(norm1)) {
      return 0.8; // High similarity for substring matches
    }
    
    // Use regular similarity for other cases
    return calculateSimilarity(norm1, norm2);
  }

  /// Check for common password patterns
  static bool hasCommonPattern(String password, List<String> history) {
    final normalizedPassword = password.toLowerCase();
    
    for (final historyPassword in history) {
      final normalizedHistory = historyPassword.toLowerCase();
      
      // Check for common patterns
      if (_hasCommonPrefix(normalizedPassword, normalizedHistory) ||
          _hasCommonSuffix(normalizedPassword, normalizedHistory) ||
          _hasCommonSubstring(normalizedPassword, normalizedHistory)) {
        return true;
      }
    }
    
    return false;
  }

  /// Check for common prefix (first 3+ characters)
  static bool _hasCommonPrefix(String s1, String s2) {
    final minLength = min(s1.length, s2.length);
    if (minLength < 3) return false;
    
    int commonChars = 0;
    for (int i = 0; i < minLength; i++) {
      if (s1[i] == s2[i]) {
        commonChars++;
      } else {
        break;
      }
    }
    
    return commonChars >= 3;
  }

  /// Check for common suffix (last 3+ characters)
  static bool _hasCommonSuffix(String s1, String s2) {
    final minLength = min(s1.length, s2.length);
    if (minLength < 3) return false;
    
    int commonChars = 0;
    for (int i = 0; i < minLength; i++) {
      if (s1[s1.length - 1 - i] == s2[s2.length - 1 - i]) {
        commonChars++;
      } else {
        break;
      }
    }
    
    return commonChars >= 3;
  }

  /// Check for common substring (3+ characters)
  static bool _hasCommonSubstring(String s1, String s2) {
    final shorter = s1.length < s2.length ? s1 : s2;
    final longer = s1.length >= s2.length ? s1 : s2;
    
    for (int i = 0; i <= shorter.length - 3; i++) {
      final substring = shorter.substring(i, i + 3);
      if (longer.contains(substring)) {
        return true;
      }
    }
    
    return false;
  }
}