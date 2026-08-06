import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/widget/app_text_field.dart';
import 'package:westchester/widget/app_button.dart';
import '../controller/report_issus_controller.dart';

class ReportIssusScreen extends GetView<ReportIssusController> {
  const ReportIssusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: '',
        showBack: true,
        backgroundColor: AppColors.whiteColor,
        onBack: () => Get.back(),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20)),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimensions.h(8)),
                Text(
                  'Report Issue',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: Dimensions.h(6)),
                Text(
                  'Report any problems or technical issues so our support team can assist you.',
                  style: AppTextStyles.bodyText.copyWith(
                    color: AppColors.textSecondaryColor.withOpacity(0.8),
                    fontSize: Dimensions.fs(12),
                  ),
                ),
                SizedBox(height: Dimensions.h(24)),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Field
                        AppTextField(
                          controller: controller.titleController,
                          hint: 'Title',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a title';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Dimensions.h(16)),

                        // Description Field
                        AppTextField(
                          controller: controller.issueNoteController,
                          hint: 'Describe the issue here...',
                          maxLines: 6,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please describe the issue';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Dimensions.h(20)),

                        // Capture Photo Button
                        Obx(() {
                          final path = controller.rxImagePath.value;
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: controller.pickImage,
                                child: Container(
                                  width: double.infinity,
                                  height: Dimensions.h(48),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreyColor,
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.r(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_rounded,
                                        color: AppColors.textPrimaryColor,
                                        size: Dimensions.rs(18),
                                      ),
                                      SizedBox(width: Dimensions.w(8)),
                                      Text(
                                        path.isNotEmpty
                                            ? 'Retake Photo'
                                            : 'Capture Photo',
                                        style: AppTextStyles.bodyText.copyWith(
                                          color: AppColors.textPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (path.isNotEmpty) ...[
                                SizedBox(height: Dimensions.h(12)),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.r(12),
                                  ),
                                  child: Image.file(
                                    File(path),
                                    height: Dimensions.h(120),
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Submit Button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.h(20)),
                  child: Obx(
                    () => AppButton(
                      label: 'Submit',
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.submitIssue,
                      isLoading: controller.isLoading.value,
                      backgroundColor: AppColors.primaryColor,
                      borderSideColor: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
