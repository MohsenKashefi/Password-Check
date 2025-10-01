import 'password_messages.dart';
import 'language_detector.dart';
import 'custom_messages.dart';
import '../password_validation_result.dart';

/// Centralized language management system for the entire password check package.
/// This class provides a single point of control for all internationalization.
class LanguageManager {
  static LanguageManager? _instance;
  static LanguageManager get instance => _instance ??= LanguageManager._();
  
  String _currentLanguage;
  PasswordMessages _messages;
  CustomMessages? _customMessages;

  LanguageManager._() 
      : _currentLanguage = LanguageDetector.detectSystemLanguage(),
        _messages = LanguageDetector.getSystemMessages();

  /// Gets the current language manager instance.
  static LanguageManager get current => instance;

  /// Gets the current language code.
  String get language => _currentLanguage;

  /// Gets the current messages instance.
  PasswordMessages get messages => _messages;

  /// Gets the current custom messages if any.
  CustomMessages? get customMessages => _customMessages;

  /// Sets the language for the entire application.
  /// This will automatically update all components that use this manager.
  void setLanguage(String languageCode) {
    if (_currentLanguage == languageCode) return;
    
    _currentLanguage = languageCode;
    _updateMessages();
  }

  /// Sets custom messages that will override the default messages.
  void setCustomMessages(CustomMessages? customMessages) {
    _customMessages = customMessages;
    _updateMessages();
  }

  /// Sets both language and custom messages at once.
  void configure({
    String? language,
    CustomMessages? customMessages,
  }) {
    bool needsUpdate = false;
    
    if (language != null && _currentLanguage != language) {
      _currentLanguage = language;
      needsUpdate = true;
    }
    
    if (_customMessages != customMessages) {
      _customMessages = customMessages;
      needsUpdate = true;
    }
    
    if (needsUpdate) {
      _updateMessages();
    }
  }

  /// Resets to system language and clears custom messages.
  void reset() {
    _currentLanguage = LanguageDetector.detectSystemLanguage();
    _customMessages = null;
    _updateMessages();
  }

  /// Gets a localized message with parameter substitution.
  String getMessage(String key, {Map<String, dynamic>? params}) {
    return _messages.getMessage(key, params: params);
  }

  /// Gets the localized display name for a strength level.
  String getStrengthLevelName(PasswordStrengthLevel level) {
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

  /// Checks if a language is supported.
  bool isLanguageSupported(String languageCode) {
    return LanguageDetector.isLanguageSupported(languageCode);
  }

  /// Gets list of supported languages.
  List<String> getSupportedLanguages() {
    return LanguageDetector.getSupportedLanguages();
  }

  /// Gets language name for display.
  String getLanguageName(String languageCode) {
    return LanguageDetector.getLanguageName(languageCode);
  }

  /// Updates the messages based on current language and custom messages.
  void _updateMessages() {
    final baseMessages = LanguageDetector.getMessagesForLanguage(_currentLanguage);
    
    if (_customMessages != null) {
      _messages = _customMessages!.applyTo(baseMessages);
    } else {
      _messages = baseMessages;
    }
  }
}

/// Extension to make PasswordStrengthLevel work with LanguageManager.
extension PasswordStrengthLevelLanguageExtension on PasswordStrengthLevel {
  /// Gets localized display name using the current language manager.
  String get localizedDisplayName => LanguageManager.current.getStrengthLevelName(this);
}

