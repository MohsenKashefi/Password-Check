# Password Check - Flutter Package

A comprehensive Flutter package for password validation, strength checking, and security analysis. This package provides robust password validation with customizable rules, strength scoring, and common password detection.

## 🚀 Features

- ✅ **Comprehensive Validation**: Length, character types, patterns, and more
- ✅ **Strength Scoring**: 0-100 score with detailed strength levels
- ✅ **Common Password Detection**: Built-in dictionary of weak passwords
- ✅ **Customizable Rules**: Basic, strong, strict, or custom validation rules
- ✅ **Pattern Detection**: Sequential characters, keyboard patterns, repeated patterns
- ✅ **Detailed Results**: Validation errors, warnings, and strength analysis
- ✅ **Flutter Ready**: Works seamlessly with Flutter and Dart applications

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  password_check: ^1.0.0
```

## 🎯 Quick Start

```dart
import 'package:password_check/password_check.dart';

void main() {
  // Create a password checker
  final checker = PasswordChecker.strong();
  
  // Validate a password
  final result = checker.validate('MySecurePassword123!');
  
  if (result.isValid) {
    print('Password is valid!');
    print('Strength: ${result.strengthLevel.displayName}');
    print('Score: ${result.strengthScore}/100');
  } else {
    print('Validation errors:');
    for (final error in result.errors) {
      print('- $error');
    }
  }
}
```

## 🔧 Usage Examples

### Different Validation Rules

```dart
// Basic validation (minimal requirements)
final basicChecker = PasswordChecker.basic();

// Strong validation (recommended for most apps)
final strongChecker = PasswordChecker.strong();

// Strict validation (for high-security applications)
final strictChecker = PasswordChecker.strict();

// Custom validation rules
final customChecker = PasswordChecker(
  rules: ValidationRules(
    minLength: 12,
    requireUppercase: true,
    requireLowercase: true,
    requireNumbers: true,
    requireSpecialChars: true,
    allowSpaces: false,
    checkCommonPasswords: true,
  ),
);
```

### Password Strength Analysis

```dart
final result = checker.validate('MyPassword123!');

print('Is Valid: ${result.isValid}');
print('Strength Score: ${result.strengthScore}/100');
print('Strength Level: ${result.strengthLevel.displayName}');

// Check individual validation rules
print('Length Check: ${result.checks['minLength']}');
print('Uppercase Check: ${result.checks['uppercase']}');
print('Lowercase Check: ${result.checks['lowercase']}');
print('Numbers Check: ${result.checks['numbers']}');
print('Special Chars Check: ${result.checks['specialChars']}');
```

## 🎨 Flutter Integration

```dart
class PasswordForm extends StatefulWidget {
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _passwordController = TextEditingController();
  final _checker = PasswordChecker.strong();
  PasswordValidationResult? _validationResult;

  void _validatePassword(String password) {
    setState(() {
      _validationResult = _checker.validate(password);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _passwordController,
          onChanged: _validatePassword,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: _validationResult?.isValid == false 
                ? _validationResult!.errors.first 
                : null,
          ),
        ),
        if (_validationResult != null) ...[
          LinearProgressIndicator(
            value: _validationResult!.strengthScore / 100,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStrengthColor(_validationResult!.strengthLevel),
            ),
          ),
          Text('Strength: ${_validationResult!.strengthLevel.displayName}'),
        ],
      ],
    );
  }
}
```

## 📊 Strength Levels

- 🔴 **Very Weak** (0-19): Easily guessable passwords
- 🟠 **Weak** (20-39): Basic passwords with minimal security
- 🟡 **Fair** (40-59): Moderate security, room for improvement
- 🟢 **Good** (60-74): Strong passwords with good security
- 🔵 **Strong** (75-89): Very secure passwords
- 🟣 **Very Strong** (90-100): Maximum security passwords

## ⚙️ Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `minLength` | Minimum password length | 8 |
| `maxLength` | Maximum password length | 128 |
| `requireUppercase` | Require uppercase letters | true |
| `requireLowercase` | Require lowercase letters | true |
| `requireNumbers` | Require numbers | true |
| `requireSpecialChars` | Require special characters | true |
| `allowSpaces` | Allow spaces in password | false |
| `checkCommonPasswords` | Check against common passwords | true |
| `checkRepeatedChars` | Check for repeated characters | true |
| `maxRepeatedChars` | Maximum repeated characters allowed | 3 |
| `checkSequentialChars` | Check for sequential characters | true |
| `maxSequentialLength` | Maximum sequential length allowed | 3 |

## 🧪 Testing

Run the tests with:

```bash
flutter test
```

## 📱 Example App

The package includes a comprehensive example app demonstrating all features:

```bash
cd example
flutter run
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Features in Detail

### Validation Rules
- **Length Requirements**: Configurable minimum and maximum length
- **Character Types**: Uppercase, lowercase, numbers, special characters
- **Pattern Detection**: Sequential characters, keyboard patterns, repeated patterns
- **Common Passwords**: Built-in dictionary of weak passwords
- **Custom Rules**: Fully customizable validation requirements

### Strength Analysis
- **Multi-factor Scoring**: Length, variety, complexity, and pattern analysis
- **Real-time Feedback**: Instant strength calculation
- **Visual Indicators**: Color-coded strength levels
- **Detailed Breakdown**: Individual validation check results

### Security Features
- **Common Password Detection**: Prevents use of easily guessable passwords
- **Pattern Recognition**: Detects keyboard patterns and sequences
- **Character Distribution**: Analyzes password complexity
- **Flexible Configuration**: Adapt to different security requirements

## 🚀 Use Cases

- **User Registration**: Validate new user passwords
- **Password Reset**: Ensure strong new passwords
- **Security Audits**: Analyze existing password strength
- **Compliance**: Meet security requirements
- **User Education**: Help users create better passwords

## 📈 Performance

- **Lightweight**: Minimal memory footprint
- **Fast**: Optimized validation algorithms
- **Efficient**: No external dependencies
- **Scalable**: Works with any password length

---

**Made with ❤️ for the Flutter community**
