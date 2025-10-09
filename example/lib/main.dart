 
import 'package:flutter/material.dart';
import 'package:password_checker_pro/password_checker_pro.dart';
import 'features/basic_validation_example.dart';
import 'features/strength_analysis_example.dart';
import 'features/password_generation_example.dart';
import 'features/internationalization_example.dart';
import 'features/password_history_example.dart';
import 'features/advanced_widgets_example.dart';
import 'package:password_checker_pro/src/widgets/password_history_widget.dart';
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Password Check Package Examples',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore different features of the password validation package.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
                children: [
                  _buildExampleCard(
                    context,
                    'Basic Validation',
                    'Core password validation with different rule presets',
                    Icons.security,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BasicValidationExample()),
                    ),
                  ),
                  _buildExampleCard(
                    context,
                    'Strength Analysis',
                    'Comprehensive password strength analysis and scoring',
                    Icons.analytics,
                    Colors.green,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const StrengthAnalysisExample()),
                    ),
                  ),
                  _buildExampleCard(
                    context,
                    'Password Generation',
                    'Secure password generation with customizable rules',
                    Icons.auto_awesome,
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PasswordGenerationExample()),
                    ),
                  ),
                  _buildExampleCard(
                    context,
                    'Internationalization',
                    'Multi-language support with 7 languages including Persian',
                    Icons.language,
                    Colors.teal,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InternationalizationExample()),
                    ),
                  ),
                  _buildExampleCard(
                    context,
                    'Password History',
                    'History tracking with similarity detection and reuse prevention',
                    Icons.history,
                    Colors.indigo,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PasswordHistoryExample()),
                    ),
                  ),
                  _buildExampleCard(
                    context,
                    'Advanced Widgets',
                    'Pre-built UI widgets for password visualization',
                    Icons.widgets,
                    Colors.deepPurple,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdvancedWidgetsExample()),
                    ),
                  ),
                  _buildExampleCard(
                    context,
                    'Complete Demo',
                    'Full-featured demo with all package capabilities',
                    Icons.dashboard,
                    Colors.orange,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PasswordCheckDemo()),
                    ),
                  ),
                  _buildExampleCard(
                    context,
                    'Simple Language',
                    'Basic internationalization example',
                    Icons.translate,
                    Colors.cyan,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SimpleLanguageDemo()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
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
  PasswordHistoryResult? _historyResult;
  bool _historyEnabled = false;

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
      _validationResult = _checker.validate(_passwordController.text);
      if (_historyEnabled && _checker.history != null) {
        _historyResult = _checker.history!.checkPassword(_passwordController.text);
      }
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

  void _toggleHistory() {
    setState(() {
      _historyEnabled = !_historyEnabled;
      if (_historyEnabled) {
        _checker = _checker.withSimpleHistory();
      } else {
        _checker = PasswordChecker.strong(language: 'fa');
      }
      _historyResult = null;
      _validatePassword();
    });
  }

  Future<void> _addToHistory() async {
    if (_historyEnabled && _validationResult?.isValid == true) {
      await _checker.addToHistory(_passwordController.text);
      _validatePassword();
    }
  }

  void _clearHistory() {
    if (_historyEnabled) {
      _checker.clearHistory();
      _validatePassword();
    }
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
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Switch(
                      value: _historyEnabled,
                      onChanged: (_) => _toggleHistory(),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('Enable Password History'),
                    ),
                  ],
                ),
                if (_historyEnabled) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _validationResult?.isValid == true ? _addToHistory : null,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add to History'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generatePassword,
                icon: const Icon(Icons.refresh),
                label: const Text('Generate Strong Password'),
              ),
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
            _buildRequirementsChecklist(),
            const SizedBox(height: 16),
            if (_historyEnabled) ...[
              PasswordHistoryWidget(
                history: _checker.history,
                historyResult: _historyResult,
                onClearHistory: _clearHistory,
              ),
              const SizedBox(height: 16),
            ],
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

  Widget _buildRequirementsChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password Requirements:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildRequirementItem(
          'At least 8 characters',
          _validationResult!.checks['minLength'] ?? false,
        ),
        _buildRequirementItem(
          'Contains uppercase letter',
          _validationResult!.checks['uppercase'] ?? false,
        ),
        _buildRequirementItem(
          'Contains lowercase letter',
          _validationResult!.checks['lowercase'] ?? false,
        ),
        _buildRequirementItem(
          'Contains number',
          _validationResult!.checks['numbers'] ?? false,
        ),
        _buildRequirementItem(
          'Contains special character',
          _validationResult!.checks['specialChars'] ?? false,
        ),
        _buildRequirementItem(
          'No spaces',
          _validationResult!.checks['noSpaces'] ?? false,
        ),
        _buildRequirementItem(
          'Not a common password',
          _validationResult!.checks['notCommon'] ?? false,
        ),
        _buildRequirementItem(
          'No repeated characters',
          _validationResult!.checks['noRepeatedChars'] ?? false,
        ),
        _buildRequirementItem(
          'No sequential characters',
          _validationResult!.checks['noSequentialChars'] ?? false,
        ),
      ],
    );
  }

  Widget _buildRequirementItem(String requirement, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isMet ? Colors.green : Colors.grey[300],
              border: Border.all(
                color: isMet ? Colors.green : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: isMet
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              requirement,
              style: TextStyle(
                fontSize: 14,
                color: isMet ? Colors.green[700] : Colors.grey[600],
                fontWeight: isMet ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationChecks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Technical Details:',
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

