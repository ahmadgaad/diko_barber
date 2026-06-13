import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/packages/presentation/cubit/packages_list_cubit.dart';

class PackagesErrorView extends StatelessWidget {
  const PackagesErrorView({super.key, required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.r,
            color: colors.neutral400,
          ),
          SizedBox(height: 12.h),
          Text(
            tr('explore.error_body'),
            style: TextStyle(fontSize: 14.sp, color: colors.neutral600),
          ),
          SizedBox(height: 16.h),
          TextButton(
            onPressed: () => context.read<PackagesListCubit>().refresh(),
            child: Text(
              tr('package_details.retry'),
              style: const TextStyle(color: splashOrange),
            ),
          ),
        ],
      ),
    );
  }
}
