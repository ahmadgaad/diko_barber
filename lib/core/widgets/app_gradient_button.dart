import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';

class AppGradientButton extends StatelessWidget {
  const AppGradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.enabled = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool enabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isActive = enabled && !isLoading;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: GestureDetector(
        onTap: isActive ? onTap : null,
        child: SizedBox(
          height: 48.h,
          child: Stack(
            children: [
              // Disabled layer
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: isActive ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999.r),
                      color: colors.neutral200,
                    ),
                  ),
                ),
              ),
              // Gradient layer
              Positioned.fill(
                child: AnimatedOpacity(
                  opacity: isActive ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999.r),
                      gradient: buttonGradient,
                    ),
                  ),
                ),
              ),
              // Content
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isLoading
                      ? SizedBox(
                          key: const ValueKey('loading'),
                          width: 22.w,
                          height: 22.w,
                          child: CircularProgressIndicator.adaptive(
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          label,
                          key: const ValueKey('label'),
                          style: TextStyle(
                            color: isActive ? Colors.white : colors.neutral600,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
