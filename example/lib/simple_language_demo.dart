import 'package:flutter/material.dart';
import 'package:password_checker_pro/password_checker_pro.dart';

/// Simple demo showing the clean, user-friendly language approach.
/// No complex LanguageManager - just simple constructor parameters!
class SimpleLanguageDemo extends StatefulWidget {
  const SimpleLanguageDemo({super.key});

  @override
  State<SimpleLanguageDemo> createState() => _SimpleLanguageDemoState();
}

class _SimpleLanguageDemoState extends State<SimpleLanguageDemo> {
  final _passwordController = TextEditingController();
  late PasswordChecker _checker;
  PasswordValidationResult? _result;
  String _selectedLanguage = 'fa';
  String _generatedPassword = '';

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': '🇺🇸 English'},
    {'code': 'es', 'name': '🇪🇸 Español'},
    {'code': 'fr', 'name': '🇫🇷 Français'},
    {'code': 'de', 'name': '🇩🇪 Deutsch'},
    {'code': 'pt', 'name': '🇵🇹 Português'},
    {'code': 'it', 'name': '🇮🇹 Italiano'},
    {'code': 'fa', 'name': '🇮🇷 فارسی'},
  ];

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
      _result = _checker.validate(_passwordController.text);
    });
  }

  void _changeLanguage(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
      // 🎯 Simple! Just recreate the checker with new language
      _checker = PasswordChecker.strong(language: languageCode);
      _validatePassword(); // Re-validate to get new language messages
    });
  }

  void _generatePassword() {
    setState(() {
      // 🎯 PasswordGenerator doesn't need language - it just generates passwords!
      final generator = PasswordGenerator.strong();
      final result = generator.generate();
      _generatedPassword = result.password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Language Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLanguageSelector(),
            const SizedBox(height: 16),
            _buildPasswordInput(),
            const SizedBox(height: 16),
            _buildPasswordGenerator(),
            const SizedBox(height: 16),
            if (_result != null) _buildValidationResult(),
            const SizedBox(height: 16),
            _buildDemoInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🌍 Language Selection',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Simple approach: Just pass language to PasswordChecker!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: _selectedLanguage,
              isExpanded: true,
              items: _languages.map((lang) {
                return DropdownMenuItem<String>(
                  value: lang['code']!,
                  child: Text(lang['name']!),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  _changeLanguage(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🔐 Password Input',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Enter your password',
                errorText: _result?.isValid == false
                    ? _result!.errorDisplay
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordGenerator() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎲 Password Generator',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No language needed - just generates passwords!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _generatePassword,
              icon: const Icon(Icons.refresh),
              label: const Text('Generate Password'),
            ),
            if (_generatedPassword.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _generatedPassword,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Copy to clipboard functionality would go here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password copied!')),
                        );
                      },
                      icon: const Icon(Icons.copy),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValidationResult() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 Validation Result',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _result!.isValid ? Icons.check_circle : Icons.cancel,
                  color: _result!.isValid ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _result!.isValid ? 'Valid Password' : 'Invalid Password',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _result!.isValid ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Strength: ${_result!.strengthDisplay}',
              style: TextStyle(
                fontSize: 14,
                color: _getStrengthColor(_result!.strengthScore),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: _result!.strengthScore / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStrengthColor(_result!.strengthScore),
              ),
            ),
            if (_result!.errorDisplay != null) ...[
              const SizedBox(height: 12),
              Text(
                'Error:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.error, size: 16, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_result!.errorDisplay!)),
                ],
              ),
            ],
            if (_result!.warningDisplay != null) ...[
              const SizedBox(height: 12),
              Text(
                'Warning:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.warning, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_result!.warningDisplay!)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDemoInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '✨ Simple & Clean Approach',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '🎯 Key Benefits:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('• PasswordChecker.strong(language: "fa") - Simple!'),
            const Text('• PasswordGenerator.strong() - No language needed!'),
            const Text('• No complex LanguageManager to learn'),
            const Text('• Intuitive and user-friendly'),
            const SizedBox(height: 8),
            const Text(
              '🚀 Usage Examples:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '// Simple and clean!\n'
                'final checker = PasswordChecker.strong(language: \'fa\');\n'
                'final generator = PasswordGenerator.strong();\n'
                'final result = checker.validate(\'کوتاه\');\n'
                'final password = generator.generate();',
                style: TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Current Language: $_selectedLanguage',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '💡 Try This:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('1. Enter a weak password like "weak"'),
            const Text('2. Change the language using the dropdown'),
            const Text('3. Watch how error messages change automatically!'),
            const Text('4. Generate a password - no language needed!'),
          ],
        ),
      ),
    );
  }

  Color _getStrengthColor(int strengthScore) {
    if (strengthScore >= 80) return Colors.green;
    if (strengthScore >= 60) return Colors.yellow;
    if (strengthScore >= 40) return Colors.orange;
    return Colors.red;
  }
}
