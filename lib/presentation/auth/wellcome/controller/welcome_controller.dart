import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';

class WelcomeController extends GetxController {
  
  final RxBool isLoading = false.obs;
  
  void setupProfile() async {
    isLoading.value = true;
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;
    
    // Navigate to main app
    Get.offAllNamed(RoutePath.bottomNav);
  }
}
