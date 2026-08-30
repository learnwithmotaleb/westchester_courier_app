import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;

  final ApiClient _apiClient = ApiClient();

  /// Email passed from reset OTP screen
  String get _email =>
      (Get.arguments as Map<String, dynamic>?)?['email']?.toString() ?? '';

  Future<void> resetPassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (_email.isEmpty) {
      AppSnackBar.fail('Email not found. Please restart password recovery.');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.post(
        url: ApiUrl.resetPassword,
        body: {
          'email': _email,
          'newPassword': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ??
              'Password reset successful! Please sign in.',
        );

        // This flow starts from Login -> Forgot -> OTP -> Reset. Returning to
        // the existing Login route avoids deleting and recreating its text
        // controllers while the route transition is still rendering.
        FocusManager.instance.primaryFocus?.unfocus();
        Get.until((route) => route.settings.name == RoutePath.login);
      } else {
        final message =
            response.body?['message'] ??
            response.body?['error'] ??
            'Failed to reset password. Please try again.';
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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
