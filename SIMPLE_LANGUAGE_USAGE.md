# 🌍 Simple Language Usage Guide

## The Problem We Solved

**Before (Old Way):**
```dart
// Had to pass language to every component separately
PasswordChecker.strong(language: 'fa')
PasswordGenerator.strong(language: 'fa')
PasswordStrengthIndicator(result: result, language: 'fa')
// ... repetitive and error-prone
```

**After (New Way):**
```dart
// Set language once, applies everywhere automatically!
LanguageManager.current.setLanguage('fa');
PasswordChecker.strong() // Automatically uses Persian
PasswordGenerator.strong() // Automatically uses Persian
PasswordStrengthIndicator(result: result) // Automatically uses Persian
```

## 🚀 How to Use

### **1. Basic Usage - Set Language Once**

```dart
import 'package:password_check/password_check.dart';

void main() {
  // Set language once for the entire app
  LanguageManager.current.setLanguage('fa'); // Persian
  
  // All components now automatically use Persian!
  final checker = PasswordChecker.strong();
  final result = checker.validate('کوتاه'); // "short" in Persian
  
  // Error messages will be in Persian automatically
  print(result.errors); // Shows Persian error messages
}
```

### **2. Flutter App Example**

```dart
class MyPasswordApp extends StatefulWidget {
  @override
  _MyPasswordAppState createState() => _MyPasswordAppState();
}

class _MyPasswordAppState extends State<MyPasswordApp> {
  late PasswordChecker _checker;
  String _selectedLanguage = 'fa';
  
  @override
  void initState() {
    super.initState();
    // Set language once
    LanguageManager.current.setLanguage(_selectedLanguage);
    _checker = PasswordChecker.strong(); // No need to pass language!
  }
  
  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
      // Change language once, applies everywhere!
      LanguageManager.current.setLanguage(language);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Language selector
          DropdownButton<String>(
            value: _selectedLanguage,
            items: [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'fa', child: Text('فارسی')),
              DropdownMenuItem(value: 'es', child: Text('Español')),
            ],
            onChanged: (value) {
              if (value != null) _changeLanguage(value);
            },
          ),
          
          // Password input
          TextField(
            onChanged: (value) {
              final result = _checker.validate(value);
              // All messages automatically use current language!
            },
          ),
          
          // All these widgets automatically use the current language
          PasswordStrengthIndicator(result: result),
          PasswordRequirementsChecklist(result: result, rules: rules),
        ],
      ),
    );
  }
}
```

### **3. Dynamic Language Switching**

```dart
class LanguageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // Change to English
            LanguageManager.current.setLanguage('en');
          },
          child: Text('English'),
        ),
        ElevatedButton(
          onPressed: () {
            // Change to Persian
            LanguageManager.current.setLanguage('fa');
          },
          child: Text('فارسی'),
        ),
        ElevatedButton(
          onPressed: () {
            // Change to Spanish
            LanguageManager.current.setLanguage('es');
          },
          child: Text('Español'),
        ),
      ],
    );
  }
}
```

### **4. Custom Messages**

```dart
// Set custom messages that override default translations
final customMessages = CustomMessages.fromMap({
  'minLength': '🔒 رمز عبور باید حداقل {min} کاراکتر باشد',
  'requireUppercase': '🔤 حرف بزرگ اضافه کنید',
  'strong': '💪 قوی',
});

LanguageManager.current.setCustomMessages(customMessages);
```

## 🌍 Supported Languages

- 🇺🇸 **English** (en)
- 🇪🇸 **Spanish** (es) 
- 🇫🇷 **French** (fr)
- 🇩🇪 **German** (de)
- 🇵🇹 **Portuguese** (pt)
- 🇮🇹 **Italian** (it)
- 🇮🇷 **Persian** (fa)

## 💡 Key Benefits

- ✅ **Single Point of Control**: Change language once, applies everywhere
- ✅ **Reduced Boilerplate**: No need to pass language to each component
- ✅ **Automatic Consistency**: All components stay in sync
- ✅ **Easy Maintenance**: Update language logic in one place
- ✅ **Flutter Integration**: Works seamlessly with Flutter widgets
- ✅ **Backward Compatible**: Old API still works

## 🎯 Real-World Example

```dart
class PasswordForm extends StatefulWidget {
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _passwordController = TextEditingController();
  late PasswordChecker _checker;
  PasswordValidationResult? _result;
  String _language = 'fa'; // Default to Persian
  
  @override
  void initState() {
    super.initState();
    // Set language once
    LanguageManager.current.setLanguage(_language);
    _checker = PasswordChecker.strong(); // No language parameter needed!
    _passwordController.addListener(_validatePassword);
  }
  
  void _validatePassword() {
    setState(() {
      _result = _checker.validate(_passwordController.text);
      // All error messages will be in Persian automatically!
    });
  }
  
  void _changeLanguage(String newLanguage) {
    setState(() {
      _language = newLanguage;
      // Change language once, applies everywhere!
      LanguageManager.current.setLanguage(newLanguage);
      _validatePassword(); // Re-validate to get new language messages
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Language selector
        DropdownButton<String>(
          value: _language,
          items: [
            DropdownMenuItem(value: 'en', child: Text('🇺🇸 English')),
            DropdownMenuItem(value: 'fa', child: Text('🇮🇷 فارسی')),
            DropdownMenuItem(value: 'es', child: Text('🇪🇸 Español')),
          ],
          onChanged: (value) {
            if (value != null) _changeLanguage(value);
          },
        ),
        
        // Password input
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Enter password',
            errorText: _result?.isValid == false 
                ? _result!.errors.first 
                : null,
          ),
        ),
        
        // All these widgets automatically use the current language
        if (_result != null) ...[
          PasswordStrengthIndicator(result: _result!),
          PasswordRequirementsChecklist(result: _result!, rules: ValidationRules.strong()),
          PasswordImprovementSuggestions(result: _result!, rules: ValidationRules.strong()),
        ],
      ],
    );
  }
}
```

## 🎉 Summary

With the centralized language system, you can now:

1. **Set language once**: `LanguageManager.current.setLanguage('fa')`
2. **All components automatically use the language**: No need to pass language parameters
3. **Easy language switching**: Change language and all components update automatically
4. **Consistent experience**: All error messages, indicators, and UI elements use the same language

This makes internationalization much simpler and more maintainable! 🌍✨

