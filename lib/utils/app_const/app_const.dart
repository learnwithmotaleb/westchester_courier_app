class AppConstants {
  // ===================== Language =====================
  static const String english = "en";
  static const String arabic = "ar";
  static String language = english; // default

  // ===================== User Session =================
  static String? userId;      // Logged-in user ID
  static String? userName;    // Optional: User name
  static String? userEmail;   // Optional: User email
  static String? token;       // Auth token

  // ===================== App Info ====================
  static const String baseUrl = "https://nc5cnwcx-8001.inc1.devtunnels.ms"; // Keeping your previous devtunnels URL
  static const String appVersion = "1.0.0";
  static const int splashDelaySeconds = 3;

  // ===================== API Keys ====================
  static const String googleMapsApiKeyAndroid = "YOUR_ANDROID_GOOGLE_MAPS_API_KEY";
  static const String googleMapsApiKeyIOS = "YOUR_IOS_GOOGLE_MAPS_API_KEY";

  // ===================== SharedPrefs Keys =============
  static const String tokenKey = "user_token";
  static const String languageKey = "app_language";
  static const String roleKey = "app_role";
  static const String onboardSeenKey = "onboard_seen";
  static const String themeModeKey = "theme_mode";

  // ===================== Helpers =====================
  /// Set token and optional user info
  static void setToken({
    required String userToken,
    String? id,
    String? name,
    String? email,
  }) {
    token = userToken;
    userId = id;
    userName = name;
    userEmail = email;
  }

  /// Clear all user session info (logout)
  static void clearSession() {
    token = null;
    userId = null;
    userName = null;
    userEmail = null;
  }
}