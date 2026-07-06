import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:westchester/presentation/job_details/controller/job_details_controller.dart';

class DeliveryProofController extends GetxController {
  final nameController = TextEditingController(text: 'Jenny Wilson');
  final ImagePicker _picker = ImagePicker();
  final rxImagePath = ''.obs;

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

  void submitProof() {
    if (rxImagePath.isEmpty) {
      Get.snackbar('Required', 'Please capture a photo before submitting.');
      return;
    }
    // Update step in JobDetailsController to 5 (Done)
    if (Get.isRegistered<JobDetailsController>()) {
      Get.find<JobDetailsController>().markAsDone();
    }
    Get.back(); // Go back to JobDetailsScreen
  }
}
