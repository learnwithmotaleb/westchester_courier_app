import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:westchester/presentation/job_details/controller/job_details_controller.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';

class DeliveryProofController extends GetxController {
  final nameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final rxImagePath = ''.obs;

  final ApiClient _api = ApiClient();
  final RxBool isSubmitting = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        rxImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture photo: $e');
    }
  }

  Future<void> submitProof() async {
    if (rxImagePath.isEmpty) {
      AppSnackBar.fail(
        'Please capture a photo before submitting.',
        title: 'Required',
      );
      return;
    }

    if (nameController.text.trim().isEmpty) {
      AppSnackBar.fail('Please enter recipient name.', title: 'Required');
      return;
    }

    String deliveryId = '';
    if (Get.isRegistered<JobDetailsController>()) {
      final jobCtrl = Get.find<JobDetailsController>();
      deliveryId = jobCtrl.deliveryData.value?.id ?? '';
    }

    if (deliveryId.isEmpty) {
      AppSnackBar.fail('Delivery ID not found.');
      return;
    }

    isSubmitting.value = true;
    try {
      final response = await _api.multipart(
        url: ApiUrl.deliveryProof(deliveryId),
        method: "PATCH",
        fields: {'recipientName': nameController.text.trim()},
        files: [
          MultipartFileData(
            key: 'proofOfDeliveryImage',
            path: rxImagePath.value,
          ),
        ],
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success('Success delivery');

        // Update step in JobDetailsController to 5 (Done)
        if (Get.isRegistered<JobDetailsController>()) {
          Get.find<JobDetailsController>().markAsDone();
          // Optionally refresh delivery details
          Get.find<JobDetailsController>().fetchDeliveryDetails(deliveryId);
        }
        Get.back(); // Go back to JobDetailsScreen
      } else {
        AppSnackBar.fail('Failed to upload proof. Please try again.');
      }
    } catch (e) {
      debugPrint('Error uploading proof: $e');
      AppSnackBar.fail('An error occurred during upload.');
    } finally {
      isSubmitting.value = false;
    }
  }
}
