import 'package:flutter/material.dart';
import 'package:password_check/password_check.dart';

void main() {
  runApp(const PasswordCheckExampleApp());
}

class PasswordCheckExampleApp extends StatelessWidget {
  const PasswordCheckExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Check Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PasswordCheckDemo(),
    );
  }
}

class PasswordCheckDemo extends StatefulWidget {
  const PasswordCheckDemo({Key? key}) : super(key: key);

  @override
  State<PasswordCheckDemo> createState() => _PasswordCheckDemoState();
}

class _PasswordCheckDemoState extends State<PasswordCheckDemo> {
  final _passwordController = TextEditingController();
  late PasswordChecker _checker;
  PasswordValidationResult? _validationResult;
  ValidationRules _selectedRules = const ValidationRules.strong();
  String _selectedLanguage = 'en';
  bool _useCustomMessages = false;

  @override
  void initState() {
    super.initState();
    _checker = PasswordChecker.strong(language: _selectedLanguage);
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    setState(() {
      _validationResult = _checker.validate(_passwordController.text);
    });
  }

  void _changeValidationRules(ValidationRules rules) {
    setState(() {
      _selectedRules = rules;
      _updateChecker();
      _validatePassword();
    });
  }

  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
      _updateChecker();
      _validatePassword();
    });
  }

  void _toggleCustomMessages() {
    setState(() {
      _useCustomMessages = !_useCustomMessages;
      _updateChecker();
      _validatePassword();
    });
  }

  void _updateChecker() {
    if (_useCustomMessages) {
      final customMessages = _getCustomMessages();
      _checker = PasswordChecker(
        rules: _selectedRules,
        language: _selectedLanguage,
        customMessages: customMessages,
      );
    } else {
      _checker = PasswordChecker(
        rules: _selectedRules,
        language: _selectedLanguage,
      );
    }
  }

  CustomMessages _getCustomMessages() {
    return CustomMessages.fromMap({
      'minLength': '🔒 Your password needs at least {min} characters',
      'requireUppercase': '🔤 Add an uppercase letter',
      'requireLowercase': '🔡 Add a lowercase letter',
      'requireNumbers': '🔢 Include some numbers',
      'requireSpecialChars': '✨ Add special characters',
      'notCommon': '🚫 This password is too common',
      'veryWeak': '😰 Very Weak',
      'weak': '😟 Weak',
      'fair': '😐 Fair',
      'good': '😊 Good',
      'strong': '💪 Strong',
      'veryStrong': '🛡️ Very Strong',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Check Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Validation Rules',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildRuleChip('Basic', ValidationRules.basic()),
                        _buildRuleChip('Strong', ValidationRules.strong()),
                        _buildRuleChip('Strict', ValidationRules.strict()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Language & Messages',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButton<String>(
                            value: _selectedLanguage,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(value: 'en', child: Text('🇺🇸 English')),
                              DropdownMenuItem(value: 'es', child: Text('🇪🇸 Español')),
                              DropdownMenuItem(value: 'fr', child: Text('🇫🇷 Français')),
                              DropdownMenuItem(value: 'de', child: Text('🇩🇪 Deutsch')),
                              DropdownMenuItem(value: 'pt', child: Text('🇵🇹 Português')),
                              DropdownMenuItem(value: 'it', child: Text('🇮🇹 Italiano')),
                              DropdownMenuItem(value: 'fa', child: Text('🇮🇷 فارسی')),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                _changeLanguage(value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Switch(
                          value: _useCustomMessages,
                          onChanged: (value) => _toggleCustomMessages(),
                        ),
                        const SizedBox(width: 8),
                        const Text('Custom Messages'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password Input',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Enter password',
                        border: OutlineInputBorder(),
                        hintText: 'Type your password here...',
                      ),
                    ),
                    if (_validationResult != null) ...[
                      const SizedBox(height: 16),
                      _buildValidationResult(),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Language Demo',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildLanguageDemo(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Configuration',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildConfigurationInfo(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleChip(String label, ValidationRules rules) {
    final isSelected = _selectedRules == rules;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _changeValidationRules(rules);
        }
      },
    );
  }

  Widget _buildValidationResult() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              _validationResult!.isValid ? Icons.check_circle : Icons.cancel,
              color: _validationResult!.isValid ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              _validationResult!.isValid ? 'Valid Password' : 'Invalid Password',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _validationResult!.isValid ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStrengthIndicator(),
        const SizedBox(height: 12),
        _buildChecksList(),
        if (_validationResult!.errors.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildErrorsList(),
        ],
        if (_validationResult!.warnings.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildWarningsList(),
        ],
      ],
    );
  }

  Widget _buildStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Strength: ${_validationResult!.strengthLevel.getLocalizedDisplayName(_checker.messages)}'),
            Text('${_validationResult!.strengthScore}/100'),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: _validationResult!.strengthScore / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getStrengthColor(_validationResult!.strengthLevel),
          ),
        ),
      ],
    );
  }

  Widget _buildChecksList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Validation Checks:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        ..._validationResult!.checks.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(
                  entry.value ? Icons.check : Icons.close,
                  size: 16,
                  color: entry.value ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(_formatCheckName(entry.key)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildErrorsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Errors:',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 4),
        ..._validationResult!.errors.map((error) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.error, size: 16, color: Colors.red),
                const SizedBox(width: 8),
                Expanded(child: Text(error)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildWarningsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Warnings:',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        const SizedBox(height: 4),
        ..._validationResult!.warnings.map((warning) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.warning, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(child: Text(warning)),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildConfigurationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Language: ${_getLanguageName(_selectedLanguage)}'),
        Text('Custom Messages: ${_useCustomMessages ? "Enabled" : "Disabled"}'),
        Text('Current Language Code: $_selectedLanguage'),
        const SizedBox(height: 8),
        const Text(
          'Validation Rules:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('Min Length: ${_selectedRules.minLength}'),
        Text('Max Length: ${_selectedRules.maxLength}'),
        Text('Require Uppercase: ${_selectedRules.requireUppercase}'),
        Text('Require Lowercase: ${_selectedRules.requireLowercase}'),
        Text('Require Numbers: ${_selectedRules.requireNumbers}'),
        Text('Require Special Chars: ${_selectedRules.requireSpecialChars}'),
        Text('Allow Spaces: ${_selectedRules.allowSpaces}'),
        Text('Check Common Passwords: ${_selectedRules.checkCommonPasswords}'),
        Text('Check Repeated Chars: ${_selectedRules.checkRepeatedChars}'),
        Text('Max Repeated Chars: ${_selectedRules.maxRepeatedChars}'),
        Text('Check Sequential Chars: ${_selectedRules.checkSequentialChars}'),
        Text('Max Sequential Length: ${_selectedRules.maxSequentialLength}'),
      ],
    );
  }

  Widget _buildLanguageDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Try these weak passwords to see different language messages:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildLanguageExample('en', 'short', 'English'),
        _buildLanguageExample('es', 'corto', 'Spanish'),
        _buildLanguageExample('fr', 'court', 'French'),
        _buildLanguageExample('de', 'kurz', 'German'),
        _buildLanguageExample('pt', 'curto', 'Portuguese'),
        _buildLanguageExample('it', 'corto', 'Italian'),
        _buildLanguageExample('fa', 'کوتاه', 'Persian'),
      ],
    );
  }

  Widget _buildLanguageExample(String languageCode, String password, String languageName) {
    final demoChecker = PasswordChecker(language: languageCode);
    final result = demoChecker.validate(password);
    final firstError = result.errors.isNotEmpty ? result.errors.first : 'Valid';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$languageName: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              firstError,
              style: TextStyle(
                color: result.isValid ? Colors.green : Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en': return '🇺🇸 English';
      case 'es': return '🇪🇸 Español';
      case 'fr': return '🇫🇷 Français';
      case 'de': return '🇩🇪 Deutsch';
      case 'pt': return '🇵🇹 Português';
      case 'it': return '🇮🇹 Italiano';
      case 'fa': return '🇮🇷 فارسی';
      default: return '🇺🇸 English';
    }
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
        return Colors.lightGreen;
      case PasswordStrengthLevel.veryStrong:
        return Colors.green;
    }
  }

  String _formatCheckName(String check) {
    switch (check) {
      case 'minLength':
        return 'Minimum Length';
      case 'maxLength':
        return 'Maximum Length';
      case 'uppercase':
        return 'Uppercase Letters';
      case 'lowercase':
        return 'Lowercase Letters';
      case 'numbers':
        return 'Numbers';
      case 'specialChars':
        return 'Special Characters';
      case 'noSpaces':
        return 'No Spaces';
      case 'notCommon':
        return 'Not Common Password';
      case 'noRepeatedChars':
        return 'No Repeated Characters';
      case 'noSequentialChars':
        return 'No Sequential Characters';
      default:
        return check;
    }
  }
}
