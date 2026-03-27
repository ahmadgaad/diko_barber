import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

abstract final class AppTheme {
  static ThemeData light(Locale locale) {
    final base = ThemeData(brightness: Brightness.light);
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: splashOrange,
        brightness: Brightness.light,
      ),
      textTheme: AppTextTheme.forLocale(locale, base.textTheme),
      useMaterial3: true,
    );
  }

  static ThemeData dark(Locale locale) {
    final base = ThemeData(brightness: Brightness.dark);
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: splashDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: splashOrange,
        brightness: Brightness.dark,
      ),
      textTheme: AppTextTheme.forLocale(locale, base.textTheme),
      useMaterial3: true,
    );
  }
}
