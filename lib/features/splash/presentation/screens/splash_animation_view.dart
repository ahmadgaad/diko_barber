import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/resources/image_resources.dart';
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

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _nameOpacity;
  late final Animation<double> _nameSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..addStatusListener(_onStatus);

    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
      ),
    );

    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.40),
    );

    _nameOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.42, 0.72),
    );

    _nameSlide = Tween<double>(begin: 16.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.42, 0.72, curve: Curves.easeOut),
      ),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(gradient: splashGradient),
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => Column(
                children: [
                  const Spacer(flex: 5),

                  Transform.scale(
                    scale: _logoScale.value,
                    child: Opacity(
                      opacity: _logoOpacity.value.clamp(0.0, 1.0),
                      child: Image.asset(
                        ImageResources.logo,
                        width: 130.r,
                        height: 130.r,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: 28.h),

                  Transform.translate(
                    offset: Offset(0, _nameSlide.value),
                    child: Opacity(
                      opacity: _nameOpacity.value.clamp(0.0, 1.0),
                      child: Text(
                        'زين',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 6,
                          height: 1,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
