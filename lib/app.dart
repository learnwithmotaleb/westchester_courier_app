import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/routes/route_path.dart';
import 'core/routes/routes.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/theme/theme_controller.dart';
import 'global/language/controller/language_controller.dart';
import 'global/language/languages.dart';
import 'helper/no_internet/screen/no_internet_screen.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key}) {
    // ThemeController handles its own initialization via SharedPreferences
    Get.put(ThemeController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final LanguageController lc = Get.find<LanguageController>();

    return Obx(() {
      return GetMaterialApp(
        title: 'BestKits',
        debugShowCheckedModeBanner: false,

        // Theme Configuration
        theme: lightTheme,
        darkTheme: lightTheme,
        themeMode: themeController.isInitialized.value
            ? themeController.mode.value
            : ThemeMode.system,

        // Localization
        translations: Language(),
        locale: lc.currentLocale.value,
        fallbackLocale: const Locale('en', 'US'),

        // Routing
        getPages: AppRouter.pages,
        initialRoute: RoutePath.splash,

        // Global Wrappers
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: InternetWrapper(
              child: child ?? const SizedBox(),
            ),
          );
        },
      );
    });
  }
}