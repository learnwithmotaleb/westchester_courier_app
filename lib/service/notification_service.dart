import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../presentation/notification/controller/notification_controller.dart';
import '../helper/local_db/local_db.dart';
import '../core/routes/route_path.dart';
import '../core/platform/platform_helper.dart'; // <-- Added PlatformHelper
import 'api_service.dart';
import 'api_url.dart';

/// ──────────────────────────────────────────────────────────────────────────────
/// TOP-LEVEL BACKGROUND HANDLER
/// Must be a top-level function (not a class method) for Firebase to invoke it
/// when the app is terminated or in background.
/// ──────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('🔔 [BG] Message: ${message.messageId}');
  debugPrint('🔔 [BG] Title : ${message.notification?.title}');
  debugPrint('🔔 [BG] Body  : ${message.notification?.body}');
  debugPrint('🔔 [BG] Data  : ${message.data}');

  // Show local notification for data-only messages in background
  await FirebaseNotificationService._showBackgroundNotification(message);
}

/// ──────────────────────────────────────────────────────────────────────────────
/// FIREBASE NOTIFICATION SERVICE  (Singleton)
/// Handles: FCM token, foreground, background, terminated, lock-screen,
///          topic subscriptions, and local notification display.
/// ──────────────────────────────────────────────────────────────────────────────
class FirebaseNotificationService {
  // ── Singleton ──────────────────────────────────────────────────────────────
  FirebaseNotificationService._internal();
  static final FirebaseNotificationService _instance =
      FirebaseNotificationService._internal();
  factory FirebaseNotificationService() => _instance;

  // ── Instances ──────────────────────────────────────────────────────────────
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  // ── Notification Channel IDs ───────────────────────────────────────────────
  static const String _rideChannelId = 'ride_notifications';
  static const String _rideChannelName = 'Ride Notifications';
  static const String _rideChannelDesc =
      'Notifications for ride requests and updates';

  static const String _generalChannelId = 'general_notifications';
  static const String _generalChannelName = 'General Notifications';
  static const String _generalChannelDesc = 'General app notifications';

  static const String _highPriorityChannelId = 'high_priority_notifications';
  static const String _highPriorityChannelName = 'Urgent Notifications';
  static const String _highPriorityChannelDesc =
      'High-priority notifications that appear on lock screen';

  // ── State ──────────────────────────────────────────────────────────────────
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  // ── Callbacks ──────────────────────────────────────────────────────────────
  /// Override this to handle notification taps from your UI layer.
  Function(Map<String, dynamic> data)? onNotificationTap;

  /// Override this to handle foreground messages from your UI layer.
  Function(RemoteMessage message)? onForegroundMessage;

  // ═══════════════════════════════════════════════════════════════════════════
  //  INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Call once in `main()` after `Firebase.initializeApp()`.
  Future<void> initialize() async {
    // 0. Initialize Timezones for scheduled notifications
    tz.initializeTimeZones();

    // 1. Register the background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 2. Request permissions (Android 13+ & iOS)
    await _requestPermissions();

    // 3. Setup local notification channels
    await _initLocalNotifications();

    // 4. Get FCM token
    await _obtainFCMToken();

    // 5. Listen to token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      debugPrint('🔄 FCM Token refreshed: $newToken');
      _saveTokenToServer(newToken);
    });

    // 6. Setup foreground message listener
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 7. Handle notification taps (app opened from background/terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // 8. Check if app was opened from a terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // 9. Setup foreground notification presentation (iOS)
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('✅ FirebaseNotificationService initialized');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  PERMISSIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _requestPermissions() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true, // for urgent ride alerts
      provisional: false,
      sound: true,
    );

    debugPrint('🔐 Notification permission: ${settings.authorizationStatus}');

    // Android 13+ explicit notification permission
    if (PlatformHelper.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.requestNotificationsPermission();
      await androidPlugin?.requestExactAlarmsPermission();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  LOCAL NOTIFICATION SETUP
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _initLocalNotifications() async {
    // Android initialization
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher', // uses your app icon
    );

    // iOS initialization
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );

    // Create Android notification channels
    if (PlatformHelper.isAndroid) {
      final androidPlugin = _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      // Ride notifications channel
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _rideChannelId,
          _rideChannelName,
          description: _rideChannelDesc,
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        ),
      );

      // General notifications channel
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _generalChannelId,
          _generalChannelName,
          description: _generalChannelDesc,
          importance: Importance.defaultImportance,
          playSound: true,
        ),
      );

      // High-priority notifications channel (lock screen visible)
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _highPriorityChannelId,
          _highPriorityChannelName,
          description: _highPriorityChannelDesc,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          showBadge: true,
        ),
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  FCM TOKEN
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _obtainFCMToken() async {
    try {
      _fcmToken = await _messaging.getToken();
      debugPrint('📱 FCM Token: $_fcmToken');

      if (_fcmToken != null) {
        await _saveTokenToServer(_fcmToken!);
      }
    } catch (e) {
      debugPrint('❌ Failed to get FCM token: $e');
    }
  }

  /// Returns the current FCM token.
  Future<String?> getFCMToken() async {
    _fcmToken ??= await _messaging.getToken();
    return _fcmToken;
  }

  /// Save token to your backend / Firestore / SharedPreferences.
  Future<void> _saveTokenToServer(String token) async {
    try {
      await SharePrefsHelper.saveFcmToken(token);
      debugPrint('💾 FCM token saved to SharedPreferences: $token');

      // Check if user is logged in (auth token exists)
      final userToken = SharePrefsHelper.getToken();
      if (userToken != null && userToken.isNotEmpty) {
        debugPrint('🌐 Sending updated FCM token to backend...');
        final response = await ApiClient().patch(
          url: ApiUrl.updateFcmToken,
          body: {"fcmToken": token},
          isToken: true,
        );
        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('✅ FCM token successfully updated on backend');
        } else {
          debugPrint(
            '❌ Failed to update FCM token on backend: ${response.body}',
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Error in _saveTokenToServer: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  FOREGROUND MESSAGE HANDLING
  // ═══════════════════════════════════════════════════════════════════════════

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📩 [FG] Message received: ${message.messageId}');
    debugPrint('📩 [FG] Title: ${message.notification?.title}');
    debugPrint('📩 [FG] Body : ${message.notification?.body}');
    debugPrint('📩 [FG] Data : ${message.data}');
    debugPrint(
      '📩 [FG] Full Message: ${message.toMap()}',
    ); // Added to print all notification details

    // Invoke external callback if set
    onForegroundMessage?.call(message);

    // Show a local notification so the user sees it even in foreground
    _showLocalNotification(message);

    // Refresh notification list if controller is available
    try {
      if (Get.isRegistered<NotificationController>()) {
        NotificationController.to.loadLocalNotifications();
        debugPrint(
          '📩 [FG] Current Notifications Count: ${NotificationController.to.notifications.length}',
        );
      }

      // Print all notifications saved in local DB
      final localNotifs = SharePrefsHelper.getLocalNotifications();
      debugPrint('📩 [FG] All Local Notifications: $localNotifs');
    } catch (e) {
      debugPrint('❌ Error refreshing notification list: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  NOTIFICATION TAP HANDLING
  // ═══════════════════════════════════════════════════════════════════════════

  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('👆 Notification tapped: ${message.data}');

    final data = message.data;
    onNotificationTap?.call(data);

    // Route based on notification data
    _routeFromNotification(data);
  }

  void _onLocalNotificationTap(NotificationResponse response) {
    debugPrint('👆 Local notification tapped: ${response.payload}');

    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        onNotificationTap?.call(data);
        _routeFromNotification(data);
      } catch (e) {
        debugPrint('❌ Error parsing notification payload: $e');
      }
    }
  }

  /// Routes to the correct screen based on notification data.
  void _routeFromNotification(Map<String, dynamic> data) {
    // If context is null, it means the app was launched from a terminated state
    // and GetMaterialApp is not yet ready. We wait a bit before routing.
    if (Get.context == null) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        Get.toNamed(RoutePath.notification);
      });
    } else {
      Get.toNamed(RoutePath.notification);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SHOW LOCAL NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Show a notification from a Firebase RemoteMessage.
  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    final title = notification?.title ?? data['title'] ?? 'JeebJab';
    final body = notification?.body ?? data['body'] ?? '';
    final channelId = _getChannelId(data['type']);

    await showNotification(
      title: title,
      body: body,
      payload: data,
      channelId: channelId,
    );
  }

  /// Show a background notification (called from top-level handler).
  static Future<void> _showBackgroundNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    // If it has a notification payload, Android auto-shows it.
    // Only manually show for data-only messages.
    if (notification != null) {
      // Still save it to local history!
      await _saveNotification(
        title: notification.title ?? 'JeebJab',
        body: notification.body ?? '',
        data: data,
      );
      return;
    }

    final title = data['title'] ?? 'JeebJab';
    final body = data['body'] ?? '';

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _highPriorityChannelId,
          _highPriorityChannelName,
          channelDescription: _highPriorityChannelDesc,
          importance: Importance.max,
          priority: Priority.max,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          visibility: NotificationVisibility.public, // Lock screen visible
          fullScreenIntent: true, // Wake up the screen
          category: AndroidNotificationCategory.message,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      payload: jsonEncode(data),
    );

    // Save to local history for background messages
    await _saveNotification(title: title, body: body, data: data);
  }

  /// Public method – call this from anywhere in the app to show a
  /// notification manually.
  Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
    String? channelId,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final channel = channelId ?? _generalChannelId;

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          _getChannelName(channel),
          channelDescription: _getChannelDesc(channel),
          importance: channel == _highPriorityChannelId
              ? Importance.max
              : Importance.high,
          priority: channel == _highPriorityChannelId
              ? Priority.max
              : Priority.high,
          showWhen: true,
          enableVibration: true,
          playSound: true,
          visibility: NotificationVisibility.public, // Show on lock screen
          category: AndroidNotificationCategory.message,
          styleInformation: BigTextStyleInformation(
            body,
            contentTitle: title,
            htmlFormatContent: true,
            htmlFormatContentTitle: true,
          ),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      payload: payload != null ? jsonEncode(payload) : null,
    );

    // Save to local history
    await _saveNotification(title: title, body: body, data: payload);
  }

  /// Show a ride-specific notification with high priority.
  Future<void> showRideNotification({
    required String title,
    required String body,
    String? rideId,
    String? type,
  }) async {
    await showNotification(
      title: title,
      body: body,
      payload: {'type': type ?? 'ride_request', 'ride_id': rideId ?? ''},
      channelId: _highPriorityChannelId,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  RICH & SCHEDULED NOTIFICATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Download an image from URL to a local file.
  Future<String?> _downloadAndSaveFile(String url, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      await Dio().download(url, filePath);
      return filePath;
    } catch (e) {
      debugPrint('❌ Error downloading image: $e');
      return null;
    }
  }

  /// Show a rich notification with an image and optional action buttons.
  Future<void> showRichNotification({
    required String title,
    required String body,
    required String imageUrl,
    Map<String, dynamic>? payload,
    String? channelId,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final channel = channelId ?? _generalChannelId;

    final imagePath = await _downloadAndSaveFile(
      imageUrl,
      'notification_img_$id.jpg',
    );

    AndroidNotificationDetails androidPlatformChannelSpecifics;
    DarwinNotificationDetails iOSPlatformChannelSpecifics;

    if (imagePath != null) {
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channel,
        _getChannelName(channel),
        channelDescription: _getChannelDesc(channel),
        importance: Importance.max,
        priority: Priority.max,
        showWhen: true,
        enableVibration: true,
        playSound: true,
        visibility: NotificationVisibility.public,
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(imagePath),
          contentTitle: title,
          summaryText: body,
          htmlFormatContentTitle: true,
          htmlFormatSummaryText: true,
        ),
      );
      iOSPlatformChannelSpecifics = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        attachments: [DarwinNotificationAttachment(imagePath)],
      );
    } else {
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channel,
        _getChannelName(channel),
        channelDescription: _getChannelDesc(channel),
        importance: Importance.max,
        priority: Priority.max,
      );
      iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    }

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      ),
      payload: payload != null ? jsonEncode(payload) : null,
    );

    // Save to local history
    await _saveNotification(
      title: title,
      body: body,
      data: payload?..addAll({'imagePath': imagePath ?? ''}),
    );
  }

  /// Schedule a notification to appear at a specific time.
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    Map<String, dynamic>? payload,
    String? channelId,
  }) async {
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final channel = channelId ?? _generalChannelId;

    await _localNotifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          channel,
          _getChannelName(channel),
          channelDescription: _getChannelDesc(channel),
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload != null ? jsonEncode(payload) : null,
    );
    debugPrint('⏰ Notification scheduled for: $scheduledDate');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  TOPIC SUBSCRIPTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    debugPrint('📌 Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    debugPrint('📌 Unsubscribed from topic: $topic');
  }

  /// Subscribe to common topics.
  Future<void> subscribeToDefaultTopics() async {
    await subscribeToTopic('all_users');
    await subscribeToTopic('riders');
    await subscribeToTopic('promotions');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  SEND NOTIFICATION VIA FCM HTTP API (v1)
  // ═══════════════════════════════════════════════════════════════════════════

  /// Send a notification to a specific device using FCM REST API.
  static Future<bool> sendNotificationViaAPI({
    required String targetToken,
    required String title,
    required String body,
    Map<String, String>? data,
    String? serverKey, // Legacy API key (for testing only)
  }) async {
    try {
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

      final payload = {
        'to': targetToken,
        'notification': {'title': title, 'body': body, 'sound': 'default'},
        'data': data ?? {},
        'priority': 'high',
        'content_available': true,
      };

      final client = HttpClient();
      final request = await client.postUrl(url);
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Authorization', 'key=${serverKey ?? ''}');
      request.write(jsonEncode(payload));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      debugPrint('📤 FCM API Response: $responseBody');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('❌ FCM API Error: $e');
      return false;
    }
  }

  /// Send a notification to a topic using FCM REST API.
  static Future<bool> sendToTopicViaAPI({
    required String topic,
    required String title,
    required String body,
    Map<String, String>? data,
    String? serverKey,
  }) async {
    return sendNotificationViaAPI(
      targetToken: '/topics/$topic',
      title: title,
      body: body,
      data: data,
      serverKey: serverKey,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Delete the FCM token (e.g., on logout).
  Future<void> deleteToken() async {
    await _messaging.deleteToken();
    _fcmToken = null;
    debugPrint('🗑️ FCM Token deleted');
  }

  /// Cancel all displayed notifications.
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Cancel a specific notification by ID.
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id: id);
  }

  String _getChannelId(String? type) {
    switch (type) {
      case 'ride_request':
      case 'ride_accepted':
      case 'ride_completed':
      case 'ride_cancelled':
        return _rideChannelId;
      case 'emergency':
      case 'sos':
        return _highPriorityChannelId;
      default:
        return _generalChannelId;
    }
  }

  String _getChannelName(String channelId) {
    switch (channelId) {
      case _rideChannelId:
        return _rideChannelName;
      case _highPriorityChannelId:
        return _highPriorityChannelName;
      default:
        return _generalChannelName;
    }
  }

  String _getChannelDesc(String channelId) {
    switch (channelId) {
      case _rideChannelId:
        return _rideChannelDesc;
      case _highPriorityChannelId:
        return _highPriorityChannelDesc;
      default:
        return _generalChannelDesc;
    }
  }

  /// Saves a notification to local SharedPreferences for history.
  static Future<void> _saveNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Ensure SharedPreferences helper is initialized (critical in background isolates)
      await SharePrefsHelper.init();

      final id =
          data?['_id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
      final type = data?['type'] ?? 'general';

      String subtitle = data?['subtitle'] ?? 'General';
      String imagePath = data?['imagePath'] ?? '';

      // Set fallback asset images based on notification type
      if (imagePath.isEmpty) {
        if (type == 'move') {
          imagePath = 'assets/images/home_image2.png';
        } else if (type == 'recycling') {
          imagePath = 'assets/images/home_image3.png';
        } else {
          imagePath = 'assets/images/profile_image.png';
        }
      }

      final notificationMap = {
        '_id': id,
        'title': title,
        'message': body,
        'createdAt': DateTime.now().toIso8601String(),
        'type': type,
        'subtitle': subtitle,
        'imagePath': imagePath,
        'isRead': false,
        'data': data ?? {},
      };

      final existingJson = SharePrefsHelper.getLocalNotifications();
      final list = existingJson
          .map((e) => jsonDecode(e) as Map<String, dynamic>)
          .toList();

      // Avoid duplicates
      list.removeWhere((e) => e['_id'] == id);
      list.insert(0, notificationMap);

      // Keep only last 100
      if (list.length > 100) {
        list.removeRange(100, list.length);
      }

      final updatedJsonList = list.map((e) => jsonEncode(e)).toList();
      await SharePrefsHelper.saveLocalNotifications(updatedJsonList);
      debugPrint('💾 Local notification history updated: $title');

      // Update active controller if loaded
      if (Get.isRegistered<NotificationController>()) {
        NotificationController.to.loadLocalNotifications();
      }
    } catch (e) {
      debugPrint('❌ Error saving notification locally: $e');
    }
  }
}
