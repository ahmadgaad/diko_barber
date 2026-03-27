import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: splashOrange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: splashDark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: splashOrange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );
}
