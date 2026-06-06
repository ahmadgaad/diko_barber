import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/l10n/app_locales.dart';
import 'package:ronaq_barber/core/locale/domain/use_cases/get_locale_use_case.dart';
import 'package:ronaq_barber/ronaq_barber_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
