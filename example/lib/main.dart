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

  @override
  void initState() {
    super.initState();
    _checker = PasswordChecker.strong();
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
      _checker = PasswordChecker(rules: rules);
      _validatePassword();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Check Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
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
                      'Current Rules',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildRulesInfo(),
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
            Text('Strength: ${_validationResult!.strengthLevel.displayName}'),
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

  Widget _buildRulesInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
