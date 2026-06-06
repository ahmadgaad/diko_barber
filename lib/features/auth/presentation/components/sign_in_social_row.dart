import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ronaq_barber/core/widgets/social_icon_button.dart';
import 'package:ronaq_barber/core/resources/svg_resources.dart';

class SignInSocialRow extends StatelessWidget {
  const SignInSocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialIconButton(
          svgPath: SvgResources.apple,
          onTap: () {},
          colorFilter: isDark
              ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              : null,
        ),
        SizedBox(width: 16.w),
        SocialIconButton(
          svgPath: SvgResources.google,
          onTap: () {},
        ),
        SizedBox(width: 16.w),
        SocialIconButton(
          svgPath: SvgResources.facebook,
          onTap: () {},
        ),
      ],
    );
  }
}
