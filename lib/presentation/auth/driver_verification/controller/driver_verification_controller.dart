import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';

class DriverVerificationController extends GetxController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController drivingIdController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final RxBool isLoading = false.obs;

  final ApiClient _apiClient = ApiClient();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dobController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void submit() async {
    final fullName = fullNameController.text.trim();
    final drivingId = drivingIdController.text.trim();
    final dob = dobController.text.trim();

    // Validation
    if (fullName.isEmpty || drivingId.isEmpty || dob.isEmpty) {
      AppSnackBar.fail('Please fill in all fields');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.post(
        url: ApiUrl.verifyOtp,
        isToken: true,
        body: {
          'fullName': fullName,
          'drivingId': drivingId,
          'dateOfBirth': dob,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ?? 'Driver verification submitted!',
        );
        // Navigate to Verification Successful
        Get.offAllNamed(RoutePath.verificationSuccess);
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Verification failed. Please try again.';
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
    fullNameController.dispose();
    drivingIdController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
