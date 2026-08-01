// lib/core/network/api_url.dart

class ApiUrl {
  ApiUrl._();

  //══════════════════════════════════════════════════════════
  // DOMAIN
  //══════════════════════════════════════════════════════════

  /// Change only this domain when switching servers.
  static const String _mainDomain =
      "https://nc5cnwcx-8001.inc1.devtunnels.ms";

  static const String baseUrl = _mainDomain;

  /// Builds a full image URL from a relative path.
  ///
  /// Examples:
  /// \uploads\shoes.jpg
  /// \\uploads\\shoes.jpg
  /// uploads/shoes.jpg
  /// /uploads/shoes.jpg
  ///
  /// =>
  /// https://helena-sedimentological-emily.ngrok-free.dev/uploads/shoes.jpg
  static String buildImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return '';
    }

    // Already a complete URL
    if (imagePath.startsWith('http://') ||
        imagePath.startsWith('https://')) {
      return imagePath;
    }

    // Convert Windows path separators to URL separators
    String path = imagePath.replaceAll('\\', '/');

    // Remove duplicate slashes
    path = path.replaceAll(RegExp(r'/+'), '/');

    // Remove leading slash
    if (path.startsWith('/')) {
      path = path.substring(1);
    }

    return '$_mainDomain/$path';
  }

  //══════════════════════════════════════════════════════════
  // AUTH
  //══════════════════════════════════════════════════════════

  static const String register = '$baseUrl/auth/register';
  static const String activeAccount = '$baseUrl/auth/activate-account';
  static const String login = '$baseUrl/auth/login';
  static const String resendOtp = '$baseUrl/auth/resend-activation-code';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyResetOtp = '$baseUrl/auth/verify-reset-otp';
  static const String changePassword = '$baseUrl/auth/change-password';//Patch method
  static const String termsCondition = '$baseUrl/terms-conditions';//get method
  static const String privacyAndPolicy = '$baseUrl/privacy-policy';//get method

}