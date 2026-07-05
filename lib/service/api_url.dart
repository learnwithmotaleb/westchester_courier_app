// lib/core/network/api_url.dart

class ApiUrl {
  ApiUrl._();

  //══════════════════════════════════════════════════════════
  // DOMAIN
  //══════════════════════════════════════════════════════════

  /// Change only this domain when switching servers.
  static const String _mainDomain =
      "https://helena-sedimentological-emily.ngrok-free.dev";

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
  static const String verifyEmail = '$baseUrl/auth/verify-email';
  static const String resendOtp = '$baseUrl/auth/resend-otp';
  static const String forgotPassword = '$baseUrl/auth/forgot-password';
  static const String verifyResetOtp = '$baseUrl/auth/verify-reset-otp';
  static const String resetPassword = '$baseUrl/auth/reset-password';
  static const String login = '$baseUrl/auth/login';
  static const String getMe = '$baseUrl/auth/me';
}