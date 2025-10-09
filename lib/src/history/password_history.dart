
/// Represents a password entry in the history
class PasswordEntry {
  final String hash;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const PasswordEntry({
    required this.hash,
    required this.createdAt,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'hash': hash,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'metadata': metadata,
  };

  factory PasswordEntry.fromJson(Map<String, dynamic> json) => PasswordEntry(
    hash: json['hash'],
    createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
  );
}

/// Configuration for password history
class PasswordHistoryConfig {
  final int maxLength;
  final double similarityThreshold;
  final ComparisonMethod method;
  final bool enableSuggestions;
  final bool enableMetadata;

  const PasswordHistoryConfig({
    this.maxLength = 5,
    this.similarityThreshold = 0.8,
    this.method = ComparisonMethod.similarity,
    this.enableSuggestions = true,
    this.enableMetadata = true,
  });

  /// Simple configuration for basic usage
  static const PasswordHistoryConfig simple = PasswordHistoryConfig(
    maxLength: 5,
    similarityThreshold: 0.8,
    method: ComparisonMethod.similarity,
  );

  /// Enterprise configuration with stricter rules
  static const PasswordHistoryConfig enterprise = PasswordHistoryConfig(
    maxLength: 10,
    similarityThreshold: 0.7,
    method: ComparisonMethod.similarity,
    enableSuggestions: true,
    enableMetadata: true,
  );
}

/// Comparison methods for password similarity
enum ComparisonMethod {
  exactHash,
  similarity,
  fuzzyMatch,
}

/// Result of password history check
class PasswordHistoryResult {
  final bool isRejected;
  final String? reason;
  final double? similarityScore;
  final String? mostSimilarPassword;
  final List<String> suggestions;
  final DateTime? lastUsed;

  const PasswordHistoryResult({
    required this.isRejected,
    this.reason,
    this.similarityScore,
    this.mostSimilarPassword,
    this.suggestions = const [],
    this.lastUsed,
  });

  /// Create a result for accepted password
  factory PasswordHistoryResult.accepted() => const PasswordHistoryResult(
    isRejected: false,
  );

  /// Create a result for rejected password
  factory PasswordHistoryResult.rejected({
    required String reason,
    double? similarityScore,
    String? mostSimilarPassword,
    List<String> suggestions = const [],
    DateTime? lastUsed,
  }) => PasswordHistoryResult(
    isRejected: true,
    reason: reason,
    similarityScore: similarityScore,
    mostSimilarPassword: mostSimilarPassword,
    suggestions: suggestions,
    lastUsed: lastUsed,
  );
}

/// Main password history management class
class PasswordHistory {
  final PasswordHistoryConfig config;
  final List<PasswordEntry> _history = [];

  PasswordHistory(this.config);

  /// Get current history length
  int get length => _history.length;

  /// Get all password entries
  List<PasswordEntry> get history => List.unmodifiable(_history);

  /// Check if password should be rejected based on history
  PasswordHistoryResult checkPassword(String password) {
    if (_history.isEmpty) {
      return PasswordHistoryResult.accepted();
    }

    final passwordHash = _hashPassword(password);
    
    // Check for exact hash match
    for (final entry in _history) {
      if (entry.hash == passwordHash) {
        return PasswordHistoryResult.rejected(
          reason: 'Password has been used before',
          lastUsed: entry.createdAt,
        );
      }
    }

    // Check for similarity if enabled
    if (config.method != ComparisonMethod.exactHash) {
      final similarityResult = _checkSimilarity(password);
      if (similarityResult.isRejected) {
        return similarityResult;
      }
    }

    return PasswordHistoryResult.accepted();
  }

  /// Add password to history
  Future<void> addPassword(String password, {Map<String, dynamic>? metadata}) async {
    final entry = PasswordEntry(
      hash: _hashPassword(password),
      createdAt: DateTime.now(),
      metadata: metadata ?? {},
    );

    _history.add(entry);

    // Maintain max length
    if (_history.length > config.maxLength) {
      _history.removeAt(0);
    }
  }

  /// Clear all history
  void clearHistory() {
    _history.clear();
  }

  /// Get history as JSON for persistence
  Map<String, dynamic> toJson() => {
    'config': {
      'maxLength': config.maxLength,
      'similarityThreshold': config.similarityThreshold,
      'method': config.method.name,
      'enableSuggestions': config.enableSuggestions,
      'enableMetadata': config.enableMetadata,
    },
    'history': _history.map((entry) => entry.toJson()).toList(),
  };

  /// Load history from JSON
  factory PasswordHistory.fromJson(Map<String, dynamic> json) {
    final configJson = json['config'] as Map<String, dynamic>;
    final config = PasswordHistoryConfig(
      maxLength: configJson['maxLength'],
      similarityThreshold: configJson['similarityThreshold'],
      method: ComparisonMethod.values.firstWhere(
        (e) => e.name == configJson['method'],
        orElse: () => ComparisonMethod.similarity,
      ),
      enableSuggestions: configJson['enableSuggestions'],
      enableMetadata: configJson['enableMetadata'],
    );

    final history = PasswordHistory(config);
    final historyJson = json['history'] as List<dynamic>;
    
    for (final entryJson in historyJson) {
      history._history.add(PasswordEntry.fromJson(entryJson));
    }

    return history;
  }

  /// Hash password using simple hash function
  String _hashPassword(String password) {
    // Simple hash function using built-in Dart libraries
    int hash = 0;
    for (int i = 0; i < password.length; i++) {
      hash = ((hash << 5) - hash + password.codeUnitAt(i)) & 0xffffffff;
    }
    return hash.abs().toString();
  }

  /// Check password similarity against history
  PasswordHistoryResult _checkSimilarity(String password) {
    // We can't compare against hashed passwords for similarity
    // This is a limitation - we'd need to store original passwords
    // For now, we'll skip similarity check with hashed passwords
    // Always return accepted since we can't perform similarity checks on hashed passwords
    
    return PasswordHistoryResult.accepted();
  }

}
