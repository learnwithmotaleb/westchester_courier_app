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

  /// Proof-of-delivery photo
  final rxImagePath = ''.obs;

  /// Signature image (picked from gallery)
  final rxSignaturePath = ''.obs;

  final ApiClient _api = ApiClient();
  final RxBool isSubmitting = false.obs;

  /// Delivery ID — read from route arguments first, then fall back to JobDetailsController
  String deliveryId = '';

  @override
  void onInit() {
    super.onInit();
    // Read deliveryId from navigation arguments (passed from job_details_screen)
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    deliveryId = args['deliveryId'] as String? ?? '';

    // Fall back to JobDetailsController if not passed via args
    if (deliveryId.isEmpty && Get.isRegistered<JobDetailsController>()) {
      deliveryId =
          Get.find<JobDetailsController>().deliveryData.value?.id ?? '';
    }

    debugPrint('📦 DeliveryProofController.onInit — deliveryId: $deliveryId');
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  /// Pick proof-of-delivery photo from camera
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      if (image != null) {
        rxImagePath.value = image.path;
        debugPrint('📷 Proof photo selected: ${image.path}');
      }
    } catch (e) {
      AppSnackBar.fail('Failed to capture photo: $e');
    }
  }

  /// Pick signature image from gallery
  Future<void> pickSignatureImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (image != null) {
        rxSignaturePath.value = image.path;
        debugPrint('✍️ Signature image selected: ${image.path}');
      }
    } catch (e) {
      AppSnackBar.fail('Failed to select signature image: $e');
    }
  }

  Future<void> submitProof() async {
    // ── Validation ─────────────────────────────────────────────
    if (rxImagePath.value.isEmpty) {
      AppSnackBar.fail(
        'Please capture a delivery photo before submitting.',
        title: 'Required',
      );
      return;
    }

    if (nameController.text.trim().isEmpty) {
      AppSnackBar.fail('Please enter the recipient name.', title: 'Required');
      return;
    }

    if (rxSignaturePath.value.isEmpty) {
      AppSnackBar.fail('Please select a signature image.', title: 'Required');
      return;
    }

    if (deliveryId.isEmpty) {
      AppSnackBar.fail('Delivery ID not found. Please go back and try again.');
      return;
    }

    debugPrint('🚀 Submitting proof for deliveryId: $deliveryId');
    debugPrint('   recipientName   : ${nameController.text.trim()}');
    debugPrint('   proofImage      : ${rxImagePath.value}');
    debugPrint('   signatureImage  : ${rxSignaturePath.value}');

    isSubmitting.value = true;
    try {
      final response = await _api.multipart(
        url: ApiUrl.deliveryProof(deliveryId),
        method: 'PATCH',
        fields: {'recipientName': nameController.text.trim()},
        files: [
          MultipartFileData(
            key: 'proofOfDeliveryImage',
            path: rxImagePath.value,
          ),
          MultipartFileData(
            key: 'recipientSignatureImage',
            path: rxSignaturePath.value,
          ),
        ],
        isToken: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppSnackBar.success(
          response.body['message'] ?? 'Delivery completed successfully!',
        );
        // Update job details step to "Done"
        if (Get.isRegistered<JobDetailsController>()) {
          Get.find<JobDetailsController>().markAsDone();
        }

        // Go back to job details
        Get.back();
      } else {
        final msg = response.body is Map
            ? (response.body['message'] ?? 'Failed to submit proof.')
            : 'Failed to submit proof. Please try again.';
        AppSnackBar.fail(msg.toString());
      }
    } catch (e) {
      debugPrint('🔴 Error uploading proof: $e');
      AppSnackBar.fail('An error occurred during upload.');
    } finally {
      isSubmitting.value = false;
    }
  }
}
