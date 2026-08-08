import 'dart:convert';
import 'package:get/get.dart';
import '../../../service/api_service.dart';
import '../../../service/api_url.dart';
import '../../../helper/tost_message/show_snackbar.dart';
import '../model/NotificationModel.dart' as nm;
import '../model/UnreadCoundModel.dart';
import '../../../helper/local_db/local_db.dart';

class NotificationController extends GetxController {
  final notifications = <nm.Data>[].obs;
  final isLoading = false.obs;
  final unreadCount = 0.obs;

  static NotificationController get to => Get.find<NotificationController>();

  void loadLocalNotifications() {
    fetchNotifications();
    fetchUnreadCount();
  }

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
    fetchUnreadCount();
  }

  Future<void> fetchNotifications() async {
    Get.log('🔥 [DEBUG] fetchNotifications() called! 🔥');
    isLoading.value = true;
    try {
      final response = await ApiClient().get(
        url: ApiUrl.notification,
        isToken: true,
      );
      if (response.statusCode == 200 && response.body != null) {
        try {
          final dynamic body = response.body;
          final Map<String, dynamic> jsonMap = body is String
              ? jsonDecode(body)
              : body;
          final model = nm.NotificationModel.fromJson(jsonMap);
          notifications.assignAll(model.data ?? []);
        } catch (parseError) {
          Get.log('JSON Parse Error in notifications: $parseError');
        }
      } else {
        Get.log(
          'Failed to load notifications: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      Get.log('Error fetching notifications: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUnreadCount() async {
    try {
      final response = await ApiClient().get(
        url: ApiUrl.notificationUnreadCount(''),
        isToken: true,
      );
      if (response.statusCode == 200) {
        final model = NotificationUnreadModel.fromJson(response.body);
        unreadCount.value = (model.data?.unreadCount ?? 0).toInt();
      }
    } catch (e) {
      // Silently fail for unread count
    }
  }

  Future<void> markAsRead(String id) async {
    final notification = notifications.firstWhereOrNull(
      (n) => n.sId?.toString() == id,
    );
    if (notification != null && notification.isRead == false) {
      // Optimistic update
      final index = notifications.indexOf(notification);
      notifications[index] = notification.copyWith(isRead: true);
      if (unreadCount.value > 0) unreadCount.value--;

      try {
        await ApiClient().patch(
          url: ApiUrl.notificationRead(id),
          isToken: true,
        );
      } catch (e) {
        // Revert on failure
        notifications[index] = notification.copyWith(isRead: false);
        unreadCount.value++;
      }
    }
  }

  Future<void> markAllAsRead() async {
    if (unreadCount.value == 0) return;

    // Optimistic update
    final prevUnreadCount = unreadCount.value;
    unreadCount.value = 0;

    final updatedList = notifications.map((n) {
      return n.isRead == false ? n.copyWith(isRead: true) : n;
    }).toList();

    final prevList = List<nm.Data>.from(notifications);
    notifications.assignAll(updatedList);

    try {
      final response = await ApiClient().patch(
        url: ApiUrl.notificationReadAll,
        isToken: true,
      );
      if (response.statusCode != 200) {
        throw Exception();
      }
    } catch (e) {
      // Revert on failure
      unreadCount.value = prevUnreadCount;
      notifications.assignAll(prevList);
      AppSnackBar.fail('Failed to mark all as read');
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final response = await ApiClient().delete(
        url: ApiUrl.notificationDelete(id),
        isToken: true,
      );
      if (response.statusCode == 200) {
        notifications.removeWhere((n) => n.sId?.toString() == id);
        fetchUnreadCount(); // Refresh count just in case
      } else {
        AppSnackBar.fail(
          response.statusText ?? 'Failed to delete notification',
        );
      }
    } catch (e) {
      AppSnackBar.fail('Error: $e');
    }
  }

  Future<void> updateFcmToken() async {
    try {
      String? fcmToken = SharePrefsHelper.getFcmToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        final response = await ApiClient().patch(
          url: ApiUrl.updateFcmToken,
          body: {"fcmToken": fcmToken},
          isToken: true,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.log('FCM token updated successfully');
        } else {
          Get.log('Failed to update FCM token');
        }
      }
    } catch (e) {
      Get.log('Error updating FCM token: $e');
    }
  }
}
