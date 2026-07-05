import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';

class SignupController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  
  void signup() async {
    // Basic validation
    if (emailController.text.trim().isEmpty || 
        passwordController.text.isEmpty || 
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }
    
    isLoading.value = true;
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;
    
    // Navigate to Email Verification 
    Get.offAllNamed(RoutePath.emailVerification); 
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
