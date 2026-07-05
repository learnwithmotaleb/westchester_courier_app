import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helper/local_db/local_db.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> mode = ThemeMode.system.obs;

  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    // Ensure SharePrefs is initialized before getting theme
    await SharePrefsHelper.init();
    mode.value = SharePrefsHelper.getThemeMode();
    isInitialized.value = true;
    Get.changeThemeMode(mode.value);
  }

  void setThemeMode(ThemeMode m) {
    mode.value = m;
    SharePrefsHelper.saveThemeMode(m);
    Get.changeThemeMode(m);
  }

  void toggle() {
    setThemeMode(
      mode.value == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark,
    );
  }
}
