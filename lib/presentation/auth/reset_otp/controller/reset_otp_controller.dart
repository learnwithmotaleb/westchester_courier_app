import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class ResetOtpController extends GetxController {
  final TextEditingController otpController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isResendLoading = false.obs;

  final ApiClient _apiClient = ApiClient();

  /// Email passed from forgot password screen
  String get _email =>
      (Get.arguments as Map<String, dynamic>?)?['email']?.toString() ?? '';

  Future<void> verifyResetOtp() async {
    final otpText = otpController.text.trim();

    if (_email.isEmpty) {
      AppSnackBar.fail('Email not found. Please request a new reset code.');
      return;
    }

    if (otpText.length != 6) {
      AppSnackBar.fail('Please enter a 6-digit code');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.post(
        url: ApiUrl.verifyOtp,
        body: {'email': _email, 'code': otpText},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ?? 'Code verified! Set your new password.',
        );
        Get.toNamed(RoutePath.resetPassword, arguments: {'email': _email});
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Invalid code. Please try again.';
        AppSnackBar.fail(message.toString());
      }
    } catch (_) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() async {
    if (_email.isEmpty) {
      AppSnackBar.fail('Email not found. Please go back and try again.');
      return;
    }

    isResendLoading.value = true;

    try {
      final response = await _apiClient.post(
        url: ApiUrl.forgotPassword,
        body: {'email': _email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ?? 'Reset code resent successfully!',
        );
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Failed to resend code. Please try again.';
        AppSnackBar.fail(message.toString());
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isResendLoading.value = false;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
