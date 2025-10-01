
import 'package:flutter/material.dart';
import 'package:password_check/password_check.dart';
import 'simple_language_demo.dart';

void main() {
  runApp(const PasswordCheckApp());
}

class PasswordCheckApp extends StatelessWidget {
  const PasswordCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Check Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Check Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose an Example:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PasswordCheckDemo()),
                );
              },
              icon: const Icon(Icons.security),
              label: const Text('Advanced Password Demo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SimpleLanguageDemo()),
                );
              },
              icon: const Icon(Icons.language),
              label: const Text('Simple Language Demo'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordCheckDemo extends StatefulWidget {
  const PasswordCheckDemo({super.key});

  @override
  State<PasswordCheckDemo> createState() => _PasswordCheckDemoState();
}

class _PasswordCheckDemoState extends State<PasswordCheckDemo> {
  final _passwordController = TextEditingController();
  late PasswordChecker _checker;
  late PasswordGenerator _generator;
  
  PasswordValidationResult? _validationResult;
  String _generatedPassword = '';

  @override
  void initState() {
    super.initState();
    // Simple language support - just pass language to PasswordChecker
    _checker = PasswordChecker.strong(language: 'fa');
    _generator = PasswordGenerator.strong(); // No language needed for generator
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    setState(() {
      _validationResult = _checker.validate(_passwordController.text );
    });
  }

  void _generatePassword() {
    setState(() {
      final result = _generator.generate();
      _generatedPassword = result.password;
      _passwordController.text = result.password;
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPasswordInput(),
            const SizedBox(height: 24),
            _buildPasswordGeneration(),
            const SizedBox(height: 24),
            if (_validationResult != null) _buildValidationResult(),
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
            const Text(
              'Password Validation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Enter password',
                border: OutlineInputBorder(),
                hintText: 'Type your password here...',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordGeneration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Password Generation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _generatePassword,
              icon: const Icon(Icons.refresh),
              label: const Text('Generate Strong Password'),
            ),
            if (_generatedPassword.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[50],
                ),
                child: SelectableText(
                  _generatedPassword,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
            const Text(
              'Validation Result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildValidationStatus(),
            const SizedBox(height: 16),
            _buildStrengthIndicator(),
            const SizedBox(height: 16),
            _buildValidationChecks(),
          ],
        ),
      ),
    );
  }

  Widget _buildValidationStatus() {
    return Row(
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
    );
  }

  Widget _buildStrengthIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Strength: ${_validationResult!.strengthDisplay}'),
            Text('${_validationResult!.strengthScore}/100'),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: _validationResult!.strengthScore / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            _getStrengthColor(_validationResult!.strengthScore),
          ),
        ),
      ],
    );
  }

  Widget _buildValidationChecks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Validation Checks:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
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
        }),
        if (_validationResult!.errorDisplay != null) ...[
          const SizedBox(height: 12),
          const Text(
            'Error:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.error, size: 16, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(child: Text(_validationResult!.errorDisplay!)),
            ],
          ),
        ],
        if (_validationResult!.warningDisplay != null) ...[
          const SizedBox(height: 12),
          const Text(
            'Warning:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.warning, size: 16, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(child: Text(_validationResult!.warningDisplay!)),
            ],
          ),
        ],
      ],
    );
  }

  Color _getStrengthColor(int strengthScore) {
    if (strengthScore >= 80) return Colors.green;
    if (strengthScore >= 60) return Colors.yellow;
    if (strengthScore >= 40) return Colors.orange;
    return Colors.red;
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

