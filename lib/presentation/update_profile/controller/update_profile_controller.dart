import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/presentation/bottom_nav/page/setting/controller/setting_controller.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';

class UpdateProfileController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  // ── Text controllers ──────────────────────────────────────────
  final driverIdController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final dobController = TextEditingController();

  // ── State ─────────────────────────────────────────────────────
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isFetchingLocation = false.obs;

  // ── Location ──────────────────────────────────────────────────
  double _lat = 0.0;
  double _lng = 0.0;

  @override
  void onInit() {
    super.onInit();
    _prefillFromProfile();
    fetchCurrentLocation();
  }

  // ── Pre-fill from already-fetched SettingController data ──────
  void _prefillFromProfile() {
    if (Get.isRegistered<SettingController>()) {
      final p = Get.find<SettingController>().profile.value;
      if (p != null) {
        driverIdController.text = p.driverId ?? '';
        phoneController.text = p.phoneNumber ?? '';
        addressController.text = p.address ?? '';

        // Format DOB: "1995-05-15T00:00:00.000Z" → "1995-05-15"
        if (p.dateOfBirth != null) {
          try {
            final dt = DateTime.parse(p.dateOfBirth!);
            dobController.text = DateFormat('yyyy-MM-dd').format(dt);
          } catch (_) {
            dobController.text = p.dateOfBirth!;
          }
        }

        // Pre-fill coordinates from profile
        final coords = p.locationCoordinates?.coordinates;
        if (coords != null && coords.length >= 2) {
          _lng = coords[0].toDouble(); // [lng, lat] in GeoJSON
          _lat = coords[1].toDouble();
        }
      }
    }
  }

  // ── Get device current location ───────────────────────────────
  Future<void> fetchCurrentLocation() async {
    isFetchingLocation.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        AppSnackBar.info('Location permission permanently denied.');
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _lat = position.latitude;
      _lng = position.longitude;
    } catch (e) {
      // Silently fall back to profile coordinates
    } finally {
      isFetchingLocation.value = false;
    }
  }

  // ── Date picker ───────────────────────────────────────────────
  Future<void> selectDate(BuildContext context) async {
    DateTime initial;
    try {
      initial = dobController.text.isNotEmpty
          ? DateTime.parse(dobController.text)
          : DateTime.now().subtract(const Duration(days: 365 * 18));
    } catch (_) {
      initial = DateTime.now().subtract(const Duration(days: 365 * 18));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
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

  // ── Image picker ──────────────────────────────────────────────
  Future<void> pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1600,
        maxHeight: 1600,
        requestFullMetadata: false,
      );

      if (image == null) return;

      final file = File(image.path);
      if (!await file.exists() || await file.length() == 0) {
        AppSnackBar.fail('The selected photo could not be read.');
        return;
      }

      selectedImage.value = file;
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied' ||
          e.code == 'camera_access_denied') {
        AppSnackBar.fail(
          'Photo access is disabled. Enable it from iPhone Settings.',
        );
      } else {
        AppSnackBar.fail('Unable to select photo. Please try again.');
      }
    } catch (_) {
      AppSnackBar.fail('Unable to select photo. Please try again.');
    }
  }

  // ── Save / PATCH ──────────────────────────────────────────────
  Future<void> save() async {
    final driverId = driverIdController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();
    final dob = dobController.text.trim();

    if (driverId.isEmpty || phone.isEmpty || address.isEmpty || dob.isEmpty) {
      AppSnackBar.fail('Please fill in all fields');
      return;
    }

    isLoading.value = true;

    try {
      // Build multipart fields
      final fields = <String, String>{
        'driverId': driverId,
        'dateOfBirth': dob,
        'phoneNumber': phone,
        'lat': _lat.toString(),
        'lng': _lng.toString(),
        'address': address,
      };

      // Files list
      final files = <MultipartFileData>[];
      if (selectedImage.value != null) {
        files.add(
          MultipartFileData(
            key: 'profileImage',
            path: selectedImage.value!.path,
          ),
        );
      }

      final response = await _apiClient.multipart(
        url: ApiUrl.updateDriverProfile,
        fields: fields,
        files: files,
        method: 'PATCH',
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ?? 'Profile updated successfully!',
        );

        // Refresh profile in SettingController
        if (Get.isRegistered<SettingController>()) {
          Get.find<SettingController>().fetchProfile();
        }

        Get.back();
      } else {
        final message = response.body?['message'] ??
            response.body?['error'] ??
            'Update failed. Please try again.';
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
    driverIdController.dispose();
    phoneController.dispose();
    addressController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
