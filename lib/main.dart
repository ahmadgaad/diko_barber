import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/l10n/app_locales.dart';
import 'package:ronaq_barber/core/locale/domain/use_cases/get_locale_use_case.dart';
import 'package:ronaq_barber/core/observers/app_bloc_observer.dart';
import 'package:ronaq_barber/ronaq_barber_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final mapsImpl = GoogleMapsFlutterPlatform.instance;
  if (mapsImpl is GoogleMapsFlutterAndroid) {
    mapsImpl.initializeWithRenderer(AndroidMapRenderer.latest);
  }

  Bloc.observer = const AppBlocObserver();
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
      child: const RonaqBarberApp(),
    ),
  );
}
