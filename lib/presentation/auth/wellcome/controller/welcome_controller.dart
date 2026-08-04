import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:westchester/core/routes/route_path.dart';
import 'package:westchester/helper/local_db/local_db.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class WelcomeController extends GetxController {
  final ApiClient _apiClient = ApiClient();

  final RxBool isLoading = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  final RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserName();
  }

  void _loadUserName() {
    final email = SharePrefsHelper.getUserEmail() ?? '';
    if (email.isNotEmpty) {
      userName.value = email.split('@').first;
    } else {
      userName.value = 'User';
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  void setupProfile() async {
    if (selectedImage.value == null) {
      AppSnackBar.fail('Please select a profile picture');
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.multipart(
        url: ApiUrl.updateDriverPicture,
        method: 'PATCH',
        isToken: true,
        fields: {},
        files: [
          MultipartFileData(
            key: 'profileImage',
            path: selectedImage.value!.path,
          ),
        ],
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body?['message'] ?? 'Profile picture updated successfully!',
        );
        Get.offAllNamed(RoutePath.bottomNav);
      } else {
        final message =
            response.body?['message'] ??
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
}
