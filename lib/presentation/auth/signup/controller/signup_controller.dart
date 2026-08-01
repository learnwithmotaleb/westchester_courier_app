import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class SignupController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool isLoading = false.obs;

  final ApiClient _apiClient = ApiClient();

  void signup() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // Validation
    if (name.isEmpty) {
      AppSnackBar.fail('Please enter your full name');
      return;
    }

    if (email.isEmpty) {
      AppSnackBar.fail('Please enter your email address');
      return;
    }

    if (!GetUtils.isEmail(email)) {
      AppSnackBar.fail('Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      AppSnackBar.fail('Please enter a password');
      return;
    }

    if (password.length < 6) {
      AppSnackBar.fail('Password must be at least 6 characters');
      return;
    }

    if (confirmPassword.isEmpty) {
      AppSnackBar.fail('Please confirm your password');
      return;
    }

    if (password != confirmPassword) {
      AppSnackBar.fail('Passwords do not match');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.post(
        url: ApiUrl.register,
        body: {
          'name': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'role': 'DRIVER',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ??
              'Registration successful! Please verify your email.',
        );
        // Pass email to OTP screen for verification
        Get.offAllNamed(
          RoutePath.emailVerification,
          arguments: {'email': email},
        );
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Registration failed. Please try again.';
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
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
