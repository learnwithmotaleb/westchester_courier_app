import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class ContactSupportController extends GetxController {
  final ApiClient _api = ApiClient();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final response = await _api.post(
        url: ApiUrl.contactSupport,
        isToken: true,
        body: {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "message": messageController.text.trim(),
        },
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.body != null &&
          response.body['success'] == true) {
        AppSnackBar.success(
          response.body['message'] ?? 'Support request submitted successfully',
        );
        // Clear fields after success
        nameController.clear();
        emailController.clear();
        messageController.clear();
        // Wait so user can see the success snackbar before navigating back
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.back();
      } else {
        final errorMsg =
            response.body?['message'] ??
            response.statusText ??
            'Failed to submit. Please try again.';
        AppSnackBar.fail(errorMsg);
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
