import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/theme/app_colors.dart';
import 'package:zain/core/widgets/app_cupertino_select_field.dart';
import 'package:zain/core/widgets/app_gradient_button.dart';
import 'package:zain/core/widgets/app_snack_bar.dart';
import 'package:zain/core/widgets/app_text_form_field.dart';
import 'package:zain/core/widgets/user_type_toggle.dart';
import 'package:zain/features/auth/presentation/components/sign_in_header.dart';
import 'package:zain/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:zain/features/auth/presentation/cubit/sign_up_state.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (previous, current) {
        if (current is SignUpFormState) {
          if (previous is SignUpFormState) {
            return current.apiError != null &&
                current.apiError != previous.apiError;
          }
          return current.apiError != null;
        }
        return true;
      },
      listener: (context, state) {
        switch (state) {
          case SignUpNavigate(:final target):
            context.go(target);
          case SignUpSuccess(:final email):
            context.go(AppRoutes.verifyOtp, extra: email);
          case SignUpSocialSuccess():
            context.go(AppRoutes.home);
          case SignUpFormState(:final apiError) when apiError != null:
            AppSnackBar.show(context, message: apiError);
          case SignUpFormState():
            break;
        }
      },
      child: BlocBuilder<SignUpCubit, SignUpState>(
        buildWhen: (_, current) => current is SignUpFormState,
        builder: (context, state) {
          final formState = state as SignUpFormState;
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SignInHeader(),
                        _buildHeadingSection(context),
                        UserTypeToggle(
                          isCustomer: true,
                          onCustomerTap: () {},
                          onSalonOwnerTap: () => context.go(
                            AppRoutes.salonSignup,
                            extra: 'toggle',
                          ),
                        ),
                        _buildStepIndicator(context, formState),
                        SizedBox(height: 8.h),
                        if (formState.currentStep == 0)
                          _buildStep1(context, formState)
                        else
                          _buildStep2(context, formState),
                      ],
                    ),
                  ),
                ),
                _buildFooter(context, formState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeadingSection(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 0),
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

  Widget _buildStepIndicator(BuildContext context, SignUpFormState state) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
      child: Row(
        children: [
          _buildStepChip(
            context,
            label: tr('auth.step_account'),
            index: 0,
            currentStep: state.currentStep,
            colors: colors,
          ),
          10.horizontalSpace,
          Expanded(
            child: Container(
              height: 2.h,
              color: state.currentStep >= 1 ? splashOrange : colors.neutral200,
            ),
          ),
          _buildStepChip(
            context,
            label: tr('auth.step_profile'),
            index: 1,
            currentStep: state.currentStep,
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildStepChip(
    BuildContext context, {
    required String label,
    required int index,
    required int currentStep,
    required AppColors colors,
  }) {
    final isActive = currentStep >= index;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? splashOrange : colors.neutral200,
          ),
          alignment: Alignment.center,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : colors.neutral500,
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: isActive ? colors.neutral900 : colors.neutral500,
          ),
        ),
      ],
    );
  }

  // ── Step 1: Account ──────────────────────────────────────────────────────

  Widget _buildStep1(BuildContext context, SignUpFormState state) {
    final colors = AppColors.of(context);
    final cubit = context.read<SignUpCubit>();

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextFormField(
            label: tr('auth.full_name_label'),
            hint: tr('auth.full_name_hint'),
            controller: _nameController,
            onChanged: cubit.onNameChanged,
            errorText: state.nameError != null ? tr(state.nameError!) : null,
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
            errorText: state.contactError != null
                ? tr(state.contactError!)
                : null,
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('auth.phone_label'),
            hint: tr('auth.phone_hint'),
            controller: _phoneController,
            onChanged: cubit.onPhoneChanged,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('auth.password_label'),
            hint: tr('auth.password_hint'),
            controller: _passwordController,
            onChanged: cubit.onPasswordChanged,
            errorText: state.passwordError != null
                ? tr(state.passwordError!)
                : null,
            isRequired: true,
            obscureText: state.obscurePassword,
            textInputAction: TextInputAction.next,
            suffixIcon: GestureDetector(
              onTap: cubit.togglePasswordVisibility,
              child: Icon(
                state.obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20.w,
                color: colors.neutral500,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              tr('auth.password_hint_min'),
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
            ),
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('auth.password_confirmation_label'),
            hint: tr('auth.password_confirmation_hint'),
            controller: _confirmPasswordController,
            onChanged: cubit.onPasswordConfirmationChanged,
            errorText: state.passwordConfirmationError != null
                ? tr(state.passwordConfirmationError!)
                : null,
            isRequired: true,
            obscureText: state.obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            suffixIcon: GestureDetector(
              onTap: cubit.toggleConfirmPasswordVisibility,
              child: Icon(
                state.obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 20.w,
                color: colors.neutral500,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          AppGradientButton(label: tr('auth.next'), onTap: cubit.goToStep2),
        ],
      ),
    );
  }

  // ── Step 2: Profile ──────────────────────────────────────────────────────

  Widget _buildStep2(BuildContext context, SignUpFormState state) {
    final cubit = context.read<SignUpCubit>();

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImagePicker(context, state, cubit),
          SizedBox(height: 24.h),
          _buildGenderSelector(context, state, cubit),
          SizedBox(height: 16.h),
          AppCupertinoSelectField(
            label: tr('auth.city_label'),
            hint: tr('auth.city_hint'),
            items: state.cities,
            itemLabel: (city) => city.name,
            value: state.selectedCity,
            isLoading: state.citiesLoading,
            onChanged: (city) {
              if (city != null) cubit.onCitySelected(city);
            },
          ),
          SizedBox(height: 16.h),
          AppCupertinoSelectField(
            label: tr('auth.neighborhood_label'),
            hint: tr('auth.neighborhood_hint'),
            items: state.neighborhoods,
            itemLabel: (n) => n.name,
            value: state.selectedNeighborhood,
            isLoading: state.neighborhoodsLoading,
            onChanged: (n) {
              if (n != null) cubit.onNeighborhoodSelected(n);
            },
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('auth.age_label'),
            hint: tr('auth.age_hint'),
            controller: _ageController,
            onChanged: cubit.onAgeChanged,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 32.h),
          AppGradientButton(
            label: tr('auth.complete_registration'),
            isLoading: state.isSubmitting,
            onTap: cubit.signUp,
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(
    BuildContext context,
    SignUpFormState state,
    SignUpCubit cubit,
  ) {
    final colors = AppColors.of(context);
    final hasImage = state.imagePath != null;

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pickImage(cubit),
            child: Stack(
              children: [
                Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.neutral100,
                    border: Border.all(color: colors.neutral200, width: 2),
                    image: hasImage
                        ? DecorationImage(
                            image: FileImage(File(state.imagePath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hasImage
                      ? null
                      : Icon(
                          Icons.person_outline_rounded,
                          size: 40.w,
                          color: colors.neutral400,
                        ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: splashOrange,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 14.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            hasImage ? tr('auth.change_photo') : tr('auth.add_photo'),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: splashOrange,
            ),
          ),
          Text(
            tr('auth.optional'),
            style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector(
    BuildContext context,
    SignUpFormState state,
    SignUpCubit cubit,
  ) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('auth.gender_label'),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: colors.neutral900,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                context,
                label: tr('auth.gender_male'),
                value: 1,
                selected: state.gender == 1,
                colors: colors,
                onTap: () => cubit.onGenderSelected(1),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildGenderOption(
                context,
                label: tr('auth.gender_female'),
                value: 2,
                selected: state.gender == 2,
                colors: colors,
                onTap: () => cubit.onGenderSelected(2),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(
    BuildContext context, {
    required String label,
    required int value,
    required bool selected,
    required AppColors colors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: selected
              ? splashOrange.withValues(alpha: 0.08)
              : colors.neutral50,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: selected ? splashOrange : colors.neutral300,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? splashOrange : colors.neutral700,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, SignUpFormState state) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: 12.h,
        bottom: 24.h,
        left: 16.w,
        right: 16.w,
      ),
      child: state.currentStep == 0
          ? Row(
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
            )
          : TextButton(
              onPressed: state.isSubmitting
                  ? null
                  : () => context.read<SignUpCubit>().goToStep1(),
              child: Text(
                '← ${tr('auth.step_account')}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.neutral600,
                ),
              ),
            ),
    );
  }

  Future<void> _pickImage(SignUpCubit cubit) async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    if (picked != null) {
      cubit.onImagePicked(picked.path);
    }
  }
}
