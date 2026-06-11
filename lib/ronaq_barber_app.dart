import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/router/app_router.dart';
import 'package:ronaq_barber/core/theme/app_theme.dart';
import 'package:ronaq_barber/core/theme/cubit/theme_cubit.dart';
import 'package:ronaq_barber/core/theme/cubit/theme_state.dart';

class RonaqBarberApp extends StatelessWidget {
  const RonaqBarberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ThemeCubit>(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final locale = context.locale;
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, _) => MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(locale),
              darkTheme: AppTheme.dark(locale),
              themeMode: themeState.mode,
              routerConfig: appRouter,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: locale,
            ),
          );
        },
      ),
    );
  }
}
