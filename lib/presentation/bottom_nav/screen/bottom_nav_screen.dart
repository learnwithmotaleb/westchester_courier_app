import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/core/responsive_layout/dimensions.dart';
import 'package:westchester/utils/app_colors/app_colors.dart';
import 'package:westchester/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:westchester/presentation/bottom_nav/widget/bottom_nav_item.dart';
import 'package:westchester/presentation/bottom_nav/page/home/screen/home_page.dart';
import 'package:westchester/presentation/bottom_nav/page/request/screen/request_page.dart';
import 'package:westchester/presentation/my_map/screen/my_map_screen.dart';
import 'package:westchester/presentation/bottom_nav/page/setting/setting_page.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  static const List<Widget> _pages = [
    HomePage(),
    RequestPage(),
    MyMapScreen(),
    SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavController>();

    return Obx(() {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: Dimensions.h(64),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BottomNavItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    isActive: controller.currentIndex.value == 0,
                    onTap: () => controller.changePage(0),
                  ),
                  BottomNavItem(
                    icon: Icons.layers_rounded,
                    label: 'Request',
                    isActive: controller.currentIndex.value == 1,
                    onTap: () => controller.changePage(1),
                  ),
                  BottomNavItem(
                    icon: Icons.route_rounded,
                    label: 'Map',
                    isActive: controller.currentIndex.value == 2,
                    onTap: () => controller.changePage(2),
                  ),
                  BottomNavItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    isActive: controller.currentIndex.value == 3,
                    onTap: () => controller.changePage(3),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
