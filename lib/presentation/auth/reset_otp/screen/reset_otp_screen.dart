import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/utils/app_icons/app_icons.dart';
import 'package:westchester/utils/app_text_style/app_text_style.dart';
import 'package:westchester/widget/app_button.dart';
import 'package:westchester/presentation/auth/email_verfication/widget/timer_widget.dart';
import '../controller/reset_otp_controller.dart';

class ResetOtpScreen extends StatefulWidget {
  const ResetOtpScreen({super.key});

  @override
  State<ResetOtpScreen> createState() => _ResetOtpScreenState();
}

class _ResetOtpScreenState extends State<ResetOtpScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var c in _controllers) {
      c.dispose();
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
    final controller = Get.find<ResetOtpController>();
    controller.otpController.text =
        _controllers.map((c) => c.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ResetOtpController>();
    final email = (Get.arguments as Map<String, dynamic>?)?['email'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.w(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.h(40)),

              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: Dimensions.w(40),
                    height: Dimensions.w(40),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryColor.withOpacity(0.08),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: Dimensions.w(18),
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),

              SizedBox(height: Dimensions.h(30)),

              // App Logo
              Image.asset(AppIcons.appLogo, width: Dimensions.w(120)),

              SizedBox(height: Dimensions.h(30)),

              Text(
                'Check Your Email',
                textAlign: TextAlign.center,
                style: AppTextStyles.h2.copyWith(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),

              SizedBox(height: Dimensions.h(8)),

              Text(
                'We sent a reset code to\n$email',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.darkGreyColor,
                ),
              ),

              SizedBox(height: Dimensions.h(32)),

              // OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _buildOtpBox(i)),
              ),

              SizedBox(height: Dimensions.h(40)),

              Obx(() => AppButton(
                    label: 'Verify Code',
                    onPressed: controller.verifyResetOtp,
                    isLoading: controller.isLoading.value,
                    backgroundColor: AppColors.primaryColor,
                    textColor: AppColors.whiteColor,
                    borderSideColor: AppColors.primaryColor,
                    borderRadius: Dimensions.r(8),
                  )),

              SizedBox(height: Dimensions.h(32)),

              TimerWidget(onResendCode: controller.resendCode),
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
          counterText: '',
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
            borderSide:
                const BorderSide(color: AppColors.primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}
