import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/di/service_locator.dart';
import 'package:zain/features/claim_coupon/presentation/claim_coupon_args.dart';
import 'package:zain/features/claim_coupon/presentation/cubit/claim_coupon_cubit.dart';
import 'claim_coupon_view.dart';

class ClaimCouponScreen extends StatelessWidget {
  const ClaimCouponScreen({super.key, required this.args});

  final ClaimCouponArgs args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ClaimCouponCubit>()
        ..load(
          couponId: args.couponId,
          couponCode: args.couponCode,
          couponName: args.couponName,
          salonName: args.salonName,
        ),
      child: const ClaimCouponView(),
    );
  }
}
