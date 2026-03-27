import 'package:flutter/material.dart';

import 'package:diko_barber/core/di/service_locator.dart';
import 'package:diko_barber/diko_barber_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const DikoBarberApp());
}
