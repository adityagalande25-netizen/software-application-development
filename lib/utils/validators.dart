/// Email validation
bool isValidEmail(String email) {
  final regex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return regex.hasMatch(email);
}

/// Phone number validation
bool isValidPhone(String phone) {
  final regex = RegExp(r'^[0-9]{10,15}$');
  final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
  return regex.hasMatch(cleaned);
}

/// Password validation
bool isValidPassword(String password) {
  return password.length >= 6;
}

/// Name validation
bool isValidName(String name) {
  return name.isNotEmpty && name.length >= 2;
}

/// Validate form fields
Map<String, bool> validateSignupForm({
  required String name,
  required String email,
  required String phone,
  required String password,
  required String confirmPassword,
}) {
  return {
    'name': isValidName(name),
    'email': isValidEmail(email),
    'phone': isValidPhone(phone),
    'password': isValidPassword(password),
    'confirmPassword': password == confirmPassword && isValidPassword(password),
  };
}

/// Validate login form
Map<String, bool> validateLoginForm({
  required String email,
  required String password,
}) {
  return {
    'email': isValidEmail(email),
    'password': isValidPassword(password),
  };
}

/// Get error message for validation
String getValidationError(String field) {
  switch (field) {
    case 'name':
      return 'Please enter a valid name (minimum 2 characters)';
    case 'email':
      return 'Please enter a valid email address';
    case 'phone':
      return 'Please enter a valid phone number (10-15 digits)';
    case 'password':
      return 'Password must be at least 6 characters long';
    case 'confirmPassword':
      return 'Passwords do not match';
    default:
      return 'Invalid input';
  }
}
