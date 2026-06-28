import 'dart:developer' as dev;
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Service for managing local notifications in the application.
///
/// This service provides functionality for:
/// - Initializing local notification settings for Android and iOS
/// - Displaying notifications from Firebase Cloud Messaging
/// - Managing notification permissions
/// - Canceling notifications
class LocalNotificationService {
  LocalNotificationService._();

  // Constants
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription =
      'Channel for high priority push notifications';
  static const String _androidIcon = '@mipmap/ic_launcher';

  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static bool _isInitialized = false;

  /// Initializes the local notification service.
  ///
  /// This method should be called once during app startup.
  /// It configures notification settings for both Android and iOS platforms
  /// and requests necessary permissions.
  ///
  /// Throws [Exception] if initialization fails.
  static Future<void> initialize({
    Future<void> Function(NotificationResponse)? onNotificationTapped,
  }) async {
    try {
      if (_isInitialized) {
        dev.log('📱 LocalNotificationService already initialized');
        return;
      }

      dev.log('📱 Initializing LocalNotificationService...');

      // Android initialization settings
      const androidInitializationSettings = AndroidInitializationSettings(
        _androidIcon,
      );

      // iOS initialization settings — permissions requested explicitly in auth flow
      const iosInitializationSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
      );

      // Initialize the plugin
      await _notificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse:
            onNotificationTapped ?? _defaultNotificationTapHandler,
      );

      // Create notification channel for Android
      if (Platform.isAndroid) {
        await _createAndroidNotificationChannel();
      }

      _isInitialized = true;
      dev.log('✅ LocalNotificationService initialized successfully');
    } catch (e, stackTrace) {
      dev.log('❌ Failed to initialize LocalNotificationService: $e');
      dev.log('Stack trace: $stackTrace');
      throw Exception('Failed to initialize local notifications: $e');
    }
  }

  /// Requests POST_NOTIFICATIONS permission on Android 13+.
  static Future<void> requestAndroidPermission() async {
    if (!Platform.isAndroid) return;
    await _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  /// Requests notification permissions for iOS devices.
  ///
  /// Returns `true` if permission is granted, `false` otherwise.
  static Future<bool> requestIOSPermissions() async {
    if (!Platform.isIOS) return true;

    try {
      final bool? result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);

      dev.log('📱 iOS notification permission granted: ${result ?? false}');
      return result ?? false;
    } on Exception catch (e) {
      dev.log('❌ Error requesting iOS notification permission: $e');
      return false;
    }
  }

  /// Creates a notification channel for Android devices.
  ///
  /// This is required for Android 8.0 (API level 26) and higher.
  static Future<void> _createAndroidNotificationChannel() async {
    try {
      const channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
        // Use default sound if _useDefaultSound is true, otherwise no custom sound
      );

      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      dev.log('✅ Android notification channel created');
    } catch (e) {
      dev.log('❌ Error creating Android notification channel: $e');
    }
  }

  /// Default handler for notification tap events.
  static void _defaultNotificationTapHandler(NotificationResponse details) {
    dev.log(
      '🔔 Notification tapped: id=${details.id}, payload=${details.payload}',
    );
  }

  /// Displays a local notification from a Firebase Cloud Messaging message.
  ///
  /// [message] The remote message received from FCM
  ///
  /// Returns `true` if the notification was displayed successfully, `false` otherwise.
  static Future<bool> display(RemoteMessage message) async {
    try {
      if (!_isInitialized) {
        dev.log(
          '⚠️ LocalNotificationService not initialized. Initializing now...',
        );
        await initialize();
      }

      // Validate message has notification content
      if (message.notification == null) {
        dev.log('⚠️ Message does not contain notification data');
        return false;
      }

      if (Platform.isAndroid && !await areNotificationsEnabled()) {
        dev.log('⚠️ Notifications are disabled — cannot display notification');
        return false;
      }

      final notification = message.notification!;
      final id =
          (message.messageId?.hashCode ??
              DateTime.now().millisecondsSinceEpoch ~/ 1000)
          .abs();

      dev.log('📬 Displaying notification: ${notification.title}');

      // Create platform-specific notification details
      final notificationDetails = _buildNotificationDetails(
        channelId: _channelId,
        channelName: _channelName,
        body: notification.body ?? '',
      );

      // Show the notification
      await _notificationsPlugin.show(
        id: id,
        title: notification.title ?? 'Notification',
        body: notification.body ?? '',
        notificationDetails: notificationDetails,
        payload: _encodePayload(message.data),
      );

      dev.log('✅ Notification displayed successfully');
      return true;
    } on Exception catch (e, stackTrace) {
      dev.log('❌ Error displaying notification: $e');
      dev.log('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Builds platform-specific notification details.
  static NotificationDetails _buildNotificationDetails({
    required String channelId,
    required String channelName,
    String body = '',
  }) {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'New notification',
      styleInformation: BigTextStyleInformation(body),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      presentList: true,
      presentBanner: true,
      // Don't specify sound to use default system sound
    );

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  /// Encodes notification payload data to a string.
  static String? _encodePayload(Map<String, dynamic> data) {
    if (data.isEmpty) return null;
    try {
      return data.entries.map((e) => '${e.key}:${e.value}').join('|');
    } on Exception catch (e) {
      dev.log('⚠️ Error encoding payload: $e');
      return null;
    }
  }

  /// Cancels a notification by its ID.
  ///
  /// [id] The unique identifier of the notification to cancel
  static Future<void> cancel(int id) async {
    try {
      await _notificationsPlugin.cancel(id: id);
      dev.log('🗑️ Notification $id cancelled');
    } on Exception catch (e) {
      dev.log('❌ Error cancelling notification $id: $e');
    }
  }

  /// Cancels all active notifications.
  static Future<void> cancelAll() async {
    try {
      await _notificationsPlugin.cancelAll();
      dev.log('🗑️ All notifications cancelled');
    } on Exception catch (e) {
      dev.log('❌ Error cancelling all notifications: $e');
    }
  }

  /// Checks if notification permissions are granted (Android only).
  ///
  /// Returns `true` if permissions are granted, `false` otherwise.
  static Future<bool> areNotificationsEnabled() async {
    if (!Platform.isAndroid) return true;

    try {
      final bool? result = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.areNotificationsEnabled();
      return result ?? false;
    } on Exception catch (e) {
      dev.log('❌ Error checking notification permission: $e');
      return false;
    }
  }

  /// Gets the list of active notifications.
  static Future<List<ActiveNotification>> getActiveNotifications() async {
    try {
      final notifications = await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.getActiveNotifications();
      return notifications ?? [];
    } on Exception catch (e) {
      dev.log('❌ Error getting active notifications: $e');
      return [];
    }
  }
}
