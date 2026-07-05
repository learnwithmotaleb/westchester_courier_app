import 'package:get/get.dart';
import '../../core/routes/route_path.dart';
import '../../helper/local_db/local_db.dart';
import '../../helper/local_db/shareprefs_helper.dart';
import '../../widget/show_snackbar.dart';
import '../../core/enums/app_role.dart';

class AppNavigator {

  /// =================== After Login ====================
  static Future<void> navigateAfterLogin() async {
    final role = SharePrefsHelper.getRole();

    print("🔍 User Role: $role");

    if (role == AppRole.DRIVER) {
      Get.offAllNamed(RoutePath.splash);
    } else if (role == AppRole.CUSTOMER) {
      Get.offAllNamed(RoutePath.splash);
    } else {
      Get.offAllNamed(RoutePath.splash);
    }
  }

  /// =================== Splash Start ====================
  static Future<void> checkAppStartNavigation() async {
    final token = SharePrefsHelper.getToken();
    final role  = SharePrefsHelper.getRole();

    if (token != null && token.isNotEmpty) {

      if (role == AppRole.DRIVER) {
        Get.offAllNamed(RoutePath.splash);
      } else if (role == AppRole.CUSTOMER) {
        Get.offAllNamed(RoutePath.splash);
      } else {
        Get.offAllNamed(RoutePath.splash);
      }

    } else {
      Get.offAllNamed(RoutePath.splash);
    }
  }

  /// =================== Logout ====================
  static Future<void> logout() async {
    await SharePrefsHelper.clearAll();

    ShowAppSnackBar.success("Logged out successfully");
    Get.offAllNamed(RoutePath.splash);
  }

  /// =================== Debug ====================
  static void debugInfo() {
    print("===== DEBUG INFO START =====");
    print("Token: ${SharePrefsHelper.getToken()}");
    print("Role: ${SharePrefsHelper.getRole()}");
    print("Current Route: ${Get.currentRoute}");
    print("===== DEBUG INFO END =====");
  }
}