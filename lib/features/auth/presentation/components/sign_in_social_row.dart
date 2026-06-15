import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/resources/svg_resources.dart';
import 'package:zain/core/widgets/social_icon_button.dart';

class SignInSocialRow extends StatelessWidget {
  const SignInSocialRow({
    super.key,
    this.onAppleTap,
    this.onGoogleTap,
    this.onFacebookTap,
  });

  final VoidCallback? onAppleTap;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (Platform.isIOS) ...[
          SocialIconButton(
            svgPath: SvgResources.apple,
            onTap: onAppleTap ?? () {},
            colorFilter: isDark
                ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                : null,
          ),
          SizedBox(width: 16.w),
        ],
        SocialIconButton(
          svgPath: SvgResources.google,
          onTap: onGoogleTap ?? () {},
        ),
        SizedBox(width: 16.w),
        SocialIconButton(
          svgPath: SvgResources.facebook,
          onTap: onFacebookTap ?? () {},
        ),
      ],
    );
  }
}
