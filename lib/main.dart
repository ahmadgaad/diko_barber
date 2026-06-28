import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/core/l10n/app_locales.dart';
import 'package:zain/core/locale/domain/use_cases/get_locale_use_case.dart';
import 'package:zain/core/observers/app_bloc_observer.dart';
import 'package:zain/core/services/firebase_messaging_service.dart';
import 'package:zain/firebase_options.dart';
import 'package:zain/ronaq_barber_app.dart';

/// [_backgroundMessageHandler] it's a top level function not class which requires initialization,
/// When using Flutter version 3.3.0 or higher, the message handler must be annotated with @pragma('vm:entry-point')
/// right above the function declaration (otherwise it may be removed during tree shaking for release mode).
///
/// IMPORTANT: This must be defined at the top level, before main()
@pragma('vm:entry-point')
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  // Initialize Firebase only if not already initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  log('🔔 Background message received: ${message.messageId}');

  // Process the background message here if needed
  if (message.notification != null) {
    log('🔔 Title: ${message.notification?.title}');
    log('🔔 Body: ${message.notification?.body}');
  }

  // Handle data payload
  if (message.data.isNotEmpty) {
    log('🔔 Data: ${message.data}');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final mapsImpl = GoogleMapsFlutterPlatform.instance;
  if (mapsImpl is GoogleMapsFlutterAndroid) {
    try {
      mapsImpl.initializeWithRenderer(AndroidMapRenderer.latest);
    } catch (_) {}
  }

  Bloc.observer = const AppBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Wire Flutter & platform errors into Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  // Disable in debug so we don't pollute the Crashlytics dashboard
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);

  // Register background message handler BEFORE initializing the service
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  // Initialize Push Notification Services
  await _initializeNotifications();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();
  await setupServiceLocator();

  final savedLanguageCode = await sl<GetLocaleUseCase>()();
  final startLocale = savedLanguageCode != null
      ? Locale(savedLanguageCode)
      : AppLocales.ar;

  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.translationsPath,
      fallbackLocale: AppLocales.fallback,
      startLocale: startLocale,
      saveLocale: false,
      child: const ZainApp(),
    ),
  );
}

Future<void> _initializeNotifications() async {
  try {
    await FirebaseMessagingService.initialize(
      onNotificationTapped: (RemoteMessage message) async {
        log('🔔 Notification tapped: ${message.data}');
        final messages = message.data['screen'];
        if (messages != null) {}
      },
    );
  } on Exception catch (e) {
    log('❌ Error initializing notifications: $e');
  }
}
