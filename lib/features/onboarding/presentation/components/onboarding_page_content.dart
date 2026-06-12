import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'onboarding_dots_indicator.dart';
import 'onboarding_primary_button.dart';
import 'onboarding_secondary_button.dart';

class OnboardingPageContent extends StatelessWidget {
  const OnboardingPageContent({
    super.key,
    required this.heading,
    required this.body,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimary,
    required this.onSecondary,
    required this.pageCount,
    required this.currentPage,
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
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
    );
  }
}
