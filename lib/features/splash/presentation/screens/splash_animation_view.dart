import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zain/core/resources/image_resources.dart';
import 'package:zain/core/resources/svg_resources.dart';
import 'package:zain/core/theme/app_colors.dart';

import '../cubit/splash_cubit.dart';

class SplashAnimationView extends StatefulWidget {
  const SplashAnimationView({super.key});

  @override
  State<SplashAnimationView> createState() => _SplashAnimationViewState();
}

class _SplashAnimationViewState extends State<SplashAnimationView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _textureOpacity;
  late final Animation<double> _glowIntensity;
  late final Animation<double> _cornersOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _ornamentProgress;
  late final Animation<double> _nameOpacity;
  late final Animation<double> _nameSlide;
  late final Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..addStatusListener(_onStatus);

    _textureOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45),
    );

    _glowIntensity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.58, curve: Curves.easeOut),
    );

    _cornersOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.20, 0.55),
    );

    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 0.62, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 0.46),
    );

    _ornamentProgress = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.46, 0.70, curve: Curves.easeOut),
    );

    _nameOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.53, 0.76),
    );

    _nameSlide = Tween<double>(begin: 18.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.53, 0.76, curve: Curves.easeOut),
      ),
    );

    _taglineOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.68, 0.88),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SplashCubit>().startAnimation();
      _controller.forward();
    });
  }

  void _onStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed && mounted) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) await context.read<SplashCubit>().onAnimationComplete();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: splashDark,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ── Layer 1: diagonal texture ─────────────────────────────────
              CustomPaint(
                painter: _DiagonalTexturePainter(_textureOpacity.value),
              ),

              // ── Layer 2: warm glow orb ────────────────────────────────────
              CustomPaint(
                painter: _GlowPainter(_glowIntensity.value),
              ),

              // ── Layer 3: corner ornaments ─────────────────────────────────
              Positioned(
                top: -12,
                right: -16,
                child: Opacity(
                  opacity: _cornersOpacity.value * 0.14,
                  child: SvgPicture.asset(
                    SvgResources.promoTexture,
                    width: 180.w,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -12,
                left: -16,
                child: Opacity(
                  opacity: _cornersOpacity.value * 0.14,
                  child: Transform.rotate(
                    angle: 3.1415926,
                    child: SvgPicture.asset(
                      SvgResources.promoTexture,
                      width: 180.w,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Layer 4: main content ─────────────────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo
                    Transform.scale(
                      scale: _logoScale.value,
                      child: Opacity(
                        opacity: _logoOpacity.value.clamp(0.0, 1.0),
                        child: Image.asset(
                          ImageResources.logo,
                          width: 148.r,
                          height: 148.r,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(height: 36.h),

                    // Ornament divider
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 44.w),
                      child: SizedBox(
                        height: 14,
                        child: CustomPaint(
                          size: Size(double.infinity, 14),
                          painter: _OrnamentPainter(_ornamentProgress.value),
                        ),
                      ),
                    ),

                    SizedBox(height: 26.h),

                    // App name
                    Transform.translate(
                      offset: Offset(0, _nameSlide.value),
                      child: Opacity(
                        opacity: _nameOpacity.value.clamp(0.0, 1.0),
                        child: Text(
                          'زين',
                          style: TextStyle(
                            fontFamily: 'IBMPlexSansArabic',
                            color: Colors.white,
                            fontSize: 46.sp,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 6,
                            height: 1,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Tagline
                    Opacity(
                      opacity: _taglineOpacity.value.clamp(0.0, 1.0),
                      child: Text(
                        'أناقة الرجل · فن الحلاقة',
                        style: TextStyle(
                          fontFamily: 'IBMPlexSansArabic',
                          color: splashOrange.withValues(alpha: 0.88),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Painters ───────────────────────────────────────────────────────────────────

/// Subtle diagonal barber-pole-direction lines across the full canvas.
class _DiagonalTexturePainter extends CustomPainter {
  final double opacity;
  const _DiagonalTexturePainter(this.opacity);

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.032 * opacity)
      ..strokeWidth = 0.75;

    const step = 22.0;
    for (double x = -size.height; x < size.width + step; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DiagonalTexturePainter old) => old.opacity != opacity;
}

/// Warm orange radial glow centered slightly above screen-center (at logo).
class _GlowPainter extends CustomPainter {
  final double intensity;
  const _GlowPainter(this.intensity);

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity <= 0) return;
    final center = Offset(size.width / 2, size.height * 0.41);
    final radius = size.width * 0.82 * intensity;

    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          splashOrange.withValues(alpha: 0.28 * intensity),
          splashOrange.withValues(alpha: 0.10 * intensity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.48, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_GlowPainter old) => old.intensity != intensity;
}

/// Horizontal lines extending outward from center with a diamond at the middle.
class _OrnamentPainter extends CustomPainter {
  final double progress;
  const _OrnamentPainter(this.progress);

  static const _gap = 10.0;
  static const _diamond = 4.5;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final cx = size.width / 2;
    final cy = size.height / 2;

    final linePaint = Paint()
      ..color = splashOrange.withValues(alpha: 0.55 * progress)
      ..strokeWidth = 0.85
      ..strokeCap = StrokeCap.round;

    // Left line: inner end fixed at (cx - gap - diamond), outer end extends to 0
    final leftInner = cx - _gap - _diamond;
    final leftOuter = leftInner * (1.0 - progress);
    canvas.drawLine(Offset(leftOuter, cy), Offset(leftInner, cy), linePaint);

    // Right line: inner end fixed at (cx + gap + diamond), outer end extends to size.width
    final rightInner = cx + _gap + _diamond;
    final rightOuter = rightInner + (size.width - rightInner) * progress;
    canvas.drawLine(Offset(rightInner, cy), Offset(rightOuter, cy), linePaint);

    // Diamond: appears after lines are mostly extended
    if (progress > 0.38) {
      final t = ((progress - 0.38) / 0.62).clamp(0.0, 1.0);
      final d = _diamond * t;
      final fillPaint = Paint()
        ..color = splashOrange.withValues(alpha: 0.90 * t)
        ..style = PaintingStyle.fill;
      final path = Path()
        ..moveTo(cx, cy - d)
        ..lineTo(cx + d, cy)
        ..lineTo(cx, cy + d)
        ..lineTo(cx - d, cy)
        ..close();
      canvas.drawPath(path, fillPaint);
    }
  }

  @override
  bool shouldRepaint(_OrnamentPainter old) => old.progress != progress;
}
