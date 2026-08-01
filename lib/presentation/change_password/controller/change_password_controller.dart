import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class ChangePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;

  final ApiClient _apiClient = ApiClient();

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void changePassword() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;

    try {
      final response = await _apiClient.patch(
        url: ApiUrl.changePassword,
        isToken: true,
        body: {
          'oldPassword': currentPasswordController.text,
          'newPassword': newPasswordController.text,
          'confirmPassword': confirmPasswordController.text,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ?? 'Password changed successfully!',
        );
        Get.back();
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Failed to change password. Please try again.';
        AppSnackBar.fail(message.toString());
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
