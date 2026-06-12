import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ronaq_barber/core/resources/svg_resources.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/core/theme/cubit/theme_cubit.dart';
import 'package:ronaq_barber/core/theme/cubit/theme_state.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final color = AppColors.of(context).neutral900;
        final icon = state.isDark ? SvgResources.sun : SvgResources.moon;

        return TextButton(
          onPressed: () => context.read<ThemeCubit>().toggle(),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size(40.w, 40.h),
          ),
          child: SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.h,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        );
      },
    );
  }
}
