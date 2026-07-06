import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors/app_colors.dart';
import '../utils/app_text_style/app_text_style.dart';
import '../core/responsive_layout/dimensions.dart';

class AppAlerts {
  static void success({required String message}) {
    Get.dialog(
      _AlertWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleIcon(
              icon: Icons.check_rounded,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: Dimensions.h(16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4.copyWith(color: AppColors.blackColor),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (Get.isDialogOpen == true) Get.back();
    });
  }

  static void error({required String message}) {
    Get.dialog(
      _AlertWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleIcon(icon: Icons.close_rounded, color: AppColors.redColor),
            SizedBox(height: Dimensions.h(16)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4.copyWith(color: AppColors.blackColor),
            ),
          ],
        ),
      ),
      barrierDismissible: true,
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.isDialogOpen == true) Get.back();
    });
  }

  static void confirm({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmLabel = 'Yes',
    String cancelLabel = 'No',
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      _AlertWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleIcon(
              icon: Icons.help_outline_rounded,
              color: AppColors.primaryColor,
            ),
            SizedBox(height: Dimensions.h(16)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h3.copyWith(color: AppColors.blackColor),
            ),
            SizedBox(height: Dimensions.h(8)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.darkGreyColor,
              ),
            ),
            SizedBox(height: Dimensions.h(24)),
            Row(
              children: [
                Expanded(
                  child: _AlertButton(
                    label: cancelLabel,
                    isOutlined: true,
                    onTap: () {
                      Get.back();
                      onCancel?.call();
                    },
                  ),
                ),
                SizedBox(width: Dimensions.w(12)),
                Expanded(
                  child: _AlertButton(
                    label: confirmLabel,
                    onTap: () {
                      Get.back();
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void delete({
    required String message,
    required VoidCallback onDelete,
    String title = 'Delete',
  }) {
    Get.dialog(
      _AlertWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _CircleIcon(
              icon: Icons.delete_outline_rounded,
              color: AppColors.redColor,
            ),
            SizedBox(height: Dimensions.h(16)),
            Text(
              title,
              style: AppTextStyles.h3.copyWith(color: AppColors.blackColor),
            ),
            SizedBox(height: Dimensions.h(8)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(
                color: AppColors.darkGreyColor,
              ),
            ),
            SizedBox(height: Dimensions.h(24)),
            Row(
              children: [
                Expanded(
                  child: _AlertButton(
                    label: 'Cancel',
                    isOutlined: true,
                    onTap: () => Get.back(),
                  ),
                ),
                SizedBox(width: Dimensions.w(12)),
                Expanded(
                  child: _AlertButton(
                    label: 'Delete',
                    color: AppColors.redColor,
                    onTap: () {
                      Get.back();
                      onDelete();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void warning({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    String confirmLabel = 'Yes, Continue',
    String cancelLabel = 'Cancel',
    VoidCallback? onCancel,
  }) {
    Get.dialog(
      _AlertWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.redColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.redColor, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.priority_high,
                  color: AppColors.redColor,
                  size: 16,
                ),
              ),
            ),
            SizedBox(height: Dimensions.h(16)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4.copyWith(color: AppColors.blackColor),
            ),
            SizedBox(height: Dimensions.h(8)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.darkGreyColor,
                height: 1.5,
              ),
            ),
            SizedBox(height: Dimensions.h(24)),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      onCancel?.call();
                    },
                    child: Container(
                      height: Dimensions.h(44),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(Dimensions.r(8)),
                        border: Border.all(
                          color: AppColors.greyColor.withOpacity(0.3),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cancelLabel,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.greyColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.w(12)),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      onConfirm();
                    },
                    child: Container(
                      height: Dimensions.h(44),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(Dimensions.r(8)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        confirmLabel,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void actionConfirm({
    required String title,
    required String message,
    required VoidCallback onConfirm,
    required String confirmLabel,
    String cancelLabel = 'Cancel',
  }) {
    Get.dialog(
      _AlertWrapper(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.new_releases_outlined,
              color: AppColors.redColor,
              size: Dimensions.rs(56),
            ),
            SizedBox(height: Dimensions.h(16)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.h4.copyWith(
                color: AppColors.blackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: Dimensions.h(8)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.darkGreyColor,
              ),
            ),
            SizedBox(height: Dimensions.h(24)),
            Row(
              children: [
                Expanded(
                  child: _AlertButton(
                    label: cancelLabel,
                    isOutlined: true,
                    onTap: () => Get.back(),
                  ),
                ),
                SizedBox(width: Dimensions.w(12)),
                Expanded(
                  child: _AlertButton(
                    label: confirmLabel,
                    color: AppColors.redColor.withOpacity(0.1),
                    textColor: AppColors.redColor,
                    onTap: () {
                      Get.back();
                      onConfirm();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AlertWrapper extends StatelessWidget {
  final Widget child;
  const _AlertWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.r(20)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.w(24),
          vertical: Dimensions.h(28),
        ),
        child: child,
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _CircleIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 2),
      ),
      child: Icon(icon, color: color, size: 32),
    );
  }
}

class _AlertButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isOutlined;
  final Color? color;
  final Color? textColor;

  const _AlertButton({
    required this.label,
    required this.onTap,
    this.isOutlined = false,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppColors.primaryColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Dimensions.h(48),
        decoration: BoxDecoration(
          color: isOutlined ? AppColors.whiteColor : btnColor,
          borderRadius: BorderRadius.circular(Dimensions.r(12)),
          border: Border.all(
            color: isOutlined ? AppColors.greyColor.withOpacity(0.3) : btnColor,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color:
                textColor ??
                (isOutlined ? AppColors.darkGreyColor : AppColors.whiteColor),
          ),
        ),
      ),
    );
  }
}
