import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../../../utils/app_text_style/app_text_style.dart';
import '../../../utils/static_strings/static_strings.dart';
import '../controller/no_internet_controller.dart';

class InternetWrapper extends StatelessWidget {
  final Widget child;

  const InternetWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InternetController>();

    return Obx(() {
      return Stack(
        children: [
          child,

          // No Internet Overlay
          if (!controller.isConnected.value)
            Container(
              color: AppColors.backgroundColor,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.wifi_off_rounded,
                          size: 60,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        AppStrings.noInternetConnection.tr,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.blackColor,
                          decoration: TextDecoration.none,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppStrings.checkYourInternet.tr,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.greyColor,
                          decoration: TextDecoration.none,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
