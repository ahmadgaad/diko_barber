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
import 'package:zain/core/widgets/app_snack_bar.dart' show AppSnackBar, SnackBarType;
import 'package:zain/core/widgets/app_text_form_field.dart';
import 'package:zain/features/auth/presentation/cubit/reset_password_cubit.dart';
import 'package:zain/features/auth/presentation/cubit/reset_password_state.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          AppSnackBar.show(
            context,
            message: tr('auth.reset_password_success'),
            type: SnackBarType.success,
          );
          context.go(AppRoutes.login);
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
              tr('auth.reset_password_title'),
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
            tr('auth.reset_password_title'),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: colors.neutral900,
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
            Icons.lock_outline_rounded,
            color: Colors.white,
            size: 32.w,
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (_, current) => current is ResetPasswordFormState,
      builder: (context, state) {
        final formState = state as ResetPasswordFormState;
        final cubit = context.read<ResetPasswordCubit>();

        return Column(
          children: [
            AppTextFormField(
              label: tr('auth.new_password'),
              hint: tr('auth.password_hint_min'),
              controller: _passwordController,
              onChanged: cubit.onPasswordChanged,
              errorText: formState.passwordError != null
                  ? tr(formState.passwordError!)
                  : null,
              isRequired: true,
              obscureText: !formState.isPasswordVisible,
              textInputAction: TextInputAction.next,
              suffixIcon: GestureDetector(
                onTap: cubit.togglePasswordVisibility,
                child: Icon(
                  formState.isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20.w,
                  color: colors.neutral500,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            AppTextFormField(
              label: tr('auth.password_confirmation_label'),
              hint: tr('auth.password_confirmation_hint'),
              controller: _confirmController,
              onChanged: cubit.onPasswordConfirmationChanged,
              errorText: formState.passwordConfirmationError != null
                  ? tr(formState.passwordConfirmationError!)
                  : null,
              isRequired: true,
              obscureText: !formState.isConfirmVisible,
              textInputAction: TextInputAction.done,
              suffixIcon: GestureDetector(
                onTap: cubit.toggleConfirmVisibility,
                child: Icon(
                  formState.isConfirmVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20.w,
                  color: colors.neutral500,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            AppGradientButton(
              label: tr('auth.reset_password_title'),
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
