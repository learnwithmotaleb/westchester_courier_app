import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactSupportController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void submit() {
    // Submit logic
    Get.back();
  }
}
