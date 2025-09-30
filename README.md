# Password Check

A comprehensive Flutter package for password validation, strength checking, and security analysis. This package provides robust password validation with customizable rules, strength scoring, and common password detection.

## Features

- ✅ **Comprehensive Validation**: Length, character types, patterns, and more
- ✅ **Strength Scoring**: 0-100 score with detailed strength levels
- ✅ **Common Password Detection**: Built-in dictionary of weak passwords
- ✅ **Customizable Rules**: Basic, strong, strict, or custom validation rules
- ✅ **Pattern Detection**: Sequential characters, keyboard patterns, repeated patterns
- ✅ **Detailed Results**: Validation errors, warnings, and strength analysis
- ✅ **Secure Password Generation**: Generate cryptographically secure passwords
- ✅ **Generation History**: Track generated passwords with timestamps
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

### Password Generation

```dart
import 'package:password_check/password_check.dart';

void main() {
  // Create a password generator with default rules
  final generator = PasswordGenerator();
  
  // Generate a single password
  final result = generator.generate();
  
  print('Generated password: ${result.password}');
  print('Strength: ${result.strengthLevel.displayName}');
  print('Score: ${result.strengthScore}/100');
  print('Is valid: ${result.isValid}');
  
  // Generate multiple passwords
  final results = generator.generateMultiple(5);
  for (final result in results) {
    print('Password: ${result.password}');
  }
  
  // Generate with custom rules
  final customGenerator = PasswordGenerator(
    rules: const GenerationRules(
      length: 20,
      includeUppercase: true,
      includeLowercase: true,
      includeNumbers: true,
      includeSpecialChars: true,
      avoidSimilarChars: true,
      ensureCharacterVariety: true,
    ),
  );
  
  final strongPassword = customGenerator.generate();
  print('Strong password: ${strongPassword.password}');
}
```

### Using Generation Presets

```dart
// Basic generation (8 chars, lowercase + numbers)
final basicGenerator = PasswordGenerator.basic();
final basicPassword = basicGenerator.generate();

// Strong generation (16 chars, all character types)
final strongGenerator = PasswordGenerator.strong();
final strongPassword = strongGenerator.generate();

// Strict generation (20 chars, all character types, avoid similar chars)
final strictGenerator = PasswordGenerator.strict();
final strictPassword = strictGenerator.generate();
```

### Generation History

```dart
final generator = PasswordGenerator();

// Generate some passwords
generator.generate();
generator.generate();
generator.generate();

// Access generation history
print('Generated ${generator.historyCount} passwords');
print('Last password: ${generator.lastResult?.password}');

// View all generated passwords
for (final result in generator.history) {
  print('${result.timestamp}: ${result.password} (${result.strengthLevel.displayName})');
}

// Clear history
generator.clearHistory();
```

### Using with PasswordChecker Extension

```dart
final checker = PasswordChecker.strong();

// Generate password using checker's validation rules
final result = checker.generatePassword(
  length: 16,
  includeUppercase: true,
  includeLowercase: true,
  includeNumbers: true,
  includeSpecialChars: true,
);

print('Generated: ${result.password}');
print('Valid: ${result.isValid}');
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

### PasswordGenerator

Main class for generating secure passwords.

#### Constructors

- `PasswordGenerator({GenerationRules? rules, String? language, CustomMessages? customMessages})` - Creates with custom rules
- `PasswordGenerator.basic()` - Creates with basic generation rules
- `PasswordGenerator.strong()` - Creates with strong generation rules  
- `PasswordGenerator.strict()` - Creates with strict generation rules
- `PasswordGenerator.auto()` - Creates with automatic language detection
- `PasswordGenerator.localized({required String language})` - Creates with specific language

#### Methods

- `GenerationResult generate()` - Generates a single password
- `List<GenerationResult> generateMultiple(int count)` - Generates multiple passwords
- `GenerationResult generateValid({ValidationRules? validationRules})` - Generates a password that meets validation rules
- `void clearHistory()` - Clears generation history

#### Properties

- `List<GenerationResult> history` - List of generated passwords
- `int historyCount` - Number of generated passwords
- `GenerationResult? lastResult` - Most recent generation result
- `String language` - Current language code
- `PasswordMessages messages` - Current messages
- `GenerationRules rules` - Current generation rules

### GenerationRules

Configuration class for password generation rules.

#### Properties

- `int length` - Length of generated password (default: 12)
- `bool includeUppercase` - Include uppercase letters (default: true)
- `bool includeLowercase` - Include lowercase letters (default: true)
- `bool includeNumbers` - Include numbers (default: true)
- `bool includeSpecialChars` - Include special characters (default: true)
- `bool includeSpaces` - Include spaces (default: false)
- `bool avoidSimilarChars` - Avoid similar characters like 0, O, l, 1 (default: true)
- `bool avoidAmbiguousChars` - Avoid ambiguous characters (default: true)
- `String? customChars` - Custom character set to include
- `bool ensureCharacterVariety` - Ensure at least one character from each included set (default: true)

#### Constructors

- `GenerationRules()` - Default rules
- `GenerationRules.basic()` - Basic rules (8 chars, lowercase + numbers)
- `GenerationRules.strong()` - Strong rules (16 chars, all character types)
- `GenerationRules.strict()` - Strict rules (20 chars, all character types, avoid similar chars)
- `GenerationRules.custom()` - Custom rules with specified parameters

### GenerationResult

Result of password generation containing the password and metadata.

#### Properties

- `String password` - The generated password
- `GenerationRules rules` - Generation rules used
- `PasswordValidationResult validation` - Validation result of the generated password
- `DateTime timestamp` - When the password was generated
- `bool isValid` - Whether the password meets validation requirements

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

## 🎨 **Advanced UI Widgets**

The package includes powerful pre-built widgets for comprehensive password visualization:

### **PasswordStrengthIndicator**
Animated strength indicator with breakdown visualization and improvement suggestions.

```dart
PasswordStrengthIndicator(
  result: validationResult,
  showBreakdown: true,
  showSuggestions: true,
  animated: true,
)
```

### **PasswordRequirementsChecklist**
Interactive checklist showing password requirements with progress tracking.

```dart
PasswordRequirementsChecklist(
  result: validationResult,
  rules: validationRules,
  showProgress: true,
  animated: true,
)
```

### **PasswordStrengthMeter**
Circular strength meter with animated progress and customizable display.

```dart
PasswordStrengthMeter(
  result: validationResult,
  size: 120.0,
  animated: true,
  showScore: true,
  showLevel: true,
)
```

### **PasswordImprovementSuggestions**
Smart improvement suggestions with contextual advice and priority levels.

```dart
PasswordImprovementSuggestions(
  result: validationResult,
  rules: validationRules,
  showIcons: true,
  showPriority: true,
)
```

### **PasswordVisualizer**
Comprehensive visualization widget combining all indicators in a tabbed interface.

```dart
PasswordVisualizer(
  result: validationResult,
  rules: validationRules,
  animated: true,
)
```

## 📚 **Documentation**

- [Advanced Widgets Guide](ADVANCED_WIDGETS.md) - Comprehensive documentation for all UI widgets
- [Internationalization Guide](I18N_EXAMPLES.md) - Multi-language support examples

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package useful, please consider giving it a ⭐ on GitHub!
