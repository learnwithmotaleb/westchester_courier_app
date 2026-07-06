import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ReportIssusController extends GetxController {
  final titleController = TextEditingController();
  final issueNoteController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final rxImagePath = ''.obs;

  @override
  void onClose() {
    titleController.dispose();
    issueNoteController.dispose();
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

  void submitIssue() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please enter a title.');
      return;
    }
    if (issueNoteController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please describe the issue.');
      return;
    }
    Get.back();
    Get.snackbar(
      'Issue Reported',
      'Your issue has been reported to support.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
