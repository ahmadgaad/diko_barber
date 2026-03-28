import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'language_toggle_button.dart';
import 'onboarding_dots_indicator.dart';
import 'onboarding_primary_button.dart';
import 'onboarding_secondary_button.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    super.key,
    required this.imagePath,
    required this.heading,
    required this.body,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
    required this.pageCount,
    required this.currentPage,
  });

  final String imagePath;
  final String heading;
  final String body;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;
  final int pageCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(imagePath, fit: BoxFit.cover),
        ),
        // Dark overlay
        Positioned.fill(
          child: ColoredBox(color: const Color(0x52000000)),
        ),
        // Bottom gradient
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 406.h,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black],
              ),
            ),
          ),
        ),
        // Language toggle — top right
        Positioned(
          top: 70.h,
          right: 16.w,
          child: const LanguageToggleButton(),
        ),
        // Content block
        Positioned(
          top: 507.h,
          left: 16.w,
          right: 16.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  height: 28 / 24,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                body,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  height: 24 / 16,
                ),
              ),
              SizedBox(height: 20.h),
              OnboardingDotsIndicator(
                pageCount: pageCount,
                currentPage: currentPage,
              ),
              SizedBox(height: 16.h),
              OnboardingPrimaryButton(
                label: primaryLabel,
                onTap: onPrimary,
              ),
              SizedBox(height: 12.h),
              OnboardingSecondaryButton(
                label: secondaryLabel,
                onTap: onSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
