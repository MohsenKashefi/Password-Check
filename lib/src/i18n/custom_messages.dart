import 'password_messages.dart';

/// Custom message overrides for password validation.
class CustomMessages {
  final Map<String, String> _customMessages;

  const CustomMessages(this._customMessages);

  /// Creates custom messages from a map.
  factory CustomMessages.fromMap(Map<String, String> messages) {
    return CustomMessages(messages);
  }

  /// Creates custom messages from JSON.
  factory CustomMessages.fromJson(Map<String, dynamic> json) {
    final messages = <String, String>{};
    json.forEach((key, value) {
      if (value is String) {
        messages[key] = value;
      }
    });
    return CustomMessages(messages);
  }

  /// Gets a custom message for the given key.
  String? getMessage(String key) {
    return _customMessages[key];
  }

  /// Checks if a custom message exists for the given key.
  bool hasMessage(String key) {
    return _customMessages.containsKey(key);
  }

  /// Gets all custom message keys.
  List<String> get keys => _customMessages.keys.toList();

  /// Gets all custom messages.
  Map<String, String> get messages => Map.unmodifiable(_customMessages);

  /// Merges with another CustomMessages instance.
  CustomMessages merge(CustomMessages other) {
    final merged = Map<String, String>.from(_customMessages);
    merged.addAll(other._customMessages);
    return CustomMessages(merged);
  }

  /// Creates a copy with additional messages.
  CustomMessages copyWith(Map<String, String> additionalMessages) {
    final merged = Map<String, String>.from(_customMessages);
    merged.addAll(additionalMessages);
    return CustomMessages(merged);
  }

  /// Applies custom messages to PasswordMessages.
  PasswordMessages applyTo(PasswordMessages baseMessages) {
    return PasswordMessages(
      minLength: _customMessages['minLength'] ?? baseMessages.minLength,
      maxLength: _customMessages['maxLength'] ?? baseMessages.maxLength,
      requireUppercase:
          _customMessages['requireUppercase'] ?? baseMessages.requireUppercase,
      requireLowercase:
          _customMessages['requireLowercase'] ?? baseMessages.requireLowercase,
      requireNumbers:
          _customMessages['requireNumbers'] ?? baseMessages.requireNumbers,
      requireSpecialChars: _customMessages['requireSpecialChars'] ??
          baseMessages.requireSpecialChars,
      noSpaces: _customMessages['noSpaces'] ?? baseMessages.noSpaces,
      notCommon: _customMessages['notCommon'] ?? baseMessages.notCommon,
      noRepeatedChars:
          _customMessages['noRepeatedChars'] ?? baseMessages.noRepeatedChars,
      noSequentialChars: _customMessages['noSequentialChars'] ??
          baseMessages.noSequentialChars,
      veryWeak: _customMessages['veryWeak'] ?? baseMessages.veryWeak,
      weak: _customMessages['weak'] ?? baseMessages.weak,
      fair: _customMessages['fair'] ?? baseMessages.fair,
      good: _customMessages['good'] ?? baseMessages.good,
      strong: _customMessages['strong'] ?? baseMessages.strong,
      veryStrong: _customMessages['veryStrong'] ?? baseMessages.veryStrong,
    );
  }
}
