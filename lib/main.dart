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

  // ── Register permanent services ───────────────────────────────
  Get.put(InternetController(), permanent: true);
  Get.put(LanguageController(), permanent: true);


  // GoogleMapServices auto-fetches real GPS in onInit()
  // Location permission is already granted above before this runs
  runApp(MyApp());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _initializeLocationServices();
  });
}

/// Requests location permission using geolocator's native dialog.
/// Notification permission is handled internally by the notification package.
Future<void> _initializeLocationServices() async {
  if (!PlatformHelper.isMobile) {
    Get.put(GoogleMapServices(), permanent: true);
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    final shouldContinue = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Location access for deliveries'),
        content: const Text(
          'Westchester Courier collects location data to track delivery '
          'progress and provide route and dispatch functionality, even when '
          'the app is closed or not in use. Location is sent securely to '
          'Westchester Courier while you are completing deliveries. Tap '
          'Continue to choose your permission in the next system dialog.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Continue'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (shouldContinue == true) {
      permission = await Geolocator.requestPermission();
    }
  }

  if (!Get.isRegistered<GoogleMapServices>()) {
    Get.put(GoogleMapServices(), permanent: true);
  }
}
