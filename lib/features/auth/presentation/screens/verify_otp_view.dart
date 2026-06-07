import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:ronaq_barber/core/resources/svg_resources.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/features/auth/presentation/cubit/verify_otp_cubit.dart';
import 'package:ronaq_barber/features/auth/presentation/cubit/verify_otp_state.dart';

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
          children: [
            _buildAppBar(context),
            Expanded(child: _buildBody(context)),
            _buildResendFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final colors = AppColors.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
    );
  }

  Widget _buildBody(BuildContext context) {
    final colors = AppColors.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 40.h),
          _buildEmailIcon(colors),
          SizedBox(height: 32.h),
          Text(
            tr('auth.verify_email_title'),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
                color: colors.neutral600,
                height: 1.6,
              ),
              children: [
                TextSpan(text: tr('auth.verify_email_subtitle', args: [''])),
                TextSpan(
                  text: email,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: colors.neutral900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 48.h),
          _buildOtpSection(context, colors),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildEmailIcon(AppColors colors) {
    return Container(
      width: 96.w,
      height: 96.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: splashOrange.withValues(alpha: 0.1),
      ),
      child: Center(
        child: Container(
          width: 64.w,
          height: 64.w,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: splashOrange,
          ),
          child: Icon(
            Icons.mark_email_unread_rounded,
            color: Colors.white,
            size: 32.w,
          ),
        ),
      ),
    );
  }

  Widget _buildOtpSection(BuildContext context, AppColors colors) {
    return BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
      buildWhen: (_, current) => current is VerifyOtpFormState,
      builder: (context, state) {
        final formState = state as VerifyOtpFormState;
        final hasError = formState.otpError != null;

        final baseTheme = PinTheme(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.neutral100,
            border: Border.all(color: colors.neutral300, width: 1.5),
          ),
          textStyle: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: colors.neutral900,
          ),
        );

        return Column(
          children: [
            Pinput(
              length: 4,
              defaultPinTheme: baseTheme,
              focusedPinTheme: baseTheme.copyWith(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: splashOrange.withValues(alpha: 0.08),
                  border: Border.all(color: splashOrange, width: 2),
                ),
              ),
              submittedPinTheme: hasError
                  ? baseTheme.copyWith(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.error50,
                        border: Border.all(color: colors.error500, width: 1.5),
                      ),
                    )
                  : baseTheme.copyWith(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.success50,
                        border:
                            Border.all(color: colors.success500, width: 1.5),
                      ),
                    ),
              errorPinTheme: baseTheme.copyWith(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.error50,
                  border: Border.all(color: colors.error500, width: 1.5),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: context.read<VerifyOtpCubit>().onOtpChanged,
              onCompleted: (_) => context.read<VerifyOtpCubit>().verify(),
              forceErrorState: hasError,
            ),
            if (hasError) ...[
              SizedBox(height: 16.h),
              Text(
                formState.otpError!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.error500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (formState.isSubmitting) ...[
              SizedBox(height: 24.h),
              SizedBox(
                width: 24.w,
                height: 24.w,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(splashOrange),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildResendFooter(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
      buildWhen: (_, current) => current is VerifyOtpFormState,
      builder: (context, state) {
        final formState = state as VerifyOtpFormState;
        final cubit = context.read<VerifyOtpCubit>();

        return Padding(
          padding: EdgeInsets.only(bottom: 32.h, top: 8.h),
          child: Center(
            child: formState.isResending
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(splashOrange),
                    ),
                  )
                : formState.canResend
                    ? GestureDetector(
                        onTap: cubit.resend,
                        child: Text(
                          tr('auth.resend_code_action'),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
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
                          SizedBox(width: 6.w),
                          Text(
                            _formatCountdown(formState.countdown),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: splashOrange,
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
