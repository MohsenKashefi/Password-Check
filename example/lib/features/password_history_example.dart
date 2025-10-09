import 'package:flutter/material.dart';
import 'package:password_checker_pro/password_checker_pro.dart';

/// Example demonstrating password history tracking features
class PasswordHistoryExample extends StatefulWidget {
  const PasswordHistoryExample({super.key});

  @override
  State<PasswordHistoryExample> createState() => _PasswordHistoryExampleState();
}

class _PasswordHistoryExampleState extends State<PasswordHistoryExample> {
  final _passwordController = TextEditingController();
  late PasswordChecker _checker;
  PasswordValidationResult? _validationResult;
  PasswordHistoryResult? _historyResult;
  
  // History configuration
  int _maxHistoryLength = 5;
  double _similarityThreshold = 0.8;
  ComparisonMethod _comparisonMethod = ComparisonMethod.similarity;

  @override
  void initState() {
    super.initState();
    _initializeChecker();
    _passwordController.addListener(_validatePassword);
  }

  void _initializeChecker() {
    final config = PasswordHistoryConfig(
      maxLength: _maxHistoryLength,
      similarityThreshold: _similarityThreshold,
      method: _comparisonMethod,
      enableSuggestions: true,
      enableMetadata: true,
    );
    
    _checker = PasswordChecker.strong().withHistory(config);
  }

  void _validatePassword() {
    if (_passwordController.text.isNotEmpty) {
      setState(() {
        _validationResult = _checker.validate(_passwordController.text);
        if (_checker.history != null) {
          _historyResult = _checker.history!.checkPassword(_passwordController.text);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password History'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📚 Password History Tracking',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Prevent password reuse with configurable history tracking, similarity detection, and security recommendations.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // History Configuration
            _buildHistoryConfiguration(),
            const SizedBox(height: 24),
            
            // Password Input
            _buildPasswordInput(),
            const SizedBox(height: 24),
            
            // History Status
            if (_historyResult != null) _buildHistoryStatus(),
            const SizedBox(height: 24),
            
            // Add to History Button
            _buildHistoryActions(),
            const SizedBox(height: 24),
            
            // Current History Display
            _buildHistoryDisplay(),
            const SizedBox(height: 24),
            
            // History Features
            _buildHistoryFeatures(),
            const SizedBox(height: 24),
            
            // Demo Scenarios
            _buildDemoScenarios(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryConfiguration() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'History Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Max History Length
            Row(
              children: [
                const Text('Max History Length:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: _maxHistoryLength.toDouble(),
                    min: 3,
                    max: 20,
                    divisions: 17,
                    label: _maxHistoryLength.toString(),
                    onChanged: (value) {
                      setState(() {
                        _maxHistoryLength = value.round();
                      });
                      _initializeChecker();
                    },
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    _maxHistoryLength.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Similarity Threshold
            Row(
              children: [
                const Text('Similarity Threshold:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 16),
                Expanded(
                  child: Slider(
                    value: _similarityThreshold,
                    min: 0.5,
                    max: 1.0,
                    divisions: 10,
                    label: '${(_similarityThreshold * 100).round()}%',
                    onChanged: (value) {
                      setState(() {
                        _similarityThreshold = value;
                      });
                      _initializeChecker();
                    },
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    '${(_similarityThreshold * 100).round()}%',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Comparison Method
            Row(
              children: [
                const Text('Comparison Method:', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<ComparisonMethod>(
                    value: _comparisonMethod,
                    isExpanded: true,
                    items: ComparisonMethod.values.map((method) {
                      return DropdownMenuItem(
                        value: method,
                        child: Text(_getMethodDisplayName(method)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _comparisonMethod = value;
                        });
                        _initializeChecker();
                      }
                    },
                  ),
                ),
              ],
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
            const Text(
              'Password Input',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Enter Password',
                border: OutlineInputBorder(),
                hintText: 'Try: MyPassword123!, then MyPassword124!',
              ),
            ),
            const SizedBox(height: 12),
            
            if (_validationResult != null) ...[
              Row(
                children: [
                  Icon(
                    _validationResult!.isValid ? Icons.check_circle : Icons.error,
                    color: _validationResult!.isValid ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Strength: ${_validationResult!.strengthDisplay} (${_validationResult!.strengthScore}/100)',
                    style: TextStyle(
                      color: _getStrengthColor(_validationResult!.strengthScore),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'History Check Result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            if (_historyResult!.isRejected) ...[
              // Rejected
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.block, color: Colors.red.shade600),
                        const SizedBox(width: 8),
                        const Text(
                          'Password Rejected',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _historyResult!.reason ?? 'Password conflicts with history',
                      style: const TextStyle(color: Colors.red),
                    ),
                    
                    if (_historyResult!.similarityScore != null) ...[
                      const SizedBox(height: 12),
                      Text('Similarity Score: ${(_historyResult!.similarityScore! * 100).round()}%'),
                      LinearProgressIndicator(
                        value: _historyResult!.similarityScore!,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ],
                    
                    if (_historyResult!.mostSimilarPassword != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Most Similar: ${_historyResult!.mostSimilarPassword}',
                        style: const TextStyle(fontFamily: 'monospace'),
                      ),
                    ],
                    
                    if (_historyResult!.lastUsed != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Last Used: ${_formatDate(_historyResult!.lastUsed!)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Suggestions
              if (_historyResult!.suggestions.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Suggestions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._historyResult!.suggestions.map((suggestion) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, size: 16, color: Colors.orange),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            suggestion,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _passwordController.text = suggestion;
                          },
                          icon: const Icon(Icons.arrow_forward, size: 16),
                          tooltip: 'Use this suggestion',
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ] else ...[
              // Accepted
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    const Text(
                      'Password Accepted - No conflicts with history',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
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

  Widget _buildHistoryActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'History Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _validationResult?.isValid == true && 
                               _historyResult?.isRejected == false
                        ? _addToHistory
                        : null,
                    icon: const Icon(Icons.add),
                    label: const Text('Add to History'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearHistory,
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Clear History'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryDisplay() {
    final history = _checker.history?.history ?? [];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Password History (${history.length}/$_maxHistoryLength)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            if (history.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'No passwords in history yet. Add some passwords to see history tracking in action.',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Column(
                children: history.asMap().entries.map((entry) {
                  final index = entry.key;
                  final historyEntry = entry.value;
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.indigo.shade50,
                        border: Border.all(color: Colors.indigo.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hash: ${historyEntry.hash.substring(0, 16)}...',
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Added: ${_formatDate(historyEntry.createdAt)}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.lock,
                            color: Colors.indigo.shade400,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryFeatures() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'History Features',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureItem(
              '🔒 Secure Storage',
              'Passwords are hashed before storage - originals never saved',
            ),
            _buildFeatureItem(
              '📊 Similarity Detection',
              'Uses Levenshtein distance to detect similar passwords',
            ),
            _buildFeatureItem(
              '⚙️ Configurable Rules',
              'Adjust history length, similarity threshold, and comparison methods',
            ),
            _buildFeatureItem(
              '💡 Smart Suggestions',
              'Automatic suggestions when passwords are too similar',
            ),
            _buildFeatureItem(
              '📱 Persistence Ready',
              'JSON serialization for saving/loading history across sessions',
            ),
            _buildFeatureItem(
              '🔄 Rolling History',
              'Automatically removes oldest entries when limit is reached',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemoScenarios() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Demo Scenarios',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildScenarioButton(
              'Scenario 1: Exact Reuse',
              'Add "MyPassword123!" then try it again',
              () => _runScenario(['MyPassword123!', 'MyPassword123!']),
            ),
            const SizedBox(height: 8),
            _buildScenarioButton(
              'Scenario 2: Similar Passwords',
              'Add "MyPassword123!" then try "MyPassword124!"',
              () => _runScenario(['MyPassword123!', 'MyPassword124!']),
            ),
            const SizedBox(height: 8),
            _buildScenarioButton(
              'Scenario 3: Different Passwords',
              'Add "MyPassword123!" then try "CompletelyDifferent456@"',
              () => _runScenario(['MyPassword123!', 'CompletelyDifferent456@']),
            ),
            const SizedBox(height: 8),
            _buildScenarioButton(
              'Scenario 4: Fill History',
              'Add multiple passwords to see rolling history',
              () => _runScenario([
                'Password1!',
                'Password2@',
                'Password3#',
                'Password4\$',
                'Password5%',
                'Password6^',
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioButton(String title, String description, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade50,
          foregroundColor: Colors.indigo.shade700,
          padding: const EdgeInsets.all(16),
          alignment: Alignment.centerLeft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _addToHistory() {
    if (_passwordController.text.isNotEmpty) {
      _checker.addToHistory(_passwordController.text);
      setState(() {
        // Refresh the display
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password added to history!')),
      );
    }
  }

  void _clearHistory() {
    _checker.clearHistory();
    setState(() {
      _historyResult = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('History cleared!')),
    );
  }

  void _runScenario(List<String> passwords) async {
    _clearHistory();
    
    for (int i = 0; i < passwords.length; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      _passwordController.text = passwords[i];
      
      if (i < passwords.length - 1) {
        // Add to history (except for the last one to show the check)
        if (_validationResult?.isValid == true && _historyResult?.isRejected == false) {
          _addToHistory();
        }
      }
    }
  }

  String _getMethodDisplayName(ComparisonMethod method) {
    switch (method) {
      case ComparisonMethod.exactHash:
        return 'Exact Hash Match';
      case ComparisonMethod.similarity:
        return 'Similarity Detection';
      case ComparisonMethod.fuzzyMatch:
        return 'Fuzzy Matching';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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
