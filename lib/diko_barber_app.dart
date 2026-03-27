import 'package:diko_barber/core/router/app_router.dart';
import 'package:diko_barber/core/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DikoBarberApp extends StatelessWidget {
  const DikoBarberApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(locale),
        darkTheme: AppTheme.dark(locale),
        themeMode: ThemeMode.dark,
        routerConfig: appRouter,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: locale,
      ),
    );
  }
}
