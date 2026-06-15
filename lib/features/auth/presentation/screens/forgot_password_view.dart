import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:zain/core/resources/svg_resources.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/core/widgets/app_text_form_field.dart';
import 'package:zain/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:zain/features/auth/presentation/cubit/forgot_password_state.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listenWhen: (previous, current) {
        if (current is ForgotPasswordFormState) {
          if (previous is ForgotPasswordFormState) {
            return current.apiError != null &&
                current.apiError != previous.apiError;
          }
          return current.apiError != null;
        }
        return true;
      },
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          context.push(
            AppRoutes.verifyResetPassword,
            extra: _emailController.text.trim(),
          );
        }
        if (state is ForgotPasswordFormState && state.apiError != null) {
          AppSnackBar.show(context, message: state.apiError!);
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(child: _buildBody(context)),
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
              tr('auth.forgot_password_title'),
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
          _buildIcon(colors),
          SizedBox(height: 32.h),
          Text(
            tr('auth.forgot_password_title'),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            tr('auth.forgot_password_subtitle'),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: colors.neutral600,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40.h),
          _buildForm(context),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildIcon(AppColors colors) {
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
            Icons.lock_reset_rounded,
            color: Colors.white,
            size: 32.w,
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      buildWhen: (_, current) => current is ForgotPasswordFormState,
      builder: (context, state) {
        final formState = state as ForgotPasswordFormState;
        final cubit = context.read<ForgotPasswordCubit>();

        return Column(
          children: [
            AppTextFormField(
              label: tr('auth.email_label'),
              hint: tr('auth.email_hint'),
              controller: _emailController,
              onChanged: cubit.onEmailChanged,
              errorText: formState.emailError != null
                  ? tr(formState.emailError!)
                  : null,
              isRequired: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
            SizedBox(height: 32.h),
            AppGradientButton(
              label: tr('auth.send_code'),
              enabled: formState.isValid,
              isLoading: formState.isSubmitting,
              onTap: cubit.submit,
            ),
          ],
        );
      },
    );
  }
}
