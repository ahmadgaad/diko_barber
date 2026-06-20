import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import '../../domain/entities/payment_method.dart';
import '../cubit/checkout_cubit.dart';
import '../cubit/checkout_state.dart';

class PaymentMethodsSheet extends StatelessWidget {
  const PaymentMethodsSheet({
    super.key,
    required this.colors,
    required this.appointmentId,
  });

  final AppColors colors;
  final int appointmentId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.neutral50,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colors.neutral300,
              borderRadius: BorderRadius.circular(99.r),
            ),
          ),
          SizedBox(height: 20.h),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              tr('checkout.choose_payment_method'),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: colors.neutral900,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          BlocBuilder<CheckoutCubit, CheckoutState>(
            builder: (context, state) => switch (state) {
              CheckoutPaymentMethodsLoading() =>
                _ShimmerList(colors: colors),
              CheckoutPaymentMethodsLoaded(:final methods, :final selectedMethodId) =>
                _MethodsList(
                  methods: methods,
                  selectedId: selectedMethodId,
                  colors: colors,
                ),
              CheckoutPaymentMethodsError(:final message) =>
                _ErrorBody(message: message, colors: colors),
              _ => const SizedBox.shrink(),
            },
          ),
          SizedBox(height: 16.h),
          BlocBuilder<CheckoutCubit, CheckoutState>(
            buildWhen: (prev, curr) =>
                curr is CheckoutPaymentMethodsLoaded ||
                curr is CheckoutPaymentMethodsLoading,
            builder: (context, state) {
              final loaded = state is CheckoutPaymentMethodsLoaded;
              final hasSelection = loaded && state.selectedMethodId != null;
              final isPaying = loaded && state.isPaying;
              return AppGradientButton(
                label: isPaying
                    ? tr('checkout.processing')
                    : tr('checkout.confirm_payment'),
                enabled: hasSelection && !isPaying,
                onTap: () {
                  Navigator.of(context).pop();
                  context
                      .read<CheckoutCubit>()
                      .payAppointment(appointmentId);
                },
              );
            },
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 16.h),
        ],
      ),
    );
  }
}

// ── Methods list ─────────────────────────────────────────────────────────────

class _MethodsList extends StatelessWidget {
  const _MethodsList({
    required this.methods,
    required this.selectedId,
    required this.colors,
  });

  final List<PaymentMethod> methods;
  final int? selectedId;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: methods.map((method) {
        final isSelected = selectedId == method.id;
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: GestureDetector(
            onTap: () =>
                context.read<CheckoutCubit>().selectMethod(method.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: colors.neutral100,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isSelected ? splashOrange : colors.neutral200,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedNetworkImage(
                      imageUrl: method.image,
                      width: 40.r,
                      height: 40.r,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => Container(
                        width: 40.r,
                        height: 40.r,
                        color: colors.neutral200,
                      ),
                      errorWidget: (_, _, _) => Container(
                        width: 40.r,
                        height: 40.r,
                        color: colors.neutral200,
                        child: Icon(
                          Icons.payment_rounded,
                          size: 20.r,
                          color: colors.neutral400,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      method.name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.neutral900,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: const BoxDecoration(
                        color: splashOrange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        size: 13.r,
                        color: Colors.white,
                      ),
                    )
                  else
                    Container(
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.neutral300,
                          width: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Shimmer loading ──────────────────────────────────────────────────────────

class _ShimmerList extends StatelessWidget {
  const _ShimmerList({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: colors.neutral200,
      highlightColor: colors.neutral100,
      child: Column(
        children: List.generate(
          3,
          (_) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              height: 64.h,
              decoration: BoxDecoration(
                color: colors.neutral200,
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Error body ───────────────────────────────────────────────────────────────

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.colors});

  final String message;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 32.r,
            color: colors.neutral400,
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () =>
                context.read<CheckoutCubit>().loadPaymentMethods(),
            child: Text(
              tr('checkout.retry'),
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: splashOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
