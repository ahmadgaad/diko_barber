import 'dart:ui';

class AppLocales {
  const AppLocales._();

  static const translationsPath = 'assets/translations';
  static const en = Locale('en');
  static const ar = Locale('ar');
  static const fallback = ar;
  static const supported = [en, ar];
}
