import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/widget/custom_appbar.dart';
import '../controller/terms_condition_controller.dart';

class TermsConditionScreen extends GetView<TermsConditionController> {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CommonAppBar(
        title: 'Terms & Conditions',
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
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.description.value.isEmpty) {
                    return Center(
                      child: Text(
                        'No terms available right now.',
                        style: AppTextStyles.bodyText.copyWith(
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Html(
                      data: controller.description.value,
                      style: {
                        'body': Style(
                          margin: Margins.zero,
                          padding: HtmlPaddings.zero,
                          color: AppColors.textPrimaryColor,
                          fontSize: FontSize(Dimensions.fs(14)),
                          lineHeight: const LineHeight(1.5),
                        ),
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
