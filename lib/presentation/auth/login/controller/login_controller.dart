import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  
  void login() async {
    // Basic validation
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }
    
    isLoading.value = true;
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;
    
    // Navigate to email verification or home based on logic
    // For now, we will just proceed to home or driver verification
    Get.offAllNamed('/BottomNavScreen');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
