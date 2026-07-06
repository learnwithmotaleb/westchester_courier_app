import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  final nameController = TextEditingController(text: 'Ronald Richards');
  final phoneController = TextEditingController();
  final emailController = TextEditingController(text: 'tim.jennings@example.com');
  final idController = TextEditingController(text: 'ID - 458926');
  final dateController = TextEditingController(text: 'September 19 1982');

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    idController.dispose();
    dateController.dispose();
    super.onClose();
  }

  void save() {
    // Save logic
    Get.back();
  }
}
