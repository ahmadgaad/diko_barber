import 'package:ronaq_barber/core/resources/svg_resources.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/auth/presentation/cubit/verify_otp_cubit.dart';
import 'package:ronaq_barber/features/auth/presentation/cubit/verify_otp_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpView extends StatelessWidget {
  const VerifyOtpView({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          context.go('/home');
        }
      },
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildAppBar(context), _buildContent(context)],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final colors = AppColors.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return SizedBox(
      height: 40.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: SizedBox(
                width: 24.w,
                height: 24.w,
                child: Center(
                  child: Transform.scale(
                    scaleX: isRtl ? -1 : 1,
                    child: SvgPicture.asset(
                      SvgResources.arrowBack,
                      fit: BoxFit.scaleDown,
                      colorFilter: ColorFilter.mode(
                        colors.neutral900,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                tr('auth.verify_email_title'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.neutral900,
                ),
              ),
            ),
            SizedBox(width: 24.w),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.only(top: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeading(colors),
          _buildOtpSection(context, colors),
          _buildResendRow(context, colors),
        ],
      ),
    );
  }

  Widget _buildHeading(AppColors colors) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('auth.verify_email_title'),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: colors.neutral600,
                height: 1.5,
              ),
              children: [
                TextSpan(text: tr('auth.verify_email_subtitle', args: [''])),
                TextSpan(
                  text: email,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpSection(BuildContext context, AppColors colors) {
    return BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
      buildWhen: (_, current) => current is VerifyOtpFormState,
      builder: (context, state) {
        final formState = state as VerifyOtpFormState;
        final hasError = formState.otpError != null;

        final defaultTheme = PinTheme(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colors.neutral300),
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: colors.neutral900,
          ),
        );

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Pinput(
                  length: 4,
                  defaultPinTheme: defaultTheme,
                  focusedPinTheme: defaultTheme.copyWith(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: splashOrange),
                    ),
                  ),
                  submittedPinTheme: hasError
                      ? defaultTheme.copyWith(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.error500),
                          ),
                        )
                      : defaultTheme.copyWith(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: colors.success500),
                          ),
                        ),
                  errorPinTheme: defaultTheme.copyWith(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.error500),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: context.read<VerifyOtpCubit>().onOtpChanged,
                  onCompleted: (_) => context.read<VerifyOtpCubit>().verify(),
                  forceErrorState: hasError,
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  tr(formState.otpError!),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.error500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildResendRow(BuildContext context, AppColors colors) {
    return BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
      buildWhen: (_, current) => current is VerifyOtpFormState,
      builder: (context, state) {
        final formState = state as VerifyOtpFormState;
        final cubit = context.read<VerifyOtpCubit>();

        return SizedBox(
          height: 56.h,
          child: Center(
            child: formState.canResend
                ? GestureDetector(
                    onTap: cubit.resend,
                    child: Text(
                      tr('auth.resend_code_action'),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: splashOrange,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tr('auth.resend_code'),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: colors.neutral600,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _formatCountdown(formState.countdown),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.neutral900,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  String _formatCountdown(int seconds) {
    final mm = (seconds ~/ 60).toString().padLeft(2, '0');
    final ss = (seconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}
