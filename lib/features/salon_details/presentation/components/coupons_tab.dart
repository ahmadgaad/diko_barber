import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ronaq_barber/core/shared/domain/entities/coupon.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/home/presentation/components/coupons_section.dart';
import 'package:ronaq_barber/features/salon_details/presentation/components/empty_tab.dart';

class CouponsTab extends StatelessWidget {
  const CouponsTab({super.key, required this.coupons, required this.colors});

  final List<Coupon> coupons;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) {
      return EmptyTab(
        icon: Icons.local_offer_outlined,
        message: tr('salon_details.no_coupons'),
        colors: colors,
      );
    }
    final width = MediaQuery.sizeOf(context).width - 32.w;
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: coupons.length,
      separatorBuilder: (_, _) => SizedBox(height: 16.h),
      itemBuilder: (context, i) => CouponCard(coupon: coupons[i], width: width),
    );
  }
}
