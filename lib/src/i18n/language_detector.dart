import 'dart:ui';
import 'password_messages.dart';

/// Language detector for automatic language detection.
class LanguageDetector {
  /// Detects the system language and returns appropriate locale.
  static String detectSystemLanguage() {
    final locale = PlatformDispatcher.instance.locale;
    return locale.languageCode;
  }

  /// Gets the appropriate PasswordMessages for the given language code.
  static PasswordMessages getMessagesForLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'es':
        return PasswordMessages.spanish;
      case 'fr':
        return PasswordMessages.french;
      case 'de':
        return PasswordMessages.german;
      case 'pt':
        return PasswordMessages.portuguese;
      case 'it':
        return PasswordMessages.italian;
      case 'fa':
      case 'per':
        return PasswordMessages.persian;
      case 'en':
      default:
        return PasswordMessages.english;
    }
  }

  /// Gets the appropriate PasswordMessages for the system language.
  static PasswordMessages getSystemMessages() {
    final languageCode = detectSystemLanguage();
    return getMessagesForLanguage(languageCode);
  }

  /// Checks if a language is supported.
  static bool isLanguageSupported(String languageCode) {
    const supportedLanguages = [
      'en',
      'es',
      'fr',
      'de',
      'pt',
      'it',
      'fa',
      'per'
    ];
    return supportedLanguages.contains(languageCode.toLowerCase());
  }

  /// Gets list of supported language codes.
  static List<String> getSupportedLanguages() {
    return ['en', 'es', 'fr', 'de', 'pt', 'it', 'fa', 'per'];
  }

  /// Gets language name for display.
  static String getLanguageName(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'pt':
        return 'Português';
      case 'it':
        return 'Italiano';
      case 'fa':
      case 'per':
        return 'فارسی';
      default:
        return 'English';
    }
  }
}
