import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/helper/local_db/local_db.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RxBool isLoading = false.obs;

  final ApiClient _apiClient = ApiClient();

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validation
    if (email.isEmpty || password.isEmpty) {
      AppSnackBar.fail('Please enter email and password');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppSnackBar.fail('Please enter a valid email address');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.post(
        url: ApiUrl.login,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.body;

        // Save token
        final token = data?['data']?['accessToken'] ??
            data?['accessToken'] ??
            data?['token'] ??
            '';
        if (token.toString().isNotEmpty) {
          await SharePrefsHelper.saveToken(token.toString());
        }

        // Save refresh token if present
        final refreshToken =
            data?['data']?['refreshToken'] ?? data?['refreshToken'] ?? '';
        if (refreshToken.toString().isNotEmpty) {
          await SharePrefsHelper.saveRefreshToken(refreshToken.toString());
        }

        // Save user ID if present
        final userId = data?['data']?['user']?['_id'] ??
            data?['data']?['user']?['id'] ??
            data?['user']?['id'] ??
            '';
        if (userId.toString().isNotEmpty) {
          await SharePrefsHelper.saveUserId(userId.toString());
        }

        AppSnackBar.success(data?['message'] ?? 'Login successful!');

        // Navigate to bottom nav
        Get.offAllNamed(RoutePath.bottomNav);
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Login failed. Please check your credentials.';
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
    passwordController.dispose();
    super.onClose();
  }
}
