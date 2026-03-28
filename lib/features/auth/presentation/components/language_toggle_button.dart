import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:diko_barber/core/di/service_locator.dart';
import 'package:diko_barber/core/l10n/app_locales.dart';
import 'package:diko_barber/core/locale/domain/use_cases/save_locale_use_case.dart';
import 'package:diko_barber/core/resources/svg_resources.dart';
import 'package:diko_barber/core/theme/app_colors.dart';

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
    final color = AppColors.of(context).neutral900;

    return TextButton.icon(
      onPressed: () => _toggleLocale(context),
      iconAlignment: IconAlignment.end,
      icon: SvgPicture.asset(
        SvgResources.global,
        width: 20.w,
        height: 20.h,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
      label: Text(
        tr('auth.language_toggle'),
        style: TextStyle(
          color: color,
          fontSize: 16.sp,
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
