import 'package:flutter/material.dart';

// ─── Brand Colors ─────────────────────────────────────────────────────────────
const Color splashOrange = Color(0xFFFF7A00);
const Color splashDark = Color(0xFF0F0F0F);

// ─── Neutral Palette (Light) ────────────────────────────────────────────────
const Color neutral50 = Color(0xFFFFFFFF);
const Color neutral100 = Color(0xFFF5F5F5);
const Color neutral200 = Color(0xFFE5E5E5);
const Color neutral300 = Color(0xFFD4D4D4);
const Color neutral400 = Color(0xFFA3A3A3);
const Color neutral500 = Color(0xFF737373);
const Color neutral600 = Color(0xFF525252);
const Color neutral700 = Color(0xFF3F3F3F);
const Color neutral800 = Color(0xFF262626);
const Color neutral900 = Color(0xFF0F0F0F);

// ─── Primary Palette (Light) ────────────────────────────────────────────────
const Color primary50 = Color(0xFFFFF4EB);
const Color primary100 = Color(0xFFFFE4CC);
const Color primary200 = Color(0xFFFFC999);
const Color primary300 = Color(0xFFFFAD66);
const Color primary400 = Color(0xFFFF9133);
const Color primary500 = Color(0xFFFF7A00);
const Color primary600 = Color(0xFFE66500);
const Color primary700 = Color(0xFFCC5600);
const Color primary800 = Color(0xFF993800);
const Color primary900 = Color(0xFF7A2E00);

// ─── Success Palette (Light) ────────────────────────────────────────────────
const Color success50 = Color(0xFFF0FDF2);
const Color success100 = Color(0xFFDCFCE7);
const Color success200 = Color(0xFFBBF7D0);
const Color success300 = Color(0xFF86EFAC);
const Color success400 = Color(0xFF4ADE80);
const Color success500 = Color(0xFF22C55E);
const Color success600 = Color(0xFF16A34A);
const Color success700 = Color(0xFF15803D);
const Color success800 = Color(0xFF166534);
const Color success900 = Color(0xFF14532D);

// ─── Error Palette (Light) ──────────────────────────────────────────────────
const Color error50 = Color(0xFFFEF2F2);
const Color error100 = Color(0xFFFEE2E2);
const Color error200 = Color(0xFFFECACA);
const Color error300 = Color(0xFFFCA5A5);
const Color error400 = Color(0xFFF87171);
const Color error500 = Color(0xFFEF4444);
const Color error600 = Color(0xFFDC2626);
const Color error700 = Color(0xFFB91C1C);
const Color error800 = Color(0xFF991B1B);
const Color error900 = Color(0xFF7F1D1D);

// ─── Warning Palette (Light) ────────────────────────────────────────────────
const Color warning50 = Color(0xFFFFFBEB);
const Color warning100 = Color(0xFFFEF3C7);
const Color warning200 = Color(0xFFFDE68A);
const Color warning300 = Color(0xFFFCD34D);
const Color warning400 = Color(0xFFFBBF24);
const Color warning500 = Color(0xFFF59E0B);
const Color warning600 = Color(0xFFD97706);
const Color warning700 = Color(0xFFB45309);
const Color warning800 = Color(0xFF92400E);
const Color warning900 = Color(0xFF78350F);

// ─── Info Palette (Light) ───────────────────────────────────────────────────
const Color info50 = Color(0xFFEFF6FF);
const Color info100 = Color(0xFFDBEAFE);
const Color info200 = Color(0xFFBFDBFE);
const Color info300 = Color(0xFF93C5FD);
const Color info400 = Color(0xFF60A5FA);
const Color info500 = Color(0xFF3B82F6);
const Color info600 = Color(0xFF2563EB);
const Color info700 = Color(0xFF1D4ED8);
const Color info800 = Color(0xFF1E40AF);
const Color info900 = Color(0xFF172554);

// ─── Gradients ────────────────────────────────────────────────────────────────
const LinearGradient splashGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [splashOrange, splashDark],
);

const LinearGradient buttonGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment(1.2, 1.0),
  colors: [splashOrange, splashOrange, splashDark],
  stops: [0.0, 0.4, 1.0],
);
