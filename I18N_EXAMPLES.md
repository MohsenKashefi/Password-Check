# 🌍 Internationalization (i18n) Examples

This document provides comprehensive examples of how to use the internationalization features in the Password Check package.

## 📋 **Supported Languages**

The package currently supports the following languages:

- 🇺🇸 **English** (en) - Default
- 🇪🇸 **Spanish** (es) - Español
- 🇫🇷 **French** (fr) - Français
- 🇩🇪 **German** (de) - Deutsch
- 🇵🇹 **Portuguese** (pt) - Português
- 🇮🇹 **Italian** (it) - Italiano
- 🇮🇷 **Persian** (fa) - فارسی

## 🚀 **Basic Usage Examples**

### **1. Automatic Language Detection**
```dart
import 'package:password_check/password_check.dart';

void main() {
  // Automatically detects system language
  final checker = PasswordChecker.auto();
  
  final result = checker.validate('short');
  
  if (!result.isValid) {
    print('Errors: ${result.errors}');
    // Will show errors in system language
  }
}
```

### **2. Specific Language Selection**
```dart
// Spanish validation
final spanishChecker = PasswordChecker(language: 'es');
final result = spanishChecker.validate('corto');

if (!result.isValid) {
  print('Errores: ${result.errors}');
  // Output: "Errores: [La contraseña debe tener al menos 8 caracteres]"
}

// French validation
final frenchChecker = PasswordChecker(language: 'fr');
final frenchResult = frenchChecker.validate('court');

if (!frenchResult.isValid) {
  print('Erreurs: ${frenchResult.errors}');
  // Output: "Erreurs: [Le mot de passe doit contenir au moins 8 caractères]"
}

// Persian validation
final persianChecker = PasswordChecker(language: 'fa');
final persianResult = persianChecker.validate('کوتاه');

if (!persianResult.isValid) {
  print('خطاها: ${persianResult.errors}');
  // Output: "خطاها: [رمز عبور باید حداقل 8 کاراکتر باشد]"
}
```

### **3. Localized Constructor**
```dart
// Using localized constructor
final checker = PasswordChecker.localized(
  language: 'de',
  rules: ValidationRules.strong(),
);

final result = checker.validate('kurz');
print('Fehler: ${result.errors}');
// Output: "Fehler: [Das Passwort muss mindestens 12 Zeichen lang sein]"
```

## 🎨 **Custom Messages**

### **1. Custom Message Override**
```dart
import 'package:password_check/password_check.dart';

void main() {
  // Create custom messages
  final customMessages = CustomMessages.fromMap({
    'minLength': 'Your password needs at least {min} characters',
    'requireUppercase': 'Please add an uppercase letter',
    'requireNumbers': 'Don\'t forget to include numbers',
    'veryWeak': 'Not Secure',
    'strong': 'Excellent Security',
  });

  final checker = PasswordChecker(
    language: 'en',
    customMessages: customMessages,
  );

  final result = checker.validate('weak');
  
  print('Custom errors: ${result.errors}');
  // Output: "Custom errors: [Your password needs at least 8 characters]"
}
```

### **2. JSON Configuration**
```dart
// Load custom messages from JSON
final jsonMessages = {
  'minLength': 'La contraseña debe tener al menos {min} caracteres',
  'requireUppercase': 'Agrega al menos una letra mayúscula',
  'strong': 'Seguridad Excelente',
};

final customMessages = CustomMessages.fromJson(jsonMessages);

final checker = PasswordChecker(
  language: 'es',
  customMessages: customMessages,
);
```

### **3. Merging Custom Messages**
```dart
// Base custom messages
final baseMessages = CustomMessages.fromMap({
  'minLength': 'Minimum length required',
  'requireUppercase': 'Uppercase required',
});

// Additional messages
final additionalMessages = CustomMessages.fromMap({
  'requireNumbers': 'Numbers required',
  'strong': 'Great security!',
});

// Merge them
final mergedMessages = baseMessages.merge(additionalMessages);

final checker = PasswordChecker(
  customMessages: mergedMessages,
);
```

## 🎯 **Advanced Examples**

### **1. Multi-language Application**
```dart
class PasswordValidator {
  late PasswordChecker _checker;
  
  PasswordValidator(String language) {
    _checker = PasswordChecker(language: language);
  }
  
  String validatePassword(String password) {
    final result = _checker.validate(password);
    
    if (result.isValid) {
      return 'Password is valid!';
    } else {
      return result.errors.join(', ');
    }
  }
}

// Usage
final englishValidator = PasswordValidator('en');
final spanishValidator = PasswordValidator('es');
final frenchValidator = PasswordValidator('fr');

print(englishValidator.validatePassword('weak'));
// Output: "Password must be at least 8 characters long"

print(spanishValidator.validatePassword('débil'));
// Output: "La contraseña debe tener al menos 8 caracteres"

print(frenchValidator.validatePassword('faible'));
// Output: "Le mot de passe doit contenir au moins 8 caractères"
```

### **2. Flutter Widget with i18n**
```dart
import 'package:flutter/material.dart';
import 'package:password_check/password_check.dart';

class LocalizedPasswordField extends StatefulWidget {
  final String language;
  
  const LocalizedPasswordField({
    Key? key,
    required this.language,
  }) : super(key: key);

  @override
  _LocalizedPasswordFieldState createState() => _LocalizedPasswordFieldState();
}

class _LocalizedPasswordFieldState extends State<LocalizedPasswordField> {
  final _passwordController = TextEditingController();
  late PasswordChecker _checker;
  PasswordValidationResult? _result;

  @override
  void initState() {
    super.initState();
    _checker = PasswordChecker(language: widget.language);
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    setState(() {
      _result = _checker.validate(_passwordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: _getLabelText(),
            errorText: _result?.isValid == false 
                ? _result!.errors.first 
                : null,
          ),
        ),
        if (_result != null) ...[
          LinearProgressIndicator(
            value: _result!.strengthScore / 100,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStrengthColor(_result!.strengthLevel),
            ),
          ),
          Text(_getStrengthText()),
        ],
      ],
    );
  }

  String _getLabelText() {
    switch (widget.language) {
      case 'es': return 'Contraseña';
      case 'fr': return 'Mot de passe';
      case 'de': return 'Passwort';
      case 'pt': return 'Senha';
      case 'it': return 'Password';
      default: return 'Password';
    }
  }

  String _getStrengthText() {
    if (_result == null) return '';
    
    final strengthText = _result!.strengthLevel.getLocalizedDisplayName(
      _checker._messages
    );
    
    return 'Strength: $strengthText';
  }

  Color _getStrengthColor(PasswordStrengthLevel level) {
    switch (level) {
      case PasswordStrengthLevel.veryWeak:
      case PasswordStrengthLevel.weak:
        return Colors.red;
      case PasswordStrengthLevel.fair:
        return Colors.orange;
      case PasswordStrengthLevel.good:
        return Colors.yellow;
      case PasswordStrengthLevel.strong:
      case PasswordStrengthLevel.veryStrong:
        return Colors.green;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
```

### **3. Language Detection and Fallback**
```dart
import 'dart:ui';

class SmartPasswordChecker {
  static PasswordChecker create() {
    // Get system language
    final systemLanguage = PlatformDispatcher.instance.locale.languageCode;
    
    // Check if language is supported
    if (LanguageDetector.isLanguageSupported(systemLanguage)) {
      return PasswordChecker(language: systemLanguage);
    } else {
      // Fallback to English
      return PasswordChecker(language: 'en');
    }
  }
  
  static PasswordChecker createWithFallback(String preferredLanguage) {
    if (LanguageDetector.isLanguageSupported(preferredLanguage)) {
      return PasswordChecker(language: preferredLanguage);
    } else {
      return PasswordChecker(language: 'en');
    }
  }
}

// Usage
final checker = SmartPasswordChecker.create();
final result = checker.validate('password');
```

### **4. Enterprise Configuration**
```dart
class EnterprisePasswordChecker {
  final Map<String, PasswordChecker> _checkers = {};
  
  EnterprisePasswordChecker() {
    // Pre-initialize checkers for all supported languages
    for (final language in LanguageDetector.getSupportedLanguages()) {
      _checkers[language] = PasswordChecker(
        language: language,
        rules: ValidationRules.strict(),
      );
    }
  }
  
  PasswordValidationResult validate(String password, String language) {
    final checker = _checkers[language] ?? _checkers['en']!;
    return checker.validate(password);
  }
  
  List<String> getSupportedLanguages() {
    return LanguageDetector.getSupportedLanguages();
  }
  
  String getLanguageName(String languageCode) {
    return LanguageDetector.getLanguageName(languageCode);
  }
}
```

## 🔧 **Configuration Examples**

### **1. App-level Configuration**
```dart
class AppConfig {
  static const String defaultLanguage = 'en';
  static const List<String> supportedLanguages = ['en', 'es', 'fr', 'de', 'pt', 'it'];
  
  static PasswordChecker createChecker(String? language) {
    final selectedLanguage = language ?? defaultLanguage;
    
    if (supportedLanguages.contains(selectedLanguage)) {
      return PasswordChecker(language: selectedLanguage);
    } else {
      return PasswordChecker(language: defaultLanguage);
    }
  }
}
```

### **2. User Preference Integration**
```dart
class UserPreferences {
  String _language = 'en';
  
  String get language => _language;
  
  void setLanguage(String language) {
    if (LanguageDetector.isLanguageSupported(language)) {
      _language = language;
    }
  }
  
  PasswordChecker createPasswordChecker() {
    return PasswordChecker(language: _language);
  }
}
```

## 📊 **Testing i18n Features**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:password_check/password_check.dart';

void main() {
  group('i18n Tests', () {
    test('should validate in Spanish', () {
      final checker = PasswordChecker(language: 'es');
      final result = checker.validate('corto');
      
      expect(result.errors, contains('La contraseña debe tener al menos 8 caracteres'));
    });
    
    test('should validate in French', () {
      final checker = PasswordChecker(language: 'fr');
      final result = checker.validate('court');
      
      expect(result.errors, contains('Le mot de passe doit contenir au moins 8 caractères'));
    });
    
    test('should use custom messages', () {
      final customMessages = CustomMessages.fromMap({
        'minLength': 'Custom message for minimum length',
      });
      
      final checker = PasswordChecker(customMessages: customMessages);
      final result = checker.validate('short');
      
      expect(result.errors, contains('Custom message for minimum length'));
    });
  });
}
```

## 🎯 **Best Practices**

1. **Always provide fallback language** - Use English as fallback
2. **Test all supported languages** - Ensure messages are correct
3. **Use consistent terminology** - Maintain same terms across languages
4. **Consider cultural differences** - Adapt messages for local context
5. **Performance optimization** - Pre-initialize checkers for common languages
6. **User experience** - Allow users to change language dynamically

## 🚀 **Migration Guide**

### **From English-only to i18n**

**Before:**
```dart
final checker = PasswordChecker();
final result = checker.validate('password');
```

**After:**
```dart
final checker = PasswordChecker(language: 'es');
final result = checker.validate('password');
```

### **Adding Custom Messages**

**Before:**
```dart
final checker = PasswordChecker();
```

**After:**
```dart
final customMessages = CustomMessages.fromMap({
  'minLength': 'Your custom message',
});
final checker = PasswordChecker(customMessages: customMessages);
```

This comprehensive i18n system makes your password checker package truly international and user-friendly! 🌍
