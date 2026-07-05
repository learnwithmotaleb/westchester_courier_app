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

import '../../presentation/bottom_nav/screen/bottom_nav_screen.dart';
import '../../presentation/bottom_nav/controller/bottom_nav_controller.dart';

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
    GetPage(
      name: RoutePath.bottomNav,
      page: () => const BottomNavScreen(),
      transition: Transition.rightToLeft,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => BottomNavController());
      }),
    ),
  ];
}
