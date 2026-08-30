import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/helper/local_db/local_db.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class AccountSettingController extends GetxController {
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isDeleting = false.obs;
  final ApiClient _apiClient = ApiClient();

  Future<void> deleteAccount() async {
    if (!(formKey.currentState?.validate() ?? false) || isDeleting.value) {
      return;
    }

    isDeleting.value = true;
    try {
      final response = await _apiClient.delete(
        url: ApiUrl.deleteAccount,
        isToken: true,
        body: {'password': passwordController.text},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final message = response.body?['message']?.toString() ??
            'Account deleted successfully';
        await SharePrefsHelper.clearUserSession();
        Get.deleteAll(force: true);
        Get.offAllNamed(RoutePath.login);
        AppSnackBar.success(message);
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Account deletion failed. Please try again.';
        AppSnackBar.fail(message.toString());
      }
    } catch (_) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isDeleting.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
