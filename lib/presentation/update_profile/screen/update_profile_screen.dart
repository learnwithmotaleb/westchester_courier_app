import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/service/api_url.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import 'package:westchester/widget/app_text_field.dart';
import 'package:westchester/presentation/bottom_nav/page/setting/controller/setting_controller.dart';
import 'package:westchester/widget/app_button.dart';
import '../controller/update_profile_controller.dart';

class UpdateProfileScreen extends GetView<UpdateProfileController> {
  const UpdateProfileScreen({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimensions.h(8)),
              Text(
                'Edit Profile',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimaryColor,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              Text(
                'Update your personal information to keep your account details accurate and up to date.',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.textSecondaryColor,
                ),
              ),
              SizedBox(height: Dimensions.h(24)),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ── Profile Image Picker ────────────────────
                      Center(
                        child: Obx(() {
                          final file = controller.selectedImage.value;
                          final profileImageUrl = ApiUrl.buildImageUrl(
                            _getExistingImagePath(context),
                          );

                          return GestureDetector(
                            onTap: controller.pickImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: Dimensions.w(45),
                                  backgroundColor: AppColors.lightGreyColor,
                                  backgroundImage: file != null
                                      ? FileImage(file)
                                      : (profileImageUrl.isNotEmpty
                                                ? NetworkImage(profileImageUrl)
                                                : null)
                                            as ImageProvider?,
                                  child:
                                      (file == null && profileImageUrl.isEmpty)
                                      ? Icon(
                                          Icons.person,
                                          size: Dimensions.w(40),
                                          color: AppColors.greyColor,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(Dimensions.w(6)),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: AppColors.whiteColor,
                                      size: Dimensions.rs(14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: Dimensions.h(24)),

                      // ── Driver ID (read-only) ───────────────────
                      AppTextField(
                        controller: controller.driverIdController,
                        hint: 'Driver ID',
                        readOnly: true,
                        suffixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: Dimensions.h(16)),

                      // ── Phone Number ────────────────────────────
                      AppTextField(
                        controller: controller.phoneController,
                        hint: 'Phone Number',
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: Dimensions.h(16)),

                      // ── Address ─────────────────────────────────
                      AppTextField(
                        controller: controller.addressController,
                        hint: 'Address',
                        keyboardType: TextInputType.streetAddress,
                      ),
                      SizedBox(height: Dimensions.h(16)),

                      // ── Date of Birth ───────────────────────────
                      AppTextField(
                        controller: controller.dobController,
                        hint: 'Date of Birth',
                        readOnly: true,
                        onTap: () => controller.selectDate(context),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: () => controller.selectDate(context),
                        ),
                      ),
                      SizedBox(height: Dimensions.h(16)),

                      // ── Location status ─────────────────────────
                      Obx(() {
                        if (controller.isFetchingLocation.value) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.w(16),
                              vertical: Dimensions.h(12),
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(
                                Dimensions.r(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: Dimensions.w(16),
                                  height: Dimensions.w(16),
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                SizedBox(width: Dimensions.w(10)),
                                Text(
                                  'Fetching current location...',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.w(16),
                            vertical: Dimensions.h(12),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(
                              Dimensions.r(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.green,
                                size: 16,
                              ),
                              SizedBox(width: Dimensions.w(8)),
                              Text(
                                'Location ready',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: controller.fetchCurrentLocation,
                                child: Text(
                                  'Refresh',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      SizedBox(height: Dimensions.h(16)),
                    ],
                  ),
                ),
              ),

              // ── Save Button ─────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.h(20)),
                child: Obx(
                  () => AppButton(
                    label: 'Save',
                    onPressed: controller.save,
                    isLoading: controller.isLoading.value,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper: get existing profile image path from SettingController cache
  String? _getExistingImagePath(BuildContext context) {
    try {
      if (Get.isRegistered<SettingController>()) {
        return Get.find<SettingController>().profile.value?.profileImage;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
