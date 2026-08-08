import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'core/device_utls/device_utils.dart';
import 'core/platform/platform_helper.dart';
import 'global/language/controller/language_controller.dart';
import 'helper/local_db/local_db.dart';
import 'helper/no_internet/controller/no_internet_controller.dart';
import 'service/google_map_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences first
  await SharePrefsHelper.init();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseNotificationService().initialize();

  // Lock device orientation only on mobile
  if (PlatformHelper.isMobile) {
    DeviceUtils.lockDevicePortrait();
  }

  // ── Request location permission (geolocator built-in dialog) ──
  await _requestLocationPermission();

  // ── Register permanent services ───────────────────────────────
  Get.put(InternetController(), permanent: true);
  Get.put(LanguageController(), permanent: true);


  // GoogleMapServices auto-fetches real GPS in onInit()
  // Location permission is already granted above before this runs
  Get.put(GoogleMapServices(), permanent: true);

  runApp(MyApp());
}

/// Requests location permission using geolocator's native dialog.
/// Notification permission is handled internally by the notification package.
Future<void> _requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    // Opens device App Settings so user can enable manually
    await Geolocator.openAppSettings();
  }
}
