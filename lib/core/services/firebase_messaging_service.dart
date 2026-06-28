import 'dart:developer' as dev;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zain/core/services/local_notification_service.dart';

/// Callback function types for better type safety
typedef NotificationTapCallback = Future<void> Function(RemoteMessage);
typedef ForegroundMessageCallback = Future<void> Function(RemoteMessage);

/// Service for managing Firebase Cloud Messaging (FCM) push notifications.
///
/// This service provides functionality for:
/// - Initializing FCM and handling different app states (foreground, background, terminated)
/// - Requesting notification permissions
/// - Retrieving FCM device tokens
/// - Handling notification tap events
/// - Processing notification data payloads
class FirebaseMessagingService {
  FirebaseMessagingService._();

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static bool _isInitialized = false;
  static String? _cachedToken;

  /// Initializes Firebase Messaging Service with custom message handlers.
  ///
  /// This method sets up listeners for:
  /// - Foreground messages (when app is active)
  /// - Background message tap (when notification is tapped while app is in background)
  /// - Terminated state messages (when app was closed and notification is tapped)
  ///
  /// IMPORTANT: The background message handler must be registered in main.dart
  /// using FirebaseMessaging.onBackgroundMessage() BEFORE calling this method.
  ///
  /// [onNotificationTapped] Optional callback when notification is tapped
  /// (works for background and terminated states).
  ///
  /// [onForegroundMessage] Optional custom handler for foreground messages.
  /// If not provided, uses default handler that displays local notification.
  static Future<void> initialize({
    NotificationTapCallback? onNotificationTapped,
    ForegroundMessageCallback? onForegroundMessage,
  }) async {
    try {
      if (_isInitialized) {
        dev.log('🔔 FirebaseMessagingService already initialized');
        return;
      }

      dev.log('🔔 Initializing FirebaseMessagingService...');
      await LocalNotificationService.initialize();

      // Handle foreground messages (when app is open and active)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        dev.log('🔔 Foreground message received: ${message.messageId}');
        _logMessageDetails(message);

        if (onForegroundMessage != null) {
          onForegroundMessage(message);
        } else {
          if (message.notification != null) {
            LocalNotificationService.display(message);
          }
        }
      });

      // Handle notification tap when app is in background (not terminated)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        dev.log('🔔 Notification tapped (background): ${message.messageId}');
        _logMessageDetails(message);

        if (onNotificationTapped != null) {
          onNotificationTapped(message);
        }
      });

      // Handle notification tap when app was terminated
      final RemoteMessage? initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        dev.log(
          '🔔 App opened from terminated state via notification: ${initialMessage.messageId}',
        );
        _logMessageDetails(initialMessage);

        if (onNotificationTapped != null) {
          // Delay to ensure app is fully initialized
          Future.delayed(const Duration(seconds: 1), () {
            onNotificationTapped(initialMessage);
          });
        }
      }
      _isInitialized = true;
      dev.log('✅ FirebaseMessagingService initialized successfully');
    } catch (e, stackTrace) {
      dev.log('❌ Failed to initialize FirebaseMessagingService: $e');
      dev.log('Stack trace: $stackTrace');
      throw Exception('Failed to initialize Firebase Messaging: $e');
    }
  }

  /// Requests notification permissions from the user.
  ///
  /// Returns `true` if permission is granted (authorized or provisional),
  /// `false` otherwise.
  ///
  /// Permission states:
  /// - `authorized`: User granted full permission
  /// - `denied`: User denied permission
  /// - `notDetermined`: User hasn't been asked yet
  /// - `provisional`: User granted provisional permission (iOS only)
  static Future<bool> requestPermission() async {
    try {
      dev.log('📱 Requesting notification permissions...');

      final NotificationSettings settings = await _firebaseMessaging
          .requestPermission();

      final isGranted =
          settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;

      dev.log('📱 Permission status: ${settings.authorizationStatus}');
      dev.log('📱 Alert enabled: ${settings.alert}');
      dev.log('📱 Badge enabled: ${settings.badge}');
      dev.log('📱 Sound enabled: ${settings.sound}');

      return isGranted;
    } on Exception catch (e) {
      dev.log('❌ Error requesting notification permission: $e');
      return false;
    }
  }

  /// Retrieves the Firebase Cloud Messaging (FCM) device token.
  ///
  /// This token is unique to the device and is used by your backend
  /// to send push notifications to this specific device.
  ///
  /// Returns the FCM token string, or `null` if token retrieval fails
  /// or permissions are not granted.
  ///
  /// Note: The token can change over time. Use [onTokenRefresh] to
  /// listen for token updates.
  static Future<String?> getFcmToken() async {
    try {
      if (_cachedToken != null) {
        dev.log('🔑 Returning cached FCM token');
        return _cachedToken;
      }

      dev.log('🔑 Retrieving FCM token...');

      final token = await _firebaseMessaging.getToken();

      if (token != null) {
        _cachedToken = token;
        dev.log('✅ FCM token retrieved: ${_maskToken(token)}');
      } else {
        dev.log('⚠️ Failed to retrieve FCM token');
      }
      return token;
    } on Exception catch (e) {
      dev.log('❌ Error getting FCM token: $e');
      return null;
    }
  }

  /// Deletes the FCM token.
  ///
  /// Use this when user logs out or wants to stop receiving notifications.
  /// A new token will be generated when [getFcmToken] is called again.
  static Future<bool> deleteToken() async {
    try {
      dev.log('🗑️ Deleting FCM token...');
      await _firebaseMessaging.deleteToken();
      _cachedToken = null;
      dev.log('✅ FCM token deleted successfully');
      return true;
    } on Exception catch (e) {
      dev.log('❌ Error deleting FCM token: $e');
      return false;
    }
  }

  /// Subscribes to a topic for receiving topic-based notifications.
  ///
  /// [topic] The topic name (e.g., 'news', 'updates', 'offers')
  ///
  /// Returns `true` if subscription was successful, `false` otherwise.
  static Future<bool> subscribeToTopic(String topic) async {
    try {
      if (topic.isEmpty) {
        dev.log('⚠️ Topic name cannot be empty');
        return false;
      }

      dev.log('📢 Subscribing to topic: $topic');
      await _firebaseMessaging.subscribeToTopic(topic);
      dev.log('✅ Successfully subscribed to topic: $topic');
      return true;
    } on Exception catch (e) {
      dev.log('❌ Error subscribing to topic "$topic": $e');
      return false;
    }
  }

  /// Unsubscribes from a topic.
  ///
  /// [topic] The topic name to unsubscribe from
  ///
  /// Returns `true` if unsubscription was successful, `false` otherwise.
  static Future<bool> unsubscribeFromTopic(String topic) async {
    try {
      if (topic.isEmpty) {
        dev.log('⚠️ Topic name cannot be empty');
        return false;
      }

      dev.log('📢 Unsubscribing from topic: $topic');
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      dev.log('✅ Successfully unsubscribed from topic: $topic');
      return true;
    } on Exception catch (e) {
      dev.log('❌ Error unsubscribing from topic "$topic": $e');
      return false;
    }
  }

  /// Sets up a listener for FCM token refresh events.
  ///
  /// The token can change when:
  /// - App is restored on a new device
  /// - User uninstalls/reinstalls the app
  /// - User clears app data
  ///
  /// [onTokenRefresh] Callback function that receives the new token
  static void onTokenRefresh(Future<void> Function(String) onTokenRefresh) {
    _firebaseMessaging.onTokenRefresh.listen(
      (String newToken) {
        dev.log('🔄 FCM token refreshed: ${_maskToken(newToken)}');
        _cachedToken = newToken;
        onTokenRefresh(newToken);
      },
      onError: (error) {
        dev.log('❌ Error in token refresh listener: $error');
      },
    );
  }

  /// Gets the current notification authorization status.
  static Future<AuthorizationStatus> getAuthorizationStatus() async {
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus;
    } on Exception catch (e) {
      dev.log('❌ Error getting authorization status: $e');
      return AuthorizationStatus.notDetermined;
    }
  }

  /// Checks if notifications are enabled.
  static Future<bool> areNotificationsEnabled() async {
    try {
      final status = await getAuthorizationStatus();
      return status == AuthorizationStatus.authorized ||
          status == AuthorizationStatus.provisional;
    } on Exception catch (e) {
      dev.log('❌ Error checking notification status: $e');
      return false;
    }
  }

  /// Controls whether Firebase Messaging automatically initializes on app startup.
  ///
  /// When disabled, FCM will not generate tokens or handle messages until
  /// explicitly initialized (e.g., by calling getFcmToken()).
  ///
  /// Useful for GDPR compliance or conditional notification features.
  ///
  /// [enabled] Whether to enable automatic FCM initialization
  static Future<void> setAutoInitEnabled(bool enabled) async {
    try {
      await _firebaseMessaging.setAutoInitEnabled(enabled);
      dev.log('✅ Auto init ${enabled ? "enabled" : "disabled"}');
    } on Exception catch (e) {
      dev.log('❌ Error setting auto init: $e');
    }
  }

  /// Logs detailed information about a received message.
  static void _logMessageDetails(RemoteMessage message) {
    dev.log('📬 Message ID: ${message.messageId}');
    dev.log('📬 Sent time: ${message.sentTime}');

    if (message.notification != null) {
      dev.log('🔔 Title: ${message.notification?.title}');
      dev.log('🔔 Body: ${message.notification?.body}');

      if (message.notification?.apple != null) {
        dev.log('🍎 Apple subtitle: ${message.notification?.apple?.subtitle}');
        dev.log('🍎 Apple badge: ${message.notification?.apple?.badge}');
      }

      if (message.notification?.android != null) {
        dev.log(
          '🤖 Android channel: ${message.notification?.android?.channelId}',
        );
        dev.log(
          '🤖 Android priority: ${message.notification?.android?.priority}',
        );
      }
    }

    if (message.data.isNotEmpty) {
      dev.log('📦 Data payload: ${message.data}');
      dev.log('📦 Data keys: ${message.data.keys.join(", ")}');
    }
  }

  /// Masks the token for secure logging (shows first and last 6 characters).
  static String _maskToken(String token) {
    if (token.length <= 12) return token;
    return '${token.substring(0, 6)}...${token.substring(token.length - 6)}';
  }
}
