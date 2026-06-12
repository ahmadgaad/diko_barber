import 'dart:developer';

import 'package:flutter/material.dart';

class AppRouterObserver extends NavigatorObserver {
  AppRouterObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log(
      'didPush -- ${previousRoute?.settings.name ?? 'none'} → ${route.settings.name}',
      name: 'Router',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log(
      'didPop -- ${route.settings.name} → ${previousRoute?.settings.name ?? 'none'}',
      name: 'Router',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    log(
      'didReplace -- ${oldRoute?.settings.name ?? 'none'} → ${newRoute?.settings.name ?? 'none'}',
      name: 'Router',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log(
      'didRemove -- ${route.settings.name}',
      name: 'Router',
    );
  }
}
