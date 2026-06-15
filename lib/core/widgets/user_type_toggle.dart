import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zain/core/theme/app_colors.dart';

class UserTypeToggle extends StatelessWidget {
  const UserTypeToggle({
    super.key,
    required this.isCustomer,
    required this.onCustomerTap,
    required this.onSalonOwnerTap,
  });

  final bool isCustomer;
  final VoidCallback onCustomerTap;
  final VoidCallback onSalonOwnerTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: colors.neutral100,
          borderRadius: BorderRadius.circular(999.r),
        ),
        child: Row(
          children: [
            _buildTab(
              label: tr('auth.toggle_customer'),
              isActive: isCustomer,
              onTap: onCustomerTap,
              colors: colors,
            ),
            _buildTab(
              label: tr('auth.toggle_salon_owner'),
              isActive: !isCustomer,
              onTap: onSalonOwnerTap,
              colors: colors,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required AppColors colors,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: isActive ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: isActive ? splashOrange : Colors.transparent,
            borderRadius: BorderRadius.circular(999.r),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: splashOrange.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? Colors.white : colors.neutral500,
            ),
          ),
        ),
      ),
    );
  }
}
