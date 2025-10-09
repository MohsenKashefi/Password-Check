import 'package:flutter/material.dart';
import 'package:password_check/password_check.dart';

/// Example demonstrating advanced UI widgets
class AdvancedWidgetsExample extends StatefulWidget {
  const AdvancedWidgetsExample({super.key});

  @override
  State<AdvancedWidgetsExample> createState() => _AdvancedWidgetsExampleState();
}

class _AdvancedWidgetsExampleState extends State<AdvancedWidgetsExample>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _checker = PasswordChecker.strong();
  final _rules = ValidationRules.strong();
  PasswordValidationResult? _result;
  
  late TabController _tabController;
  
  final List<String> _demoPasswords = [
    'weak',
    'password123',
    'MyPassword123',
    'MyPassword123!',
    'MyVerySecurePassword123!@#',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _passwordController.addListener(_validatePassword);
    // Start with a demo password
    _passwordController.text = 'MyPassword123!';
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
        title: const Text('Advanced Widgets'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'All Widgets'),
            Tab(text: 'Strength Indicator'),
            Tab(text: 'Requirements'),
            Tab(text: 'Strength Meter'),
            Tab(text: 'Suggestions'),
            Tab(text: 'Visualizer'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Password Input (always visible)
          Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Password',
                    border: OutlineInputBorder(),
                    hintText: 'Try different passwords to see widgets in action',
                  ),
                ),
                const SizedBox(height: 12),
                
                // Quick Test Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _demoPasswords.map((password) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            _passwordController.text = password;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple.shade50,
                            foregroundColor: Colors.deepPurple.shade700,
                          ),
                          child: Text(password),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllWidgetsTab(),
                _buildStrengthIndicatorTab(),
                _buildRequirementsTab(),
                _buildStrengthMeterTab(),
                _buildSuggestionsTab(),
                _buildVisualizerTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllWidgetsTab() {
    if (_result == null) {
      return const Center(child: Text('Enter a password to see widgets'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎨 All Advanced Widgets',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete showcase of all available password visualization widgets.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Strength Indicator
          _buildWidgetSection(
            'Password Strength Indicator',
            'Animated progress bar with detailed breakdown and suggestions',
            PasswordStrengthIndicator(
              result: _result!,
              showBreakdown: true,
              showSuggestions: true,
              animated: true,
            ),
          ),
          
          // Requirements Checklist
          _buildWidgetSection(
            'Password Requirements Checklist',
            'Interactive checklist showing password requirements with progress',
            PasswordRequirementsChecklist(
              result: _result!,
              rules: _rules,
              showProgress: true,
              animated: true,
            ),
          ),
          
          // Strength Meter
          _buildWidgetSection(
            'Password Strength Meter',
            'Circular strength meter with animated progress',
            Center(
              child: PasswordStrengthMeter(
                result: _result!,
                size: 120.0,
                animated: true,
                showScore: true,
                showLevel: true,
              ),
            ),
          ),
          
          // Improvement Suggestions
          _buildWidgetSection(
            'Password Improvement Suggestions',
            'Smart suggestions with contextual advice and priority levels',
            PasswordImprovementSuggestions(
              result: _result!,
              rules: _rules,
              showIcons: true,
              showPriority: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStrengthIndicatorTab() {
    if (_result == null) {
      return const Center(child: Text('Enter a password to see the strength indicator'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 Password Strength Indicator',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Comprehensive strength visualization with animated progress, detailed breakdown, and improvement suggestions.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Default Indicator
          _buildVariantCard(
            'Default Configuration',
            'Standard strength indicator with all features enabled',
            PasswordStrengthIndicator(
              result: _result!,
              showBreakdown: true,
              showSuggestions: true,
              animated: true,
            ),
          ),
          
          // Minimal Indicator
          _buildVariantCard(
            'Minimal Configuration',
            'Simple progress bar without breakdown or suggestions',
            PasswordStrengthIndicator(
              result: _result!,
              showBreakdown: false,
              showSuggestions: false,
              animated: true,
            ),
          ),
          
          // Custom Height
          _buildVariantCard(
            'Custom Height',
            'Thicker progress bar for better visibility',
            PasswordStrengthIndicator(
              result: _result!,
              height: 12.0,
              showBreakdown: true,
              showSuggestions: false,
              animated: true,
            ),
          ),
          
          // Features List
          _buildFeaturesCard([
            '📈 Animated progress transitions',
            '🔍 Detailed strength breakdown',
            '💡 Contextual improvement suggestions',
            '🎨 Customizable height and padding',
            '📱 Responsive design',
          ]),
        ],
      ),
    );
  }

  Widget _buildRequirementsTab() {
    if (_result == null) {
      return const Center(child: Text('Enter a password to see requirements'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '✅ Password Requirements Checklist',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Interactive checklist showing password requirements with visual progress tracking and detailed feedback.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // With Progress
          _buildVariantCard(
            'With Progress Indicator',
            'Shows overall progress and completion percentage',
            PasswordRequirementsChecklist(
              result: _result!,
              rules: _rules,
              showProgress: true,
              animated: true,
            ),
          ),
          
          // Without Progress
          _buildVariantCard(
            'Without Progress Indicator',
            'Clean checklist without progress bar',
            PasswordRequirementsChecklist(
              result: _result!,
              rules: _rules,
              showProgress: false,
              animated: true,
            ),
          ),
          
          // Different Rules
          _buildVariantCard(
            'Basic Rules Checklist',
            'Checklist for basic validation rules',
            PasswordRequirementsChecklist(
              result: PasswordChecker.basic().validate(_passwordController.text),
              rules: ValidationRules.basic(),
              showProgress: true,
              animated: true,
            ),
          ),
          
          // Features List
          _buildFeaturesCard([
            '✅ Real-time requirement checking',
            '📊 Progress tracking with percentage',
            '🎯 Clear pass/fail indicators',
            '📝 Detailed requirement descriptions',
            '🔄 Smooth animations on updates',
          ]),
        ],
      ),
    );
  }

  Widget _buildStrengthMeterTab() {
    if (_result == null) {
      return const Center(child: Text('Enter a password to see the strength meter'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⭕ Password Strength Meter',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Circular strength meter with animated progress, dynamic icons, and customizable display options.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Different Sizes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const Text('Small (80px)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  PasswordStrengthMeter(
                    result: _result!,
                    size: 80.0,
                    animated: true,
                    showScore: true,
                    showLevel: false,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Medium (120px)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  PasswordStrengthMeter(
                    result: _result!,
                    size: 120.0,
                    animated: true,
                    showScore: true,
                    showLevel: true,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Large (160px)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  PasswordStrengthMeter(
                    result: _result!,
                    size: 160.0,
                    animated: true,
                    showScore: true,
                    showLevel: true,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Configuration Options
          _buildVariantCard(
            'Score Only',
            'Display numerical score without level text',
            Center(
              child: PasswordStrengthMeter(
                result: _result!,
                size: 140.0,
                animated: true,
                showScore: true,
                showLevel: false,
              ),
            ),
          ),
          
          _buildVariantCard(
            'Level Only',
            'Display strength level without numerical score',
            Center(
              child: PasswordStrengthMeter(
                result: _result!,
                size: 140.0,
                animated: true,
                showScore: false,
                showLevel: true,
              ),
            ),
          ),
          
          // Features List
          _buildFeaturesCard([
            '⭕ Circular progress indicator',
            '🎨 Dynamic color coding',
            '🔢 Optional score display',
            '📝 Optional level text',
            '🎭 Strength-based icons',
            '📏 Customizable size',
          ]),
        ],
      ),
    );
  }

  Widget _buildSuggestionsTab() {
    if (_result == null) {
      return const Center(child: Text('Enter a password to see suggestions'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💡 Password Improvement Suggestions',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Smart contextual suggestions with priority levels, icons, and practical examples for password improvement.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Full Features
          _buildVariantCard(
            'Full Features',
            'Complete suggestions with icons and priority indicators',
            PasswordImprovementSuggestions(
              result: _result!,
              rules: _rules,
              showIcons: true,
              showPriority: true,
            ),
          ),
          
          // No Icons
          _buildVariantCard(
            'Without Icons',
            'Clean text-only suggestions',
            PasswordImprovementSuggestions(
              result: _result!,
              rules: _rules,
              showIcons: false,
              showPriority: true,
            ),
          ),
          
          // No Priority
          _buildVariantCard(
            'Without Priority Badges',
            'Suggestions without priority indicators',
            PasswordImprovementSuggestions(
              result: _result!,
              rules: _rules,
              showIcons: true,
              showPriority: false,
            ),
          ),
          
          // Test with weak password
          if (_result!.strengthScore > 60) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blue.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '💡 Tip: Try a weaker password like "password123" to see more improvement suggestions!',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
          
          // Features List
          _buildFeaturesCard([
            '🎯 Contextual advice based on validation results',
            '🏷️ Priority levels (High, Medium, Low)',
            '🎨 Visual icons for different suggestion types',
            '📝 Practical examples and explanations',
            '🔄 Dynamic updates based on password changes',
          ]),
        ],
      ),
    );
  }

  Widget _buildVisualizerTab() {
    if (_result == null) {
      return const Center(child: Text('Enter a password to see the visualizer'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎭 Password Visualizer',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Comprehensive visualization combining all widgets in an organized tabbed interface.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Full Visualizer
          _buildVariantCard(
            'Complete Visualizer',
            'All visualization components in a tabbed interface',
            PasswordVisualizer(
              result: _result!,
              rules: _rules,
              animated: true,
            ),
          ),
          
          // Custom Configuration
          _buildVariantCard(
            'Custom Configuration',
            'Selective display of visualization components',
            PasswordVisualizer(
              result: _result!,
              rules: _rules,
              showMeter: true,
              showIndicator: true,
              showChecklist: false,
              showSuggestions: true,
              animated: true,
            ),
          ),
          
          // Features List
          _buildFeaturesCard([
            '📑 Tabbed interface for organized display',
            '🎨 All widgets in one comprehensive view',
            '⚙️ Configurable component visibility',
            '📱 Responsive design for all screen sizes',
            '🔄 Synchronized animations across components',
            '🎯 Complete password security assessment',
          ]),
        ],
      ),
    );
  }

  Widget _buildWidgetSection(String title, String description, Widget widget) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: widget,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildVariantCard(String title, String description, Widget widget) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 16),
            widget,
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard(List<String> features) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Key Features',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...features.map((feature) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
