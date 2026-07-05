import 'dart:ui';
import 'package:get/get.dart';
import '../../../helper/local_db/local_db.dart';
import '../../../utils/app_const/app_const.dart';

class LanguageController extends GetxController {
  Rx<Locale> currentLocale = const Locale("en", "US").obs;

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  void loadLanguage() {
    final isEnglish =
        SharePrefsHelper.getBool(AppConstants.languageKey) ?? true;
    currentLocale.value =
        isEnglish ? const Locale("en", "US") : const Locale("bg", "BG");
    Get.updateLocale(currentLocale.value);
  }

  Future<void> switchLanguage(bool englishSelected) async {
    currentLocale.value =
        englishSelected ? const Locale("en", "US") : const Locale("bg", "BG");
    Get.updateLocale(currentLocale.value);
    await SharePrefsHelper.setBool(AppConstants.languageKey, englishSelected);
  }

  bool get isEnglish => currentLocale.value.languageCode == "en";
}
