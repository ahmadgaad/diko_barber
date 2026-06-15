import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/shared/domain/entities/nearest_package.dart';

class PackageDiscountBadge extends StatelessWidget {
  const PackageDiscountBadge({super.key, required this.package});

  final NearestPackage package;

  String get _label {
    final d = package.discount;
    if (d == null) return '';
    if (d.type == 'percentage') return '-${d.value.toStringAsFixed(0)}%';
    return '-${d.value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        _label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
