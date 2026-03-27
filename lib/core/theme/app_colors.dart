import 'package:flutter/material.dart';

// ─── Brand Colors ─────────────────────────────────────────────────────────────
const Color splashOrange = Color(0xFFFF7A00);
const Color splashDark = Color(0xFF0F0F0F);

// ─── Gradients ────────────────────────────────────────────────────────────────
const LinearGradient splashGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [splashOrange, splashDark],
);
