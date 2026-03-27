import 'dart:math' as math;

// افترض أن هذه المسارات صحيحة لمشروعك
import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/splash_cubit.dart';

class SplashAnimationView extends StatefulWidget {
  const SplashAnimationView({super.key});

  @override
  State<SplashAnimationView> createState() => _SplashAnimationViewState();
}

class _SplashAnimationViewState extends State<SplashAnimationView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // قيمة التحريك الأساسية (من 0.0 إلى 1.0)
  late final Animation<double> _colorExpansionAnimation;

  // موقع البداية (أعلى المنتصف)
  late final Animation<Alignment> _alignmentAnimation;

  // شفافية الشعار في النهاية
  late final Animation<double> _logoOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 3000,
      ), // مدة أطول قليلاً لانتشار ناعم
    )..addStatusListener(_onAnimationStatus);

    _initAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SplashCubit>().startAnimation();
      _controller.forward();
    });
  }

  void _initAnimations() {
    // 1. تحريك الانتشار: يبدأ ببطء ثم يتسارع لملء الشاشة
    _colorExpansionAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.85, curve: Curves.easeInCubic),
    );

    // 2. موقع البداية: يبدأ من الأعلى وينزل للمنتصف (اختياري، بناءً على تصميمك)
    _alignmentAnimation =
        AlignmentTween(
          begin: const Alignment(0, -1.2), // يبدأ خارج الشاشة قليلاً من الأعلى
          end: Alignment.center,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.30, curve: Curves.easeOut),
          ),
        );

    // 3. ظهور الشعار: يبدأ بعد أن يملأ اللون معظم الشاشة
    _logoOpacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.80, 1.0, curve: Curves.easeIn),
    );
  }

  void _onAnimationStatus(AnimationStatus status) async {
    await Future.delayed(
      const Duration(milliseconds: 500),
    ); 
    if (status == AnimationStatus.completed && mounted) {
      context.read<SplashCubit>().onAnimationComplete();
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
      backgroundColor: Colors.white, // الخلفية الأساسية بيضاء
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return SizedBox.expand(
            child: Stack(
              children: [
                // 1. طبقة رسم اللون المنتشر
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ColorExpansionPainter(
                      progress: _colorExpansionAnimation.value,
                      alignment: _alignmentAnimation.value,
                      // نستخدم التدرج الخاص بك من app_colors.dart
                      gradient: splashGradient,
                    ),
                  ),
                ),

                // 2. طبقة الشعار (يظهر في النهاية)
                Center(
                  child: FadeTransition(
                    opacity: _logoOpacityAnimation,
                    child: Image.asset(
                      'assets/images/logo_white.png',
                      width: 180, // الحجم من Figma
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// رسام مخصص لرسم تمدد اللون
class _ColorExpansionPainter extends CustomPainter {
  final double progress;
  final Alignment alignment;
  final Gradient gradient;

  _ColorExpansionPainter({
    required this.progress,
    required this.alignment,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // حساب مركز الدائرة بناءً على الـ Alignment
    final center = alignment.withinRect(Offset.zero & size);

    // حساب أقصى نصف قطر مطلوب لتغطية الشاشة بالكامل
    // نستخدم نظرية فيثاغورس لحساب المسافة من المركز إلى أبعد زاوية
    final maxRadius = math.sqrt(
      math.pow(math.max(center.dx, size.width - center.dx), 2) +
          math.pow(math.max(center.dy, size.height - center.dy), 2),
    );

    // نصف القطر الحالي بناءً على التقدم
    final currentRadius = maxRadius * progress;

    // رسم الدائرة المتمددة
    final paint = Paint()
      ..shader = gradient.createShader(Offset.zero & size); // تطبيق التدرج

    canvas.drawCircle(center, currentRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _ColorExpansionPainter oldDelegate) {
    // إعادة الرسم فقط إذا تغيرت قيمة التقدم أو الموقع
    return oldDelegate.progress != progress ||
        oldDelegate.alignment != alignment;
  }
}
