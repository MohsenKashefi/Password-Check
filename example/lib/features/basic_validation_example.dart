import 'package:flutter/material.dart';
import 'package:password_check/password_check.dart';

/// Example demonstrating basic password validation functionality
class BasicValidationExample extends StatefulWidget {
  const BasicValidationExample({super.key});

  @override
  State<BasicValidationExample> createState() => _BasicValidationExampleState();
}

class _BasicValidationExampleState extends State<BasicValidationExample> {
  final _passwordController = TextEditingController();
  late PasswordChecker _checker;
  PasswordValidationResult? _result;

  @override
  void initState() {
    super.initState();
    _checker = PasswordChecker.strong();
    _passwordController.addListener(_validatePassword);
  }

  void _validatePassword() {
    setState(() {
      _result = _checker.validate(_passwordController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Password Validation'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔐 Basic Password Validation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'This example demonstrates core password validation with different rule presets.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Password Input
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Enter Password',
                border: OutlineInputBorder(),
                hintText: 'Try: MyPassword123!',
              ),
            ),
            const SizedBox(height: 16),
            
            // Validation Presets Demo
            _buildPresetsDemo(),
            const SizedBox(height: 24),
            
            // Validation Results
            if (_result != null) _buildValidationResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetsDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Validation Presets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            _buildPresetExample('Basic', PasswordChecker.basic()),
            const SizedBox(height: 8),
            _buildPresetExample('Strong', PasswordChecker.strong()),
            const SizedBox(height: 8),
            _buildPresetExample('Strict', PasswordChecker.strict()),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetExample(String name, PasswordChecker checker) {
    final result = _passwordController.text.isNotEmpty 
        ? checker.validate(_passwordController.text)
        : null;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: result != null
                ? Row(
                    children: [
                      Icon(
                        result.isValid ? Icons.check_circle : Icons.error,
                        color: result.isValid ? Colors.green : Colors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          result.isValid 
                              ? 'Valid (${result.strengthScore}/100)'
                              : result.errorDisplay ?? 'Invalid',
                          style: TextStyle(
                            color: result.isValid ? Colors.green : Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Text(
                    'Enter password to see validation',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildValidationResults() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _result!.isValid ? Icons.check_circle : Icons.error,
                  color: _result!.isValid ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _result!.isValid ? 'Password Valid' : 'Password Invalid',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _result!.isValid ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Strength Score
            Text('Strength Score: ${_result!.strengthScore}/100'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _result!.strengthScore / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStrengthColor(_result!.strengthScore),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Level: ${_result!.strengthDisplay}',
              style: TextStyle(
                color: _getStrengthColor(_result!.strengthScore),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            
            // Errors
            if (_result!.errorDisplay != null) ...[
              const Text(
                'Errors:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _result!.errorDisplay!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            // Warnings
            if (_result!.warningDisplay != null) ...[
              const Text(
                'Warnings:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _result!.warningDisplay!,
                  style: const TextStyle(color: Colors.orange),
                ),
              ),
              const SizedBox(height: 12),
            ],
            
            // Improvement Tip
            if (_result!.improvementDisplay != null) ...[
              const Text(
                'Improvement Tip:',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _result!.improvementDisplay!,
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ],
        ),
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

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
