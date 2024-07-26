class Validator {
  static String? validateText(String? value, {String err = ""}) {
    if (value == null || value.isEmpty) {
      return err;
    }
    return null;
  }

  static String? validateEmail(String? value, {String? err}) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (value == null || value.isEmpty) {
      return err ?? 'Email is required';
    }
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value,
      {required int length, String? err}) {
    if (value == null || value.isEmpty) {
      return err ?? 'Password is required';
    }
    if (value.length < length) {
      return 'Password must be at least $length characters';
    }
    return null;
  }
}
