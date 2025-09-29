# Password Check

A comprehensive Flutter package for password validation, strength checking, and security analysis. This package provides robust password validation with customizable rules, strength scoring, and common password detection.

## Features

- ✅ **Comprehensive Validation**: Length, character types, patterns, and more
- ✅ **Strength Scoring**: 0-100 score with detailed strength levels
- ✅ **Common Password Detection**: Built-in dictionary of weak passwords
- ✅ **Customizable Rules**: Basic, strong, strict, or custom validation rules
- ✅ **Pattern Detection**: Sequential characters, keyboard patterns, repeated patterns
- ✅ **Detailed Results**: Validation errors, warnings, and strength analysis
- ✅ **Flutter Ready**: Works seamlessly with Flutter and Dart applications

## Getting Started

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  password_check: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
import 'package:password_check/password_check.dart';

void main() {
  // Create a password checker with default rules
  final checker = PasswordChecker();
  
  // Validate a password
  final result = checker.validate('MySecurePassword123!');
  
  if (result.isValid) {
    print('Password is valid!');
    print('Strength: ${result.strengthLevel.displayName}');
    print('Score: ${result.strengthScore}/100');
  } else {
    print('Password validation failed:');
    for (final error in result.errors) {
      print('- $error');
    }
  }
}
```

### Using Different Validation Rules

```dart
// Basic validation (minimal requirements)
final basicChecker = PasswordChecker.basic();
final basicResult = basicChecker.validate('simple123');

// Strong validation (recommended for most apps)
final strongChecker = PasswordChecker.strong();
final strongResult = strongChecker.validate('MyStrongPassword123!');

// Strict validation (for high-security applications)
final strictChecker = PasswordChecker.strict();
final strictResult = strictChecker.validate('MyVeryStrictPassword123!@#');

// Custom validation rules
final customChecker = PasswordChecker(
  rules: ValidationRules(
    minLength: 10,
    requireUppercase: true,
    requireLowercase: true,
    requireNumbers: true,
    requireSpecialChars: false,
    allowSpaces: true,
  ),
);
```

### Password Strength Analysis

```dart
final checker = PasswordChecker();
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

// Get warnings
for (final warning in result.warnings) {
  print('Warning: $warning');
}
```

### Custom Validation Rules

```dart
const customRules = ValidationRules(
  minLength: 12,
  maxLength: 50,
  requireUppercase: true,
  requireLowercase: true,
  requireNumbers: true,
  requireSpecialChars: true,
  allowSpaces: false,
  checkCommonPasswords: true,
  checkRepeatedChars: true,
  maxRepeatedChars: 2,
  checkSequentialChars: true,
  maxSequentialLength: 3,
);

final checker = PasswordChecker(rules: customRules);
```

## API Reference

### PasswordChecker

Main class for password validation.

#### Constructors

- `PasswordChecker({ValidationRules? rules})` - Creates with custom rules
- `PasswordChecker.basic()` - Creates with basic validation rules
- `PasswordChecker.strong()` - Creates with strong validation rules  
- `PasswordChecker.strict()` - Creates with strict validation rules

#### Methods

- `PasswordValidationResult validate(String password)` - Validates a password

### PasswordValidationResult

Result object containing validation information.

#### Properties

- `bool isValid` - Whether the password passed all validation rules
- `List<String> errors` - List of validation errors
- `List<String> warnings` - List of validation warnings
- `int strengthScore` - Password strength score (0-100)
- `PasswordStrengthLevel strengthLevel` - Password strength level
- `Map<String, bool> checks` - Detailed breakdown of validation checks

### ValidationRules

Configuration class for password validation rules.

#### Properties

- `int minLength` - Minimum password length (default: 8)
- `int maxLength` - Maximum password length (default: 128)
- `bool requireUppercase` - Require uppercase letters (default: true)
- `bool requireLowercase` - Require lowercase letters (default: true)
- `bool requireNumbers` - Require numbers (default: true)
- `bool requireSpecialChars` - Require special characters (default: true)
- `bool allowSpaces` - Allow spaces in password (default: false)
- `bool checkCommonPasswords` - Check against common passwords (default: true)
- `bool checkRepeatedChars` - Check for repeated characters (default: true)
- `int maxRepeatedChars` - Maximum repeated characters allowed (default: 3)
- `bool checkSequentialChars` - Check for sequential characters (default: true)
- `int maxSequentialLength` - Maximum sequential length allowed (default: 3)

### PasswordStrengthLevel

Enum representing password strength levels:

- `veryWeak` - Very weak password
- `weak` - Weak password
- `fair` - Fair password
- `good` - Good password
- `strong` - Strong password
- `veryStrong` - Very strong password

## Examples

### Flutter Form Validation

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
}
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package useful, please consider giving it a ⭐ on GitHub!
