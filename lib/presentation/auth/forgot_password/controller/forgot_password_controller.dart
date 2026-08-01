import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final RxBool isLoading = false.obs;

  final ApiClient _apiClient = ApiClient();

  void sendForgotPasswordEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppSnackBar.fail('Please enter your email address');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppSnackBar.fail('Please enter a valid email address');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.post(
        url: ApiUrl.forgotPassword,
        body: {'email': email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ??
              'Reset code sent! Please check your email.',
        );
        // Navigate to Reset OTP screen, passing email
        Get.toNamed(
          RoutePath.resetOtp,
          arguments: {'email': email},
        );
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Failed to send reset code. Please try again.';
        AppSnackBar.fail(message.toString());
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
