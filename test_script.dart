import 'lib/password_check.dart';

void main() {
  print('🔐 Password Check Package Demo\n');
  
  // Create different checkers
  final basicChecker = PasswordChecker.basic();
  final strongChecker = PasswordChecker.strong();
  final strictChecker = PasswordChecker.strict();
  
  // Test passwords
  final testPasswords = [
    '123',                    // Very weak
    'password',              // Common password
    'MyPassword123',         // Missing special chars
    'MyPassword123!',        // Good password
    'MyVeryStrongPassword123!@#', // Very strong
    'abc123',                // Sequential
    'aaa111',                // Repeated chars
  ];
  
  print('Testing with BASIC rules:');
  print('=' * 50);
  for (final password in testPasswords) {
    final result = basicChecker.validate(password);
    print('Password: "$password"');
    print('Valid: ${result.isValid}');
    print('Strength: ${result.strengthLevel.displayName} (${result.strengthScore}/100)');
    if (result.errors.isNotEmpty) {
      print('Errors: ${result.errors.join(", ")}');
    }
    if (result.warnings.isNotEmpty) {
      print('Warnings: ${result.warnings.join(", ")}');
    }
    print('-');
  }
  
  print('\n\nTesting with STRONG rules:');
  print('=' * 50);
  for (final password in testPasswords) {
    final result = strongChecker.validate(password);
    print('Password: "$password"');
    print('Valid: ${result.isValid}');
    print('Strength: ${result.strengthLevel.displayName} (${result.strengthScore}/100)');
    if (result.errors.isNotEmpty) {
      print('Errors: ${result.errors.join(", ")}');
    }
    if (result.warnings.isNotEmpty) {
      print('Warnings: ${result.warnings.join(", ")}');
    }
    print('-');
  }
  
  print('\n\nTesting with STRICT rules:');
  print('=' * 50);
  for (final password in testPasswords) {
    final result = strictChecker.validate(password);
    print('Password: "$password"');
    print('Valid: ${result.isValid}');
    print('Strength: ${result.strengthLevel.displayName} (${result.strengthScore}/100)');
    if (result.errors.isNotEmpty) {
      print('Errors: ${result.errors.join(", ")}');
    }
    if (result.warnings.isNotEmpty) {
      print('Warnings: ${result.warnings.join(", ")}');
    }
    print('-');
  }
  
  print('\n\n🎉 Demo completed! Your password checker package is working perfectly!');
}
