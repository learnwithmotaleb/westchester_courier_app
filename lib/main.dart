import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'core/device_utls/device_utils.dart';
import 'core/platform/platform_helper.dart';
import 'global/language/controller/language_controller.dart';
import 'helper/local_db/local_db.dart';
import 'helper/no_internet/controller/no_internet_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // Initialize SharedPreferences first
  await SharePrefsHelper.init();

  // Initialize Google Sign-In (v7.x requirement)
  // NOTE: On Android, you MUST provide the serverClientId (Web Client ID) from Firebase Console.
  // Location: Firebase Console -> Project Settings -> General -> Web API Key/OAuth 2.0 Client IDs -> Web client
  // await GoogleSignIn.instance.initialize(
  //   serverClientId: '222750300065-xxxxxxxxxxxxxxxx.apps.googleusercontent.com', // Replace with your Web Client ID
  // );

  // Lock device orientation only on mobile
  if (PlatformHelper.isMobile) {
    DeviceUtils.lockDevicePortrait();
  }

  // Controllers
  Get.put(InternetController(), permanent: true);
  Get.put(LanguageController(), permanent: true);
  // Get.put(DeliveryController(), permanent: true);

  runApp(MyApp());
}


