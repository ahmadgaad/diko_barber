import 'package:flutter/material.dart';

abstract final class AppTextTheme {
  static const _arabic = 'IBMPlexSansArabic';
  static const _latin = 'IBMPlexSans';

  static TextTheme forLocale(Locale locale, [TextTheme? base]) {
    final family = locale.languageCode == 'ar' ? _arabic : _latin;
    return (base ?? const TextTheme()).apply(fontFamily: family);
  }
}
