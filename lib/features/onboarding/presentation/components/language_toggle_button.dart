import 'package:diko_barber/core/l10n/app_locales.dart';
import 'package:diko_barber/core/resources/svg_resources.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isEnglish = context.locale == AppLocales.en;
    return TextButton.icon(
      onPressed: () =>
          context.setLocale(isEnglish ? AppLocales.ar : AppLocales.en),
      iconAlignment: IconAlignment.end,
      icon: SvgPicture.asset(
        SvgResources.global,
        width: 20,
        height: 20,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
      label: Text(
        tr('onboarding.language_toggle'),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
