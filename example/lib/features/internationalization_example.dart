import 'package:flutter/material.dart';
import 'package:password_check/password_check.dart';

/// Example demonstrating internationalization (i18n) features
class InternationalizationExample extends StatefulWidget {
  const InternationalizationExample({Key? key}) : super(key: key);

  @override
  State<InternationalizationExample> createState() => _InternationalizationExampleState();
}

class _InternationalizationExampleState extends State<InternationalizationExample> {
  final _passwordController = TextEditingController();
  late PasswordChecker _checker;
  late PasswordGenerator _generator;
  PasswordValidationResult? _result;
  String _selectedLanguage = 'en';
  bool _useCustomMessages = false;

  final Map<String, String> _languageNames = {
    'en': '🇺🇸 English',
    'es': '🇪🇸 Español',
    'fr': '🇫🇷 Français',
    'de': '🇩🇪 Deutsch',
    'pt': '🇵🇹 Português',
    'it': '🇮🇹 Italiano',
    'fa': '🇮🇷 فارسی',
  };

  final Map<String, List<String>> _testPasswords = {
    'en': ['short', 'password123', 'MySecurePassword123!'],
    'es': ['corto', 'contraseña123', 'MiContraseñaSegura123!'],
    'fr': ['court', 'motdepasse123', 'MonMotDePasseSécurisé123!'],
    'de': ['kurz', 'passwort123', 'MeinSicheresPasswort123!'],
    'pt': ['curto', 'senha123', 'MinhaSenhaSegura123!'],
    'it': ['corto', 'password123', 'LaMiaPasswordSicura123!'],
    'fa': ['کوتاه', 'رمزعبور۱۲۳', 'رمزعبورامن۱۲۳!'],
  };

  @override
  void initState() {
    super.initState();
    _updateLanguage();
    _passwordController.addListener(_validatePassword);
  }

  void _updateLanguage() {
    setState(() {
      if (_useCustomMessages) {
        final customMessages = _getCustomMessages();
        _checker = PasswordChecker.strong(
          language: _selectedLanguage,
          customMessages: customMessages,
        );
        _generator = PasswordGenerator.strong();
      } else {
        _checker = PasswordChecker.strong(language: _selectedLanguage);
        _generator = PasswordGenerator.strong();
      }
    });
    _validatePassword();
  }

  void _validatePassword() {
    if (_passwordController.text.isNotEmpty) {
      setState(() {
        _result = _checker.validate(_passwordController.text);
      });
    }
  }

  CustomMessages _getCustomMessages() {
    return CustomMessages.fromMap({
      'minLength': '🔒 Password must be at least {min} characters long',
      'requireUppercase': '🔤 Add uppercase letters (A-Z)',
      'requireLowercase': '🔡 Add lowercase letters (a-z)',
      'requireNumbers': '🔢 Add numbers (0-9)',
      'requireSpecialChars': '🔣 Add special characters (!@#\$%^&*)',
      'commonPassword': '⚠️ This is a commonly used password',
      'repeatedChars': '🔄 Too many repeated characters',
      'sequentialChars': '📈 Avoid sequential characters',
      'veryWeak': '💀 Very Weak',
      'weak': '😟 Weak',
      'fair': '😐 Fair',
      'good': '😊 Good',
      'strong': '💪 Strong',
      'veryStrong': '🚀 Very Strong',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internationalization'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🌍 Internationalization (i18n)',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Multi-language support with 7 languages including Persian. Test validation messages in different languages.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            
            // Language Selection
            _buildLanguageSelection(),
            const SizedBox(height: 24),
            
            // Custom Messages Toggle
            _buildCustomMessagesToggle(),
            const SizedBox(height: 24),
            
            // Password Input
            _buildPasswordInput(),
            const SizedBox(height: 24),
            
            // Quick Test Buttons
            _buildQuickTestButtons(),
            const SizedBox(height: 24),
            
            // Validation Results
            if (_result != null) _buildValidationResults(),
            const SizedBox(height: 24),
            
            // Language Comparison
            _buildLanguageComparison(),
            const SizedBox(height: 24),
            
            // Language Features
            _buildLanguageFeatures(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language Selection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: const InputDecoration(
                labelText: 'Select Language',
                border: OutlineInputBorder(),
              ),
              items: _languageNames.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLanguage = value;
                  });
                  _updateLanguage();
                }
              },
            ),
            const SizedBox(height: 12),
            
            Text(
              'Current Language: ${_languageNames[_selectedLanguage]}',
              style: TextStyle(
                color: Colors.teal.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomMessagesToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Messages',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            SwitchListTile(
              title: const Text('Use Custom Messages'),
              subtitle: const Text('Override default translations with custom messages'),
              value: _useCustomMessages,
              onChanged: (value) {
                setState(() {
                  _useCustomMessages = value;
                });
                _updateLanguage();
              },
            ),
            
            if (_useCustomMessages) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '✨ Custom messages with emojis are now active! These override the default translations.',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
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
              decoration: InputDecoration(
                labelText: 'Enter Password',
                border: const OutlineInputBorder(),
                hintText: _getHintText(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTestButtons() {
    final testPasswords = _testPasswords[_selectedLanguage] ?? _testPasswords['en']!;
    
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
            Text(
              'Test with passwords in ${_languageNames[_selectedLanguage]}:',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: testPasswords.map((password) {
                return ElevatedButton(
                  onPressed: () {
                    _passwordController.text = password;
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade50,
                    foregroundColor: Colors.teal.shade700,
                  ),
                  child: Text(password),
                );
              }).toList(),
            ),
          ],
        ),
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
            Text(
              'Validation Results (${_languageNames[_selectedLanguage]})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Status
            Row(
              children: [
                Icon(
                  _result!.isValid ? Icons.check_circle : Icons.error,
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
            const SizedBox(height: 16),
            
            // Strength
            Text('Strength: ${_result!.strengthDisplay}'),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _result!.strengthScore / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _getStrengthColor(_result!.strengthScore),
              ),
            ),
            const SizedBox(height: 16),
            
            // Messages
            if (_result!.errorDisplay != null) ...[
              _buildMessageBox(
                'Error',
                _result!.errorDisplay!,
                Colors.red,
                Icons.error,
              ),
              const SizedBox(height: 12),
            ],
            
            if (_result!.warningDisplay != null) ...[
              _buildMessageBox(
                'Warning',
                _result!.warningDisplay!,
                Colors.orange,
                Icons.warning,
              ),
              const SizedBox(height: 12),
            ],
            
            if (_result!.improvementDisplay != null) ...[
              _buildMessageBox(
                'Improvement Tip',
                _result!.improvementDisplay!,
                Colors.blue,
                Icons.lightbulb,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBox(String title, String message, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageComparison() {
    const testPassword = 'short';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language Comparison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'How "$testPassword" validation appears in different languages:',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            ..._languageNames.entries.map((entry) {
              final checker = PasswordChecker.strong(language: entry.key);
              final result = checker.validate(testPassword);
              
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.value,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        result.errorDisplay ?? 'No error',
                        style: TextStyle(
                          color: result.errorDisplay != null ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageFeatures() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Language Features',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureItem(
              '🌍 7 Supported Languages',
              'English, Spanish, French, German, Portuguese, Italian, Persian',
            ),
            _buildFeatureItem(
              '🎯 Simple API',
              'Just pass language parameter: PasswordChecker.strong(language: "fa")',
            ),
            _buildFeatureItem(
              '✨ Custom Messages',
              'Override any message with CustomMessages for branding',
            ),
            _buildFeatureItem(
              '🔍 Auto Detection',
              'Automatic language detection from system locale',
            ),
            _buildFeatureItem(
              '🇮🇷 Persian Support',
              'Full right-to-left (RTL) language support - unique in Flutter!',
            ),
            _buildFeatureItem(
              '🔄 Dynamic Switching',
              'Change language at runtime without recreating components',
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
              color: Colors.teal,
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

  String _getHintText() {
    switch (_selectedLanguage) {
      case 'es': return 'Ingrese su contraseña';
      case 'fr': return 'Entrez votre mot de passe';
      case 'de': return 'Geben Sie Ihr Passwort ein';
      case 'pt': return 'Digite sua senha';
      case 'it': return 'Inserisci la tua password';
      case 'fa': return 'رمز عبور خود را وارد کنید';
      default: return 'Enter your password';
    }
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
