/// A Configuration Class that holds the `Google reCAPTCHA v3` API Confidential Information.
class Config {
  /// Prevents from object instantiation.
  Config._();

  /// Holds the 'Site Key' for the `Google reCAPTCHA v3` API .
  static const String siteKey = '6Lc7kcwkAAAAAHzecMjwB9Ny9jC9pW460dR-ORJw';

  /// Holds the 'Secret Key' for the `Google reCAPTCHA v3` API .
  static const String secretKey = '6Lc7kcwkAAAAAI8SeBxfyb6DZnPhOFjaNm9MCFJI';

  /// Holds the 'Verfication URL' for the `Google reCAPTCHA v3` API .
  static final verificationURL =
      Uri.parse('https://www.google.com/recaptcha/api/siteverify');
}

class AdminCredentials {
  AdminCredentials._();

  static const username = 'schedcare';
  static const admins = [username];
}
