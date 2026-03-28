import 'package:diko_barber/core/components/app_divider_with_text.dart';
import 'package:diko_barber/core/components/app_gradient_button.dart';
import 'package:diko_barber/core/components/app_text_form_field.dart';
import 'package:diko_barber/core/router/app_routes.dart';
import 'package:diko_barber/core/theme/app_colors.dart';
import 'package:diko_barber/features/auth/presentation/components/sign_in_header.dart';
import 'package:diko_barber/features/auth/presentation/components/sign_in_social_row.dart';
import 'package:diko_barber/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:diko_barber/features/auth/presentation/cubit/sign_up_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        switch (state) {
          case SignUpNavigate(:final target):
            context.go(target);
          case SignUpSuccess(:final email):
            context.push(AppRoutes.verifyOtp, extra: email);
          case SignUpFormState():
            break;
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(child: _buildContent(context)),
            ),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SignInHeader(),
        _buildHeadingSection(context),
        _buildFormSection(context),
        _buildDividerSection(),
        _buildSocialSection(),
      ],
    );
  }

  Widget _buildHeadingSection(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('auth.create_account'),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            tr('auth.sign_up_subtitle'),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: colors.neutral700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => current is SignUpFormState,
      builder: (context, state) {
        final formState = state as SignUpFormState;
        final cubit = context.read<SignUpCubit>();

        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextFormField(
                label: tr('auth.full_name_label'),
                hint: tr('auth.full_name_hint'),
                controller: _fullNameController,
                onChanged: cubit.onFullNameChanged,
                errorText: formState.fullNameError != null
                    ? tr(formState.fullNameError!)
                    : null,
                isRequired: true,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16.h),
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
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16.h),
              AppTextFormField(
                label: tr('auth.password_label'),
                hint: tr('auth.password_hint'),
                controller: _passwordController,
                onChanged: cubit.onPasswordChanged,
                errorText: formState.passwordError != null
                    ? tr(formState.passwordError!)
                    : null,
                isRequired: true,
                obscureText: formState.obscurePassword,
                textInputAction: TextInputAction.done,
                suffixIcon: GestureDetector(
                  onTap: cubit.togglePasswordVisibility,
                  child: Icon(
                    formState.obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 20.w,
                    color: colors.neutral500,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                tr('auth.password_hint_min'),
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.neutral500,
                ),
              ),
              SizedBox(height: 32.h),
              AppGradientButton(
                label: tr('auth.create_account'),
                enabled: formState.isValid && !formState.isSubmitting,
                onTap: cubit.signUp,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDividerSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AppDividerWithText(text: tr('auth.or_continue_with')),
    );
  }

  Widget _buildSocialSection() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: const SignInSocialRow(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: 16.h,
        bottom: 24.h,
        left: 16.w,
        right: 16.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            tr('auth.have_account'),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: colors.neutral600,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: () => context.read<SignUpCubit>().navigateToSignIn(),
            child: Text(
              tr('auth.sign_in_link'),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: splashOrange,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
