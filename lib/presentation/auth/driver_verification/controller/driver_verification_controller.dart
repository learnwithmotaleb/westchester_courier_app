import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/service/google_map_services.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';

class DriverVerificationController extends GetxController {
  final TextEditingController drivingIdController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

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
    final driverId = drivingIdController.text.trim();
    final dob = dobController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    final address = addressController.text.trim();

    // Validation
    if (driverId.isEmpty ||
        dob.isEmpty ||
        phoneNumber.isEmpty ||
        address.isEmpty) {
      AppSnackBar.fail('Please fill in all fields');
      return;
    }

    // Get real GPS location from GoogleMapServices
    double lat = 0.0;
    double lng = 0.0;
    if (Get.isRegistered<GoogleMapServices>()) {
      final mapService = Get.find<GoogleMapServices>();
      lat = mapService.currentLat.value;
      lng = mapService.currentLng.value;
    } else {
      // GoogleMapServices not yet registered — fetch inline
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        lat = position.latitude;
        lng = position.longitude;
      } catch (_) {}
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.patch(
        url: ApiUrl.driverProfileVerification,
        isToken: true,
        body: {
          'driverId': driverId,
          'dateOfBirth': dob,
          'phoneNumber': phoneNumber,
          'lat': lat,
          'lng': lng,
          'address': address,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ?? 'Driver profile setup successful!',
        );
        // Navigate to Verification Successful
        Get.offAllNamed(RoutePath.verificationSuccess);
      } else {
        final message =
            response.body?['message'] ??
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
    drivingIdController.dispose();
    dobController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
