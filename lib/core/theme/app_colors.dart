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

const LinearGradient buttonGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment(1.2, 1.0),
  colors: [splashOrange, splashOrange, splashDark],
  stops: [0.0, 0.4, 1.0],
);

// ─── AppColors ThemeExtension ─────────────────────────────────────────────────
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.neutral50,
    required this.neutral100,
    required this.neutral200,
    required this.neutral300,
    required this.neutral400,
    required this.neutral500,
    required this.neutral600,
    required this.neutral700,
    required this.neutral800,
    required this.neutral900,
    required this.primary50,
    required this.primary100,
    required this.primary200,
    required this.primary300,
    required this.primary400,
    required this.primary500,
    required this.primary600,
    required this.primary700,
    required this.primary800,
    required this.primary900,
    required this.success50,
    required this.success100,
    required this.success200,
    required this.success300,
    required this.success400,
    required this.success500,
    required this.success600,
    required this.success700,
    required this.success800,
    required this.success900,
    required this.error50,
    required this.error100,
    required this.error200,
    required this.error300,
    required this.error400,
    required this.error500,
    required this.error600,
    required this.error700,
    required this.error800,
    required this.error900,
    required this.warning50,
    required this.warning100,
    required this.warning200,
    required this.warning300,
    required this.warning400,
    required this.warning500,
    required this.warning600,
    required this.warning700,
    required this.warning800,
    required this.warning900,
    required this.info50,
    required this.info100,
    required this.info200,
    required this.info300,
    required this.info400,
    required this.info500,
    required this.info600,
    required this.info700,
    required this.info800,
    required this.info900,
  });

  // ─── Neutral ──────────────────────────────────────────────────────────
  final Color neutral50;
  final Color neutral100;
  final Color neutral200;
  final Color neutral300;
  final Color neutral400;
  final Color neutral500;
  final Color neutral600;
  final Color neutral700;
  final Color neutral800;
  final Color neutral900;

  // ─── Primary ──────────────────────────────────────────────────────────
  final Color primary50;
  final Color primary100;
  final Color primary200;
  final Color primary300;
  final Color primary400;
  final Color primary500;
  final Color primary600;
  final Color primary700;
  final Color primary800;
  final Color primary900;

  // ─── Success ──────────────────────────────────────────────────────────
  final Color success50;
  final Color success100;
  final Color success200;
  final Color success300;
  final Color success400;
  final Color success500;
  final Color success600;
  final Color success700;
  final Color success800;
  final Color success900;

  // ─── Error ────────────────────────────────────────────────────────────
  final Color error50;
  final Color error100;
  final Color error200;
  final Color error300;
  final Color error400;
  final Color error500;
  final Color error600;
  final Color error700;
  final Color error800;
  final Color error900;

  // ─── Warning ──────────────────────────────────────────────────────────
  final Color warning50;
  final Color warning100;
  final Color warning200;
  final Color warning300;
  final Color warning400;
  final Color warning500;
  final Color warning600;
  final Color warning700;
  final Color warning800;
  final Color warning900;

  // ─── Info ─────────────────────────────────────────────────────────────
  final Color info50;
  final Color info100;
  final Color info200;
  final Color info300;
  final Color info400;
  final Color info500;
  final Color info600;
  final Color info700;
  final Color info800;
  final Color info900;

  // ─── Convenience accessor ─────────────────────────────────────────────
  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>()!;

  // ─── Light Theme Instance ─────────────────────────────────────────────
  static const light = AppColors(
    neutral50: Color(0xFFFFFFFF),
    neutral100: Color(0xFFF5F5F5),
    neutral200: Color(0xFFE5E5E5),
    neutral300: Color(0xFFD4D4D4),
    neutral400: Color(0xFFA3A3A3),
    neutral500: Color(0xFF737373),
    neutral600: Color(0xFF525252),
    neutral700: Color(0xFF3F3F3F),
    neutral800: Color(0xFF262626),
    neutral900: Color(0xFF0F0F0F),
    primary50: Color(0xFFFFF4EB),
    primary100: Color(0xFFFFE4CC),
    primary200: Color(0xFFFFC999),
    primary300: Color(0xFFFFAD66),
    primary400: Color(0xFFFF9133),
    primary500: Color(0xFFFF7A00),
    primary600: Color(0xFFE66500),
    primary700: Color(0xFFCC5600),
    primary800: Color(0xFF993800),
    primary900: Color(0xFF7A2E00),
    success50: Color(0xFFF0FDF2),
    success100: Color(0xFFDCFCE7),
    success200: Color(0xFFBBF7D0),
    success300: Color(0xFF86EFAC),
    success400: Color(0xFF4ADE80),
    success500: Color(0xFF22C55E),
    success600: Color(0xFF16A34A),
    success700: Color(0xFF15803D),
    success800: Color(0xFF166534),
    success900: Color(0xFF14532D),
    error50: Color(0xFFFEF2F2),
    error100: Color(0xFFFEE2E2),
    error200: Color(0xFFFECACA),
    error300: Color(0xFFFCA5A5),
    error400: Color(0xFFF87171),
    error500: Color(0xFFEF4444),
    error600: Color(0xFFDC2626),
    error700: Color(0xFFB91C1C),
    error800: Color(0xFF991B1B),
    error900: Color(0xFF7F1D1D),
    warning50: Color(0xFFFFFBEB),
    warning100: Color(0xFFFEF3C7),
    warning200: Color(0xFFFDE68A),
    warning300: Color(0xFFFCD34D),
    warning400: Color(0xFFFBBF24),
    warning500: Color(0xFFF59E0B),
    warning600: Color(0xFFD97706),
    warning700: Color(0xFFB45309),
    warning800: Color(0xFF92400E),
    warning900: Color(0xFF78350F),
    info50: Color(0xFFEFF6FF),
    info100: Color(0xFFDBEAFE),
    info200: Color(0xFFBFDBFE),
    info300: Color(0xFF93C5FD),
    info400: Color(0xFF60A5FA),
    info500: Color(0xFF3B82F6),
    info600: Color(0xFF2563EB),
    info700: Color(0xFF1D4ED8),
    info800: Color(0xFF1E40AF),
    info900: Color(0xFF172554),
  );

  // ─── Dark Theme Instance ──────────────────────────────────────────────
  static const dark = AppColors(
    neutral50: Color(0xFF0F0F0F),
    neutral100: Color(0xFF262626),
    neutral200: Color(0xFF3F3F3F),
    neutral300: Color(0xFF525252),
    neutral400: Color(0xFF737373),
    neutral500: Color(0xFFA3A3A3),
    neutral600: Color(0xFFD4D4D4),
    neutral700: Color(0xFFE5E5E5),
    neutral800: Color(0xFFF5F5F5),
    neutral900: Color(0xFFFFFFFF),
    primary50: Color(0xFF7A2E00),
    primary100: Color(0xFF993800),
    primary200: Color(0xFFB34700),
    primary300: Color(0xFFCC5600),
    primary400: Color(0xFFE66500),
    primary500: Color(0xFFFF7A00),
    primary600: Color(0xFFFF9133),
    primary700: Color(0xFFFFAD66),
    primary800: Color(0xFFFFC999),
    primary900: Color(0xFFFFE4CC),
    success50: Color(0xFF14532D),
    success100: Color(0xFF166534),
    success200: Color(0xFF15803D),
    success300: Color(0xFF16A34A),
    success400: Color(0xFF22C55E),
    success500: Color(0xFF4ADE80),
    success600: Color(0xFF86EFAC),
    success700: Color(0xFFBBF7D0),
    success800: Color(0xFFDCFCE7),
    success900: Color(0xFFDCFCE7),
    error50: Color(0xFF7F1D1D),
    error100: Color(0xFF991B1B),
    error200: Color(0xFFFECACA),
    error300: Color(0xFFFCA5A5),
    error400: Color(0xFFF87171),
    error500: Color(0xFFEF4444),
    error600: Color(0xFFF87171),
    error700: Color(0xFFB91C1C),
    error800: Color(0xFFFECACA),
    error900: Color(0xFFFEE2E2),
    warning50: Color(0xFF78350F),
    warning100: Color(0xFF92400E),
    warning200: Color(0xFFB45309),
    warning300: Color(0xFFD97706),
    warning400: Color(0xFFFBBF24),
    warning500: Color(0xFFF59E0B),
    warning600: Color(0xFFFBBF24),
    warning700: Color(0xFFFCD34D),
    warning800: Color(0xFFFDE68A),
    warning900: Color(0xFFFEF3C7),
    info50: Color(0xFF172554),
    info100: Color(0xFF1E3A8A),
    info200: Color(0xFF1D4ED8),
    info300: Color(0xFF2563EB),
    info400: Color(0xFF60A5FA),
    info500: Color(0xFF3B82F6),
    info600: Color(0xFF60A5FA),
    info700: Color(0xFF93C5FD),
    info800: Color(0xFFBFDBFE),
    info900: Color(0xFFDBEAFE),
  );

  @override
  AppColors copyWith({
    Color? neutral50,
    Color? neutral100,
    Color? neutral200,
    Color? neutral300,
    Color? neutral400,
    Color? neutral500,
    Color? neutral600,
    Color? neutral700,
    Color? neutral800,
    Color? neutral900,
    Color? primary50,
    Color? primary100,
    Color? primary200,
    Color? primary300,
    Color? primary400,
    Color? primary500,
    Color? primary600,
    Color? primary700,
    Color? primary800,
    Color? primary900,
    Color? success50,
    Color? success100,
    Color? success200,
    Color? success300,
    Color? success400,
    Color? success500,
    Color? success600,
    Color? success700,
    Color? success800,
    Color? success900,
    Color? error50,
    Color? error100,
    Color? error200,
    Color? error300,
    Color? error400,
    Color? error500,
    Color? error600,
    Color? error700,
    Color? error800,
    Color? error900,
    Color? warning50,
    Color? warning100,
    Color? warning200,
    Color? warning300,
    Color? warning400,
    Color? warning500,
    Color? warning600,
    Color? warning700,
    Color? warning800,
    Color? warning900,
    Color? info50,
    Color? info100,
    Color? info200,
    Color? info300,
    Color? info400,
    Color? info500,
    Color? info600,
    Color? info700,
    Color? info800,
    Color? info900,
  }) {
    return AppColors(
      neutral50: neutral50 ?? this.neutral50,
      neutral100: neutral100 ?? this.neutral100,
      neutral200: neutral200 ?? this.neutral200,
      neutral300: neutral300 ?? this.neutral300,
      neutral400: neutral400 ?? this.neutral400,
      neutral500: neutral500 ?? this.neutral500,
      neutral600: neutral600 ?? this.neutral600,
      neutral700: neutral700 ?? this.neutral700,
      neutral800: neutral800 ?? this.neutral800,
      neutral900: neutral900 ?? this.neutral900,
      primary50: primary50 ?? this.primary50,
      primary100: primary100 ?? this.primary100,
      primary200: primary200 ?? this.primary200,
      primary300: primary300 ?? this.primary300,
      primary400: primary400 ?? this.primary400,
      primary500: primary500 ?? this.primary500,
      primary600: primary600 ?? this.primary600,
      primary700: primary700 ?? this.primary700,
      primary800: primary800 ?? this.primary800,
      primary900: primary900 ?? this.primary900,
      success50: success50 ?? this.success50,
      success100: success100 ?? this.success100,
      success200: success200 ?? this.success200,
      success300: success300 ?? this.success300,
      success400: success400 ?? this.success400,
      success500: success500 ?? this.success500,
      success600: success600 ?? this.success600,
      success700: success700 ?? this.success700,
      success800: success800 ?? this.success800,
      success900: success900 ?? this.success900,
      error50: error50 ?? this.error50,
      error100: error100 ?? this.error100,
      error200: error200 ?? this.error200,
      error300: error300 ?? this.error300,
      error400: error400 ?? this.error400,
      error500: error500 ?? this.error500,
      error600: error600 ?? this.error600,
      error700: error700 ?? this.error700,
      error800: error800 ?? this.error800,
      error900: error900 ?? this.error900,
      warning50: warning50 ?? this.warning50,
      warning100: warning100 ?? this.warning100,
      warning200: warning200 ?? this.warning200,
      warning300: warning300 ?? this.warning300,
      warning400: warning400 ?? this.warning400,
      warning500: warning500 ?? this.warning500,
      warning600: warning600 ?? this.warning600,
      warning700: warning700 ?? this.warning700,
      warning800: warning800 ?? this.warning800,
      warning900: warning900 ?? this.warning900,
      info50: info50 ?? this.info50,
      info100: info100 ?? this.info100,
      info200: info200 ?? this.info200,
      info300: info300 ?? this.info300,
      info400: info400 ?? this.info400,
      info500: info500 ?? this.info500,
      info600: info600 ?? this.info600,
      info700: info700 ?? this.info700,
      info800: info800 ?? this.info800,
      info900: info900 ?? this.info900,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      neutral50: Color.lerp(neutral50, other.neutral50, t)!,
      neutral100: Color.lerp(neutral100, other.neutral100, t)!,
      neutral200: Color.lerp(neutral200, other.neutral200, t)!,
      neutral300: Color.lerp(neutral300, other.neutral300, t)!,
      neutral400: Color.lerp(neutral400, other.neutral400, t)!,
      neutral500: Color.lerp(neutral500, other.neutral500, t)!,
      neutral600: Color.lerp(neutral600, other.neutral600, t)!,
      neutral700: Color.lerp(neutral700, other.neutral700, t)!,
      neutral800: Color.lerp(neutral800, other.neutral800, t)!,
      neutral900: Color.lerp(neutral900, other.neutral900, t)!,
      primary50: Color.lerp(primary50, other.primary50, t)!,
      primary100: Color.lerp(primary100, other.primary100, t)!,
      primary200: Color.lerp(primary200, other.primary200, t)!,
      primary300: Color.lerp(primary300, other.primary300, t)!,
      primary400: Color.lerp(primary400, other.primary400, t)!,
      primary500: Color.lerp(primary500, other.primary500, t)!,
      primary600: Color.lerp(primary600, other.primary600, t)!,
      primary700: Color.lerp(primary700, other.primary700, t)!,
      primary800: Color.lerp(primary800, other.primary800, t)!,
      primary900: Color.lerp(primary900, other.primary900, t)!,
      success50: Color.lerp(success50, other.success50, t)!,
      success100: Color.lerp(success100, other.success100, t)!,
      success200: Color.lerp(success200, other.success200, t)!,
      success300: Color.lerp(success300, other.success300, t)!,
      success400: Color.lerp(success400, other.success400, t)!,
      success500: Color.lerp(success500, other.success500, t)!,
      success600: Color.lerp(success600, other.success600, t)!,
      success700: Color.lerp(success700, other.success700, t)!,
      success800: Color.lerp(success800, other.success800, t)!,
      success900: Color.lerp(success900, other.success900, t)!,
      error50: Color.lerp(error50, other.error50, t)!,
      error100: Color.lerp(error100, other.error100, t)!,
      error200: Color.lerp(error200, other.error200, t)!,
      error300: Color.lerp(error300, other.error300, t)!,
      error400: Color.lerp(error400, other.error400, t)!,
      error500: Color.lerp(error500, other.error500, t)!,
      error600: Color.lerp(error600, other.error600, t)!,
      error700: Color.lerp(error700, other.error700, t)!,
      error800: Color.lerp(error800, other.error800, t)!,
      error900: Color.lerp(error900, other.error900, t)!,
      warning50: Color.lerp(warning50, other.warning50, t)!,
      warning100: Color.lerp(warning100, other.warning100, t)!,
      warning200: Color.lerp(warning200, other.warning200, t)!,
      warning300: Color.lerp(warning300, other.warning300, t)!,
      warning400: Color.lerp(warning400, other.warning400, t)!,
      warning500: Color.lerp(warning500, other.warning500, t)!,
      warning600: Color.lerp(warning600, other.warning600, t)!,
      warning700: Color.lerp(warning700, other.warning700, t)!,
      warning800: Color.lerp(warning800, other.warning800, t)!,
      warning900: Color.lerp(warning900, other.warning900, t)!,
      info50: Color.lerp(info50, other.info50, t)!,
      info100: Color.lerp(info100, other.info100, t)!,
      info200: Color.lerp(info200, other.info200, t)!,
      info300: Color.lerp(info300, other.info300, t)!,
      info400: Color.lerp(info400, other.info400, t)!,
      info500: Color.lerp(info500, other.info500, t)!,
      info600: Color.lerp(info600, other.info600, t)!,
      info700: Color.lerp(info700, other.info700, t)!,
      info800: Color.lerp(info800, other.info800, t)!,
      info900: Color.lerp(info900, other.info900, t)!,
    );
  }
}
