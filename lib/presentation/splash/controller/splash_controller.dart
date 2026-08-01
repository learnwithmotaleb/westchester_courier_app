import 'package:get/get.dart';
import '../../../core/routes/route_path.dart';
import '../../../helper/local_db/local_db.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    // Show splash for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // Check if token exists
    final String? token = SharePrefsHelper.getToken();

    if (token != null && token.trim().isNotEmpty) {
      Get.offAllNamed(RoutePath.bottomNav);
    } else {
      Get.offAllNamed(RoutePath.login);
    }
  }
}