import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';

class OtpVerifyController extends GetxController {
  final TextEditingController otpController = TextEditingController();

  final RxBool isLoading = false.obs;

  Future<void> emailVerifyProcess() async {
    final otpText = otpController.text.trim();
    if (otpText.length != 6) {
      Get.snackbar('Error', 'Please enter a 6-digit code');
      return;
    }

    isLoading.value = true;
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    isLoading.value = false;

    // Navigate to Driver Verification
    Get.offAllNamed(RoutePath.driverVerification);
  }

  void resendOtpProcess() async {
    // Simulate resend API call
    Get.snackbar('Success', 'OTP has been resent successfully!');
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
