import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/widget/app_button.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';

import '../controller/otp_verify_controller.dart';
import '../widget/timer_widget.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    
    // Update main controller
    final controller = Get.find<OtpVerifyController>();
    String code = _controllers.map((c) => c.text).join();
    controller.otpController.text = code;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OtpVerifyController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.h(40)),
              
              // App Logo
              Image.asset(AppIcons.appLogo, width: Dimensions.w(120)),
              
              SizedBox(height: Dimensions.h(30)),
              
              Text(
                "Email Verification",
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              SizedBox(height: Dimensions.h(8)),
              
              Text(
                "Enter the code we have sent your email",
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: Dimensions.h(32)),
              
              // Custom OTP Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpBox(index)),
              ),
              
              SizedBox(height: Dimensions.h(40)),
              
              Obx(() => AppButton(
                label: "Continue",
                onPressed: controller.emailVerifyProcess,
                isLoading: controller.isLoading.value,
                backgroundColor: AppColors.primaryColor,
                textColor: AppColors.whiteColor,
                borderSideColor: AppColors.primaryColor,
                borderRadius: Dimensions.r(8),
              )),

              SizedBox(height: Dimensions.h(32)),
              
              TimerWidget(
                onResendCode: controller.resendOtpProcess,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: Dimensions.w(46),
      height: Dimensions.h(56),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        onChanged: (v) => _onChanged(v, index),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.bodyText.copyWith(
          fontSize: Dimensions.fs(18),
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: AppColors.whiteColor,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.r(12)),
            borderSide: BorderSide(color: AppColors.inputBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.r(12)),
            borderSide: BorderSide(color: AppColors.inputBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.r(12)),
            borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
