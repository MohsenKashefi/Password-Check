import 'package:flutter/material.dart';
import 'package:password_checker_pro/password_checker_pro.dart';

/// Example demonstrating password strength analysis features
class StrengthAnalysisExample extends StatefulWidget {
  const StrengthAnalysisExample({super.key});

  @override
  State<StrengthAnalysisExample> createState() => _StrengthAnalysisExampleState();
}

class _StrengthAnalysisExampleState extends State<StrengthAnalysisExample> {
  final _passwordController = TextEditingController();
  final _checker = PasswordChecker.strong();
  PasswordValidationResult? _result;

  final List<String> _testPasswords = [
    '123',
    'password',
    'Password1',
    'MyPassword123',
    'MyPassword123!',
    'MyVerySecurePassword123!@#',
    'Tr0ub4dor&3',
    'correcthorsebatterystaple',
  ];

  @override
  void initState() {
    super.initState();
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
        title: const Text('Strength Analysis'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Password Strength Analysis',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Comprehensive analysis of password strength with detailed scoring and feedback.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Password Input
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Enter Password for Analysis',
                border: OutlineInputBorder(),
                hintText: 'Try different passwords to see analysis',
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick Test Buttons
            _buildQuickTestButtons(),
            const SizedBox(height: 24),
            
            // Strength Analysis Results
            if (_result != null) _buildStrengthAnalysis(),
            const SizedBox(height: 24),
            
            // Comparison Table
            _buildComparisonTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTestButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Test Passwords',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _testPasswords.map((password) {
                return ElevatedButton(
                  onPressed: () {
                    _passwordController.text = password;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                    foregroundColor: Colors.blue.shade700,
                  ),
                  child: Text(
                    password.length > 15 ? '${password.substring(0, 15)}...' : password,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detailed Strength Analysis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Overall Score
            _buildScoreSection(),
            const SizedBox(height: 20),
            
            // Requirements Breakdown
            _buildRequirementsBreakdown(),
            const SizedBox(height: 20),
            
            // Vulnerabilities Analysis
            _buildVulnerabilitiesAnalysis(),
            const SizedBox(height: 20),
            
            // Complexity Rating
            _buildComplexityRating(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreSection() {
    final score = _result!.strengthScore;
    final color = _getStrengthColor(score);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Score',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              '$score/100',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: score / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _result!.strengthDisplay,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            Text(
              _getScoreDescription(score),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRequirementsBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Requirements Analysis',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        ..._result!.requirements.map((requirement) {
          // Simple requirement display - just show the requirement text
          final isMet = _result!.strengthScore > 60; // Simple heuristic
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  isMet ? Icons.check_circle : Icons.cancel,
                  color: isMet ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    requirement,
                    style: TextStyle(
                      color: isMet ? Colors.green : Colors.red,
                    ),
                  ),
                ),
                if (isMet)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '+10',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildVulnerabilitiesAnalysis() {
    if (_result!.vulnerabilities.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vulnerabilities',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade200),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.security, color: Colors.green.shade600),
                const SizedBox(width: 8),
                const Text(
                  'No vulnerabilities detected',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vulnerabilities',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        ..._result!.vulnerabilities.map((vulnerability) {
          // Simple vulnerability display - just show the vulnerability text
          final severity = 'medium'; // Default severity
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getSeverityColor(severity).withOpacity(0.1),
                border: Border.all(color: _getSeverityColor(severity).withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    _getSeverityIcon(severity),
                    color: _getSeverityColor(severity),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vulnerability,
                          style: TextStyle(
                            color: _getSeverityColor(severity),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Impact: Security risk',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(severity),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      severity.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildComplexityRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Complexity Analysis',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border.all(color: Colors.blue.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Complexity Rating: ${_result!.complexityRating}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _result!.strengthDescription,
                style: TextStyle(
                  color: Colors.blue.shade600,
                ),
              ),
              if (_result!.improvementDisplay != null) ...[
                const SizedBox(height: 12),
                const Text(
                  'Improvement Suggestion:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  _result!.improvementDisplay!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonTable() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Password Strength Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.grey.shade300),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1.5),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Password', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Score', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Level', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                ..._testPasswords.map((password) {
                  final result = _checker.validate(password);
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          password.length > 20 ? '${password.substring(0, 20)}...' : password,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${result.strengthScore}',
                          style: TextStyle(
                            color: _getStrengthColor(result.strengthScore),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          result.strengthDisplay,
                          style: TextStyle(
                            color: _getStrengthColor(result.strengthScore),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
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

  String _getScoreDescription(int score) {
    if (score < 20) return 'Very Weak';
    if (score < 40) return 'Weak';
    if (score < 60) return 'Fair';
    if (score < 80) return 'Good';
    return 'Excellent';
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high': return Colors.red;
      case 'medium': return Colors.orange;
      case 'low': return Colors.yellow.shade700;
      default: return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'high': return Icons.error;
      case 'medium': return Icons.warning;
      case 'low': return Icons.info;
      default: return Icons.help;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
