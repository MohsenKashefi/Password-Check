/// Internationalization support for password validation messages.
class PasswordMessages {
  final String minLength;
  final String maxLength;
  final String requireUppercase;
  final String requireLowercase;
  final String requireNumbers;
  final String requireSpecialChars;
  final String noSpaces;
  final String notCommon;
  final String noRepeatedChars;
  final String noSequentialChars;
  final String veryWeak;
  final String weak;
  final String fair;
  final String good;
  final String strong;
  final String veryStrong;

  const PasswordMessages({
    required this.minLength,
    required this.maxLength,
    required this.requireUppercase,
    required this.requireLowercase,
    required this.requireNumbers,
    required this.requireSpecialChars,
    required this.noSpaces,
    required this.notCommon,
    required this.noRepeatedChars,
    required this.noSequentialChars,
    required this.veryWeak,
    required this.weak,
    required this.fair,
    required this.good,
    required this.strong,
    required this.veryStrong,
  });

  /// English messages (default)
  static const PasswordMessages english = PasswordMessages(
    minLength: 'Password must be at least {min} characters long',
    maxLength: 'Password must be no more than {max} characters long',
    requireUppercase: 'Password must contain at least one uppercase letter',
    requireLowercase: 'Password must contain at least one lowercase letter',
    requireNumbers: 'Password must contain at least one number',
    requireSpecialChars: 'Password must contain at least one special character',
    noSpaces: 'Password cannot contain spaces',
    notCommon: 'Password is too common and easily guessable',
    noRepeatedChars: 'Password contains too many repeated characters',
    noSequentialChars: 'Password contains sequential characters',
    veryWeak: 'Very Weak',
    weak: 'Weak',
    fair: 'Fair',
    good: 'Good',
    strong: 'Strong',
    veryStrong: 'Very Strong',
  );

  /// Spanish messages
  static const PasswordMessages spanish = PasswordMessages(
    minLength: 'La contraseña debe tener al menos {min} caracteres',
    maxLength: 'La contraseña no debe tener más de {max} caracteres',
    requireUppercase:
        'La contraseña debe contener al menos una letra mayúscula',
    requireLowercase:
        'La contraseña debe contener al menos una letra minúscula',
    requireNumbers: 'La contraseña debe contener al menos un número',
    requireSpecialChars:
        'La contraseña debe contener al menos un carácter especial',
    noSpaces: 'La contraseña no puede contener espacios',
    notCommon: 'La contraseña es muy común y fácil de adivinar',
    noRepeatedChars: 'La contraseña contiene demasiados caracteres repetidos',
    noSequentialChars: 'La contraseña contiene caracteres secuenciales',
    veryWeak: 'Muy Débil',
    weak: 'Débil',
    fair: 'Regular',
    good: 'Buena',
    strong: 'Fuerte',
    veryStrong: 'Muy Fuerte',
  );

  /// French messages
  static const PasswordMessages french = PasswordMessages(
    minLength: 'Le mot de passe doit contenir au moins {min} caractères',
    maxLength: 'Le mot de passe ne doit pas dépasser {max} caractères',
    requireUppercase:
        'Le mot de passe doit contenir au moins une lettre majuscule',
    requireLowercase:
        'Le mot de passe doit contenir au moins une lettre minuscule',
    requireNumbers: 'Le mot de passe doit contenir au moins un chiffre',
    requireSpecialChars:
        'Le mot de passe doit contenir au moins un caractère spécial',
    noSpaces: 'Le mot de passe ne peut pas contenir d\'espaces',
    notCommon: 'Le mot de passe est trop commun et facile à deviner',
    noRepeatedChars: 'Le mot de passe contient trop de caractères répétés',
    noSequentialChars: 'Le mot de passe contient des caractères séquentiels',
    veryWeak: 'Très Faible',
    weak: 'Faible',
    fair: 'Moyen',
    good: 'Bon',
    strong: 'Fort',
    veryStrong: 'Très Fort',
  );

  /// German messages
  static const PasswordMessages german = PasswordMessages(
    minLength: 'Das Passwort muss mindestens {min} Zeichen lang sein',
    maxLength: 'Das Passwort darf nicht mehr als {max} Zeichen haben',
    requireUppercase:
        'Das Passwort muss mindestens einen Großbuchstaben enthalten',
    requireLowercase:
        'Das Passwort muss mindestens einen Kleinbuchstaben enthalten',
    requireNumbers: 'Das Passwort muss mindestens eine Zahl enthalten',
    requireSpecialChars:
        'Das Passwort muss mindestens ein Sonderzeichen enthalten',
    noSpaces: 'Das Passwort darf keine Leerzeichen enthalten',
    notCommon: 'Das Passwort ist zu häufig und leicht zu erraten',
    noRepeatedChars: 'Das Passwort enthält zu viele wiederholte Zeichen',
    noSequentialChars: 'Das Passwort enthält sequenzielle Zeichen',
    veryWeak: 'Sehr Schwach',
    weak: 'Schwach',
    fair: 'Mittel',
    good: 'Gut',
    strong: 'Stark',
    veryStrong: 'Sehr Stark',
  );

  /// Portuguese messages
  static const PasswordMessages portuguese = PasswordMessages(
    minLength: 'A senha deve ter pelo menos {min} caracteres',
    maxLength: 'A senha não deve ter mais de {max} caracteres',
    requireUppercase: 'A senha deve conter pelo menos uma letra maiúscula',
    requireLowercase: 'A senha deve conter pelo menos uma letra minúscula',
    requireNumbers: 'A senha deve conter pelo menos um número',
    requireSpecialChars: 'A senha deve conter pelo menos um caractere especial',
    noSpaces: 'A senha não pode conter espaços',
    notCommon: 'A senha é muito comum e fácil de adivinhar',
    noRepeatedChars: 'A senha contém muitos caracteres repetidos',
    noSequentialChars: 'A senha contém caracteres sequenciais',
    veryWeak: 'Muito Fraca',
    weak: 'Fraca',
    fair: 'Regular',
    good: 'Boa',
    strong: 'Forte',
    veryStrong: 'Muito Forte',
  );

  /// Italian messages
  static const PasswordMessages italian = PasswordMessages(
    minLength: 'La password deve essere di almeno {min} caratteri',
    maxLength: 'La password non deve superare i {max} caratteri',
    requireUppercase: 'La password deve contenere almeno una lettera maiuscola',
    requireLowercase: 'La password deve contenere almeno una lettera minuscola',
    requireNumbers: 'La password deve contenere almeno un numero',
    requireSpecialChars:
        'La password deve contenere almeno un carattere speciale',
    noSpaces: 'La password non può contenere spazi',
    notCommon: 'La password è troppo comune e facile da indovinare',
    noRepeatedChars: 'La password contiene troppi caratteri ripetuti',
    noSequentialChars: 'La password contiene caratteri sequenziali',
    veryWeak: 'Molto Debole',
    weak: 'Debole',
    fair: 'Discreta',
    good: 'Buona',
    strong: 'Forte',
    veryStrong: 'Molto Forte',
  );

  /// Persian (Farsi) messages
  static const PasswordMessages persian = PasswordMessages(
    minLength: 'رمز عبور باید حداقل {min} کاراکتر باشد',
    maxLength: 'رمز عبور نباید بیش از {max} کاراکتر باشد',
    requireUppercase: 'رمز عبور باید حداقل یک حرف بزرگ داشته باشد',
    requireLowercase: 'رمز عبور باید حداقل یک حرف کوچک داشته باشد',
    requireNumbers: 'رمز عبور باید حداقل یک عدد داشته باشد',
    requireSpecialChars: 'رمز عبور باید حداقل یک کاراکتر خاص داشته باشد',
    noSpaces: 'رمز عبور نمی‌تواند فاصله داشته باشد',
    notCommon: 'رمز عبور خیلی رایج است و قابل حدس زدن',
    noRepeatedChars: 'رمز عبور حاوی کاراکترهای تکراری زیادی است',
    noSequentialChars: 'رمز عبور حاوی کاراکترهای متوالی است',
    veryWeak: 'خیلی ضعیف',
    weak: 'ضعیف',
    fair: 'متوسط',
    good: 'خوب',
    strong: 'قوی',
    veryStrong: 'خیلی قوی',
  );

  /// Get message with parameter substitution
  String getMessage(String key, {Map<String, dynamic>? params}) {
    String message = _getMessageByKey(key);

    if (params != null) {
      params.forEach((key, value) {
        message = message.replaceAll('{$key}', value.toString());
      });
    }

    return message;
  }

  String _getMessageByKey(String key) {
    switch (key) {
      case 'minLength':
        return minLength;
      case 'maxLength':
        return maxLength;
      case 'requireUppercase':
        return requireUppercase;
      case 'requireLowercase':
        return requireLowercase;
      case 'requireNumbers':
        return requireNumbers;
      case 'requireSpecialChars':
        return requireSpecialChars;
      case 'noSpaces':
        return noSpaces;
      case 'notCommon':
        return notCommon;
      case 'noRepeatedChars':
        return noRepeatedChars;
      case 'noSequentialChars':
        return noSequentialChars;
      case 'veryWeak':
        return veryWeak;
      case 'weak':
        return weak;
      case 'fair':
        return fair;
      case 'good':
        return good;
      case 'strong':
        return strong;
      case 'veryStrong':
        return veryStrong;
      default:
        return key;
    }
  }
}
