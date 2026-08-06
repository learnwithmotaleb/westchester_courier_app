// lib/core/network/api_url.dart

class ApiUrl {
  ApiUrl._();

  //══════════════════════════════════════════════════════════
  // DOMAIN
  //══════════════════════════════════════════════════════════

  /// Change only this domain when switching servers.
  // static const String _mainDomain = "https://nc5cnwcx-8001.inc1.devtunnels.ms";
  // static const String _mainDomain = "http://10.10.20.52:8001";//live
  static const String _mainDomain =
      "https://nc5cnwcx-8001.inc1.devtunnels.ms"; //live

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
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
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
  static const String changePassword =
      '$baseUrl/auth/change-password'; //Patch method
  static const String termsCondition = '$baseUrl/terms-conditions'; //get method
  static const String privacyAndPolicy = '$baseUrl/privacy-policy'; //get method

  static const String driverProfileVerification =
      '$baseUrl/profile/driver-setup'; //Path method
  static const String driverProfileGet = '$baseUrl/profile/me'; //get method
  static const String updateDriverProfile =
      '$baseUrl/profile/me'; //Patch method
  static const String updateDriverPicture =
      '$baseUrl/profile/me'; //Patch method

  static const String deliveryStatsSummary =
      '$baseUrl/deliveries/stats/summary'; //Get method
  static const String deliveryMy = '$baseUrl/deliveries/my'; //Get method
  static String deliveryDetails(String id) =>
      '$baseUrl/deliveries/$id'; //Get method
  static String openMap(String id) =>
      '$baseUrl/deliveries/$id/map'; //Get method
  static String deliverRequests = '$baseUrl/deliveries/requests'; //Get method
  static String deliveryProof(String id) =>
      '$baseUrl/deliveries/$id/proof-of-delivery'; //Patch method
  static String liveLocationUpdate(String deliveryId) =>
      '$baseUrl/deliveries/$deliveryId/location'; //Patch method
  static String contactSupport = '$baseUrl/support'; //post method
  static String myHistory = '$baseUrl/deliveries/my-history'; //get method
  static String report = '$baseUrl/reports'; //POst method

  static String acceptRequest(String deliveryId) =>
      '$baseUrl/deliveries/$deliveryId/accept'; //Patch method
  static String rejectRequest(String deliveryId) =>
      '$baseUrl/deliveries/$deliveryId/reject'; //Patch method
  static String driverPickupRequest(String deliveryId) =>
      '$baseUrl/deliveries/$deliveryId/driver-to-pickup'; //Patch method
  static String confirmPickupRequest(String deliveryId) =>
      '$baseUrl/deliveries/$deliveryId/picked-up'; //Patch method
  static String inTransitRequest(String deliveryId) =>
      '$baseUrl/deliveries/$deliveryId/in-transit'; //Patch method
  static String outForDeliveryRequest(String deliveryId) =>
      '$baseUrl/deliveries/$deliveryId/out-for-delivery'; //Patch method

  // ── Socket ──────────────────────────────────────────────────
  static const String socketUrl = _mainDomain;

  // ── Notification URLs ─────────────────────────────────────────
  static const String updateFcmToken = '$baseUrl/auth/fcm-token'; // Update FCM Token
  static const String notification = '$baseUrl/notifications'; // Get Notifications
  static const String notificationReadAll = '$baseUrl/notifications/read-all'; // Read all

  static String notificationDelete(String id) => '$baseUrl/notifications/$id'; // Delete notification
  static String notificationRead(String id) => '$baseUrl/notifications/$id/read'; // Mark as read
  static String notificationUnreadCount(String s) => '$baseUrl/notifications/unread-count'; // Get unread count
}
