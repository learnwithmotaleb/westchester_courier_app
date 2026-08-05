import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/widget/app_text_field.dart';
import 'package:westchester/widget/app_button.dart';
import 'package:westchester/core/routes/route_path.dart';
import '../controller/delivery_proof_controller.dart';

class DeliveryProofScreen extends GetView<DeliveryProofController> {
  const DeliveryProofScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: 'Proof of Delivery',
        showBack: true,
        backgroundColor: AppColors.whiteColor,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimensions.h(20)),
                      // Photo Header
                      Center(
                        child: Text(
                          'Photo',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.h(8)),

                      // Photo Upload Box
                      Obx(() {
                        final path = controller.rxImagePath.value;
                        return GestureDetector(
                          onTap: controller.pickImage,
                          child: Container(
                            width: double.infinity,
                            height: Dimensions.h(120),
                            decoration: BoxDecoration(
                              color: AppColors.lightGreyColor.withOpacity(0.3),
                              border: Border.all(
                                color: AppColors.greyColor.withOpacity(0.3),
                              ),
                              borderRadius: BorderRadius.circular(
                                Dimensions.r(12),
                              ),
                            ),
                            child: path.isEmpty
                                ? Icon(
                                    Icons.camera_alt_outlined,
                                    size: Dimensions.rs(32),
                                    color: AppColors.greyColor,
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.r(12),
                                    ),
                                    child: Image.file(
                                      File(path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        );
                      }),
                      SizedBox(height: Dimensions.h(24)),

                      // Enter Your Name Input
                      Center(
                        child: Text(
                          'Enter Your Name',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.h(8)),
                      AppTextField(
                        controller: controller.nameController,
                        hint: 'Your Name',
                      ),
                      SizedBox(height: Dimensions.h(24)),
                    ],
                  ),
                ),
              ),

              // Bottom buttons
              Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.h(12)),
                child: Column(
                  children: [
                    // Report Issue Button
                    GestureDetector(
                      onTap: () => Get.toNamed(RoutePath.reportIssue),
                      child: Container(
                        width: double.infinity,
                        height: Dimensions.h(48),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyColor,
                          borderRadius: BorderRadius.circular(Dimensions.r(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              color: AppColors.textPrimaryColor,
                              size: Dimensions.rs(18),
                            ),
                            SizedBox(width: Dimensions.w(8)),
                            Text(
                              'Report Issue',
                              style: AppTextStyles.bodyText.copyWith(
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.h(12)),
                    // Submit button
                    Obx(() => controller.isSubmitting.value
                        ? const Center(child: CircularProgressIndicator())
                        : AppButton(
                            label: 'Submit',
                            onPressed: controller.submitProof,
                            backgroundColor: AppColors.successColor,
                            borderSideColor: AppColors.successColor,
                          )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
