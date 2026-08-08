import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:westchester/widget/custom_appbar.dart';
import '../../../../core/responsive_layout/dimensions.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../controller/notification_controller.dart';
import '../widget/notification_widget.dart'; // Fixed widget import name

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If not found, put it
    final controller = Get.put(NotificationController(), permanent: true);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'Notifications',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => controller.markAllAsRead(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor, // Dark background for eye icon
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.visibility,
                    color: AppColors.whiteColor, size: 18),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primaryColor));
        }

        if (controller.notifications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_none, size: 60, color: Colors.grey[300]),
                const SizedBox(height: 10),
                Text(
                  'No notifications found',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.primaryColor,
          onRefresh: () => controller.fetchNotifications(),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.w(20), vertical: 16),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return Dismissible(
                key: Key(notification.sId.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  controller.deleteNotification(notification.sId.toString());
                },
                child: GestureDetector(
                  onTap: () => controller.markAsRead(notification.sId.toString()),
                  child: NotificationItem(notification: notification),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
