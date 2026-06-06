import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ronaq_barber/core/di/service_locator.dart';
import 'package:ronaq_barber/core/l10n/app_locales.dart';
import 'package:ronaq_barber/core/locale/domain/use_cases/save_locale_use_case.dart';
import 'package:ronaq_barber/core/resources/svg_resources.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  Future<void> _toggleLocale(BuildContext context) async {
    final isEnglish = context.locale == AppLocales.en;
    final newLocale = isEnglish ? AppLocales.ar : AppLocales.en;
    await context.setLocale(newLocale);
    await sl<SaveLocaleUseCase>()(newLocale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _toggleLocale(context),
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
