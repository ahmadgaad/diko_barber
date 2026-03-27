import 'package:flutter/material.dart';

import 'package:diko_barber/core/router/app_router.dart';
import 'package:diko_barber/core/theme/app_theme.dart';

class DikoBarberApp extends StatelessWidget {
  const DikoBarberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
