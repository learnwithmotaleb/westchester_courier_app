import 'package:get/get.dart';
import '../../../core/routes/route_path.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(RoutePath.login);
    });
  }
}