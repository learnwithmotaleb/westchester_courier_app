import 'package:get/get.dart';
import 'package:westchester/core/routes/route_path.dart';

import '../../presentation/splash/screen/splash_screen.dart';
import '../../presentation/splash/controller/splash_controller.dart';

import '../../presentation/auth/login/screen/login_screen.dart';
import '../../presentation/auth/login/controller/login_controller.dart';

import '../../presentation/auth/signup/screen/signup_screen.dart';
import '../../presentation/auth/signup/controller/signup_controller.dart';

import '../../presentation/auth/email_verfication/screen/otp_verify_screen.dart';
import '../../presentation/auth/email_verfication/controller/otp_verify_controller.dart';

import '../../presentation/auth/driver_verification/screen/driver_verification_screen.dart';
import '../../presentation/auth/driver_verification/controller/driver_verification_controller.dart';

import '../../presentation/auth/verification_success/screen/verification_success_screen.dart';

import '../../presentation/auth/wellcome/screen/welcome_screen.dart';
import '../../presentation/auth/wellcome/controller/welcome_controller.dart';

import '../../presentation/auth/forgot_password/screen/forgot_password_screen.dart';
import '../../presentation/auth/forgot_password/controller/forgot_password_controller.dart';

import '../../presentation/auth/reset_otp/screen/reset_otp_screen.dart';
import '../../presentation/auth/reset_otp/controller/reset_otp_controller.dart';

import '../../presentation/auth/reset_password/screen/reset_password_screen.dart';
import '../../presentation/auth/reset_password/controller/reset_password_controller.dart';

import '../../presentation/bottom_nav/screen/bottom_nav_screen.dart';
import '../../presentation/bottom_nav/controller/bottom_nav_controller.dart';

import '../../presentation/account_setting/screen/account_setting_screen.dart';
import '../../presentation/account_setting/controller/account_setting_controller.dart';

import '../../presentation/change_password/screen/change_password_screen.dart';
import '../../presentation/change_password/controller/change_password_controller.dart';

import '../../presentation/job_history/screen/job_history_screen.dart';
import '../../presentation/job_history/controller/job_history_controller.dart';

import '../../presentation/contact_support/screen/contact_support_screen.dart';
import '../../presentation/contact_support/controller/contact_support_controller.dart';

import '../../presentation/update_profile/screen/update_profile_screen.dart';
import '../../presentation/update_profile/controller/update_profile_controller.dart';

import '../../presentation/terms_condition/screen/terms_condition_screen.dart';
import '../../presentation/terms_condition/controller/terms_condition_controller.dart';

import '../../presentation/privacy_policy/screen/privacy_policy_screen.dart';
import '../../presentation/privacy_policy/controller/privacy_policy_controller.dart';

import '../../presentation/job_details/screen/job_details_screen.dart';
import '../../presentation/job_details/controller/job_details_controller.dart';

import '../../presentation/delivery_proof/screen/delivery_proof_screen.dart';
import '../../presentation/delivery_proof/controller/delivery_proof_controller.dart';

import '../../presentation/report_issus/screen/report_issus_screen.dart';
import '../../presentation/report_issus/controller/report_issus_controller.dart';

import '../../presentation/notification/screen/notification_screen.dart';
import '../../presentation/notification/controller/notification_controller.dart';

class AppRouter {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: RoutePath.splash,
      page: () => const SplashScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.put(SplashController());
      }),
    ),
    GetPage(
      name: RoutePath.login,
      page: () => const LoginScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginController());
      }),
    ),
    GetPage(
      name: RoutePath.signup,
      page: () => const SignupScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SignupController());
      }),
    ),
    GetPage(
      name: RoutePath.emailVerification,
      page: () => const OtpVerifyScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => OtpVerifyController());
      }),
    ),
    GetPage(
      name: RoutePath.driverVerification,
      page: () => const DriverVerificationScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DriverVerificationController());
      }),
    ),
    GetPage(
      name: RoutePath.verificationSuccess,
      page: () => const VerificationSuccessScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: RoutePath.welcome,
      page: () => const WelcomeScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WelcomeController());
      }),
    ),

    // ── Forgot Password Flow ──
    GetPage(
      name: RoutePath.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ForgotPasswordController());
      }),
    ),
    GetPage(
      name: RoutePath.resetOtp,
      page: () => const ResetOtpScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ResetOtpController());
      }),
    ),
    GetPage(
      name: RoutePath.resetPassword,
      page: () => const ResetPasswordScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ResetPasswordController());
      }),
    ),

    GetPage(
      name: RoutePath.bottomNav,
      page: () => const BottomNavScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => BottomNavController());
      }),
    ),
    GetPage(
      name: RoutePath.accountSetting,
      page: () => const AccountSettingScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AccountSettingController());
      }),
    ),
    GetPage(
      name: RoutePath.changePassword,
      page: () => const ChangePasswordScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ChangePasswordController());
      }),
    ),
    GetPage(
      name: RoutePath.jobHistory,
      page: () => const JobHistoryScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => JobHistoryController());
      }),
    ),
    GetPage(
      name: RoutePath.contactSupport,
      page: () => const ContactSupportScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ContactSupportController());
      }),
    ),
    GetPage(
      name: RoutePath.updateProfile,
      page: () => const UpdateProfileScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => UpdateProfileController());
      }),
    ),
    GetPage(
      name: RoutePath.termsCondition,
      page: () => const TermsConditionScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => TermsConditionController());
      }),
    ),
    GetPage(
      name: RoutePath.privacyPolicy,
      page: () => const PrivacyPolicyScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => PrivacyPolicyController());
      }),
    ),
    GetPage(
      name: RoutePath.jobDetails,
      page: () => const JobDetailsScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => JobDetailsController());
      }),
    ),
    GetPage(
      name: RoutePath.deliveryProof,
      page: () => const DeliveryProofScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => DeliveryProofController());
      }),
    ),
    GetPage(
      name: RoutePath.reportIssue,
      page: () => const ReportIssusScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ReportIssusController());
      }),
    ),
    GetPage(
      name: RoutePath.notification,
      page: () => const NotificationScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => NotificationController());
      }),
    ),
  ];
}
