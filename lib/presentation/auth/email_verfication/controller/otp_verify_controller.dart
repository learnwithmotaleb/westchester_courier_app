import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/helper/local_db/local_db.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class OtpVerifyController extends GetxController {
  final TextEditingController otpController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isResendLoading = false.obs;

  final ApiClient _apiClient = ApiClient();

  /// Email passed from signup screen
  String get _email =>
      (Get.arguments as Map<String, dynamic>?)?['email']?.toString() ?? '';

  Future<void> emailVerifyProcess() async {
    final otpText = otpController.text.trim();

    if (otpText.length != 6) {
      AppSnackBar.fail('Please enter a 6-digit code');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.post(
        url: ApiUrl.activeAccount,
        body: {
          'email': _email,
          'activationCode': otpText,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ?? 'Email verified successfully!',
        );

        // ── Save token returned by activate-account ──────────────
        final data = response.body;
        final token = data?['data']?['accessToken'] ??
            data?['data']?['token'] ??
            data?['accessToken'] ??
            data?['token'] ??
            '';
        if (token.toString().isNotEmpty) {
          await SharePrefsHelper.saveToken(token.toString());
        }

        // Save userId if present
        final userId = data?['data']?['user']?['_id'] ??
            data?['data']?['_id'] ??
            data?['user']?['_id'] ??
            '';
        if (userId.toString().isNotEmpty) {
          await SharePrefsHelper.saveUserId(userId.toString());
        }

        // Navigate to Driver Verification
        Get.offAllNamed(RoutePath.driverVerification);
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Verification failed. Please check the code.';
        AppSnackBar.fail(message.toString());
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtpProcess() async {
    if (_email.isEmpty) {
      AppSnackBar.fail('Email not found. Please go back and try again.');
      return;
    }

    isResendLoading.value = true;

    try {
      final response = await _apiClient.post(
        url: ApiUrl.resendOtp,
        body: {'email': _email},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ?? 'OTP resent successfully!',
        );
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Failed to resend OTP. Please try again.';
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
