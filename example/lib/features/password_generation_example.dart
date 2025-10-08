import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_check/password_check.dart';

/// Example demonstrating password generation features
class PasswordGenerationExample extends StatefulWidget {
  const PasswordGenerationExample({Key? key}) : super(key: key);

  @override
  State<PasswordGenerationExample> createState() => _PasswordGenerationExampleState();
}

class _PasswordGenerationExampleState extends State<PasswordGenerationExample> {
  late PasswordGenerator _generator;
  late PasswordChecker _checker;
  String _generatedPassword = '';
  PasswordValidationResult? _validationResult;
  
  // Custom generation settings
  int _length = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSpecialChars = true;
  bool _avoidSimilarChars = true;
  bool _ensureVariety = true;

  @override
  void initState() {
    super.initState();
    _generator = PasswordGenerator.strong();
    _checker = PasswordChecker.strong();
    _generatePassword();
  }

  void _generatePassword() {
    final rules = GenerationRules(
      length: _length,
      includeUppercase: _includeUppercase,
      includeLowercase: _includeLowercase,
      includeNumbers: _includeNumbers,
      includeSpecialChars: _includeSpecialChars,
      avoidSimilarChars: _avoidSimilarChars,
      ensureCharacterVariety: _ensureVariety,
    );
    
    final customGenerator = PasswordGenerator(rules: rules);
    final result = customGenerator.generate();
    
    setState(() {
      _generatedPassword = result.password;
      _validationResult = _checker.validate(_generatedPassword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generation'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔑 Secure Password Generation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Generate cryptographically secure passwords with customizable rules and presets.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Generated Password Display
            _buildGeneratedPasswordCard(),
            const SizedBox(height: 24),
            
            // Generation Presets
            _buildPresetsSection(),
            const SizedBox(height: 24),
            
            // Custom Generation Settings
            _buildCustomSettingsSection(),
            const SizedBox(height: 24),
            
            // Batch Generation
            _buildBatchGenerationSection(),
            const SizedBox(height: 24),
            
            // Generation History
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratedPasswordCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Generated Password',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: _generatePassword,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Generate New Password',
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Password Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      _generatedPassword,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generatedPassword));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Password copied to clipboard!')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy to Clipboard',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Password Analysis
            if (_validationResult != null) ...[
              Row(
                children: [
                  Icon(
                    _validationResult!.isValid ? Icons.check_circle : Icons.warning,
                    color: _validationResult!.isValid ? Colors.green : Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Strength: ${_validationResult!.strengthDisplay} (${_validationResult!.strengthScore}/100)',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: _getStrengthColor(_validationResult!.strengthScore),
                    ),
                  ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildPresetsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generation Presets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildPresetButton(
                    'Basic',
                    'Simple passwords\n8 chars, a-z + 0-9',
                    Colors.blue,
                    () => _usePreset(PasswordGenerator.basic()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPresetButton(
                    'Strong',
                    'Recommended\n16 chars, all types',
                    Colors.green,
                    () => _usePreset(PasswordGenerator.strong()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPresetButton(
                    'Strict',
                    'Maximum security\n20 chars, no similar',
                    Colors.red,
                    () => _usePreset(PasswordGenerator.strict()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetButton(String title, String description, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3)),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Generation Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Length Slider
            Row(
              children: [
                const Text('Length:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: _length.toDouble(),
                    min: 4,
                    max: 50,
                    divisions: 46,
                    label: _length.toString(),
                    onChanged: (value) {
                      setState(() {
                        _length = value.round();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    _length.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Character Type Switches
            _buildSwitchRow('Include Uppercase (A-Z)', _includeUppercase, (value) {
              setState(() => _includeUppercase = value);
            }),
            _buildSwitchRow('Include Lowercase (a-z)', _includeLowercase, (value) {
              setState(() => _includeLowercase = value);
            }),
            _buildSwitchRow('Include Numbers (0-9)', _includeNumbers, (value) {
              setState(() => _includeNumbers = value);
            }),
            _buildSwitchRow('Include Special Characters (!@#\$)', _includeSpecialChars, (value) {
              setState(() => _includeSpecialChars = value);
            }),
            _buildSwitchRow('Avoid Similar Characters (0,O,l,1)', _avoidSimilarChars, (value) {
              setState(() => _avoidSimilarChars = value);
            }),
            _buildSwitchRow('Ensure Character Variety', _ensureVariety, (value) {
              setState(() => _ensureVariety = value);
            }),
            const SizedBox(height: 16),
            
            // Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _generatePassword,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Generate Custom Password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow(String title, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildBatchGenerationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Batch Generation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showBatchGeneration(5),
                    icon: const Icon(Icons.list),
                    label: const Text('Generate 5 Passwords'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showBatchGeneration(10),
                    icon: const Icon(Icons.list_alt),
                    label: const Text('Generate 10 Passwords'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    final history = _generator.history;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Generation History (${history.length})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (history.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _generator.clearHistory();
                      });
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (history.isEmpty)
              const Text(
                'No passwords generated yet. Generate some passwords to see history.',
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                children: history.take(5).map((result) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              result.password,
                              style: const TextStyle(fontFamily: 'monospace'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${result.strengthScore}',
                            style: TextStyle(
                              color: _getStrengthColor(result.strengthScore),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: result.password));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password copied!')),
                              );
                            },
                            icon: const Icon(Icons.copy, size: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            
            if (history.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '... and ${history.length - 5} more',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _usePreset(PasswordGenerator generator) {
    setState(() {
      _generator = generator;
    });
    final result = generator.generate();
    setState(() {
      _generatedPassword = result.password;
      _validationResult = _checker.validate(_generatedPassword);
    });
  }

  void _showBatchGeneration(int count) {
    final passwords = _generator.generateMultiple(count);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Generated $count Passwords'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: passwords.length,
            itemBuilder: (context, index) {
              final result = passwords[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${index + 1}.',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SelectableText(
                          result.password,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${result.strengthScore}',
                        style: TextStyle(
                          color: _getStrengthColor(result.strengthScore),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Color _getStrengthColor(int score) {
    if (score < 20) return Colors.red;
    if (score < 40) return Colors.orange;
    if (score < 60) return Colors.yellow.shade700;
    if (score < 80) return Colors.lightGreen;
    return Colors.green;
  }
}
