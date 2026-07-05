import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';

class DriverVerificationController extends GetxController {
  final TextEditingController drivingIdController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  
  void submit() async {
    // Basic validation
    if (drivingIdController.text.trim().isEmpty || 
        dobController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return;
    }

    isLoading.value = true;
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;
    
    // Navigate to Verification Successful
    Get.offAllNamed(RoutePath.verificationSuccess); 
  }

  @override
  void onClose() {
    drivingIdController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
