import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:westchester/helper/tost_message/show_snackbar.dart';
import 'package:westchester/service/api_service.dart';
import 'package:westchester/service/api_url.dart';

class ReportIssusController extends GetxController {
  final ApiClient _api = ApiClient();

  final titleController = TextEditingController();
  final issueNoteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final rxImagePath = ''.obs;
  final RxBool isLoading = false.obs;

  /// Delivery ID passed from Job Details screen
  String deliveryId = '';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    deliveryId = args['deliveryId'] as String? ?? '';
  }

  @override
  void onClose() {
    titleController.dispose();
    issueNoteController.dispose();
    super.onClose();
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        rxImagePath.value = image.path;
      }
    } catch (e) {
      AppSnackBar.fail('Failed to capture photo: $e');
    }
  }

  Future<void> submitIssue() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading.value = true;
    try {
      final fields = <String, String>{
        'title': titleController.text.trim(),
        'description': issueNoteController.text.trim(),
        'deliveryId': deliveryId,
      };

      final files = rxImagePath.value.isNotEmpty
          ? [MultipartFileData(key: 'photo', path: rxImagePath.value)]
          : <MultipartFileData>[];

      final response = await _api.multipart(
        url: ApiUrl.report,
        fields: fields,
        files: files,
        isToken: true,
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.body != null &&
          response.body['success'] == true) {
        AppSnackBar.success(
          response.body['message'] ?? 'Issue reported successfully',
        );
        titleController.clear();
        issueNoteController.clear();
        rxImagePath.value = '';
        await Future.delayed(const Duration(milliseconds: 1500));
        Get.back();
      } else {
        final errorMsg =
            response.body?['message'] ??
            response.statusText ??
            'Failed to report issue. Please try again.';
        AppSnackBar.fail(errorMsg);
      }
    } catch (e) {
      AppSnackBar.fail('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
