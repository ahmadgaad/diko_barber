import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ronaq_barber/core/router/app_routes.dart';
import 'package:ronaq_barber/core/theme/app_colors.dart';
import 'package:ronaq_barber/core/widgets/app_dropdown_field.dart';
import 'package:ronaq_barber/core/widgets/app_gradient_button.dart';
import 'package:ronaq_barber/core/widgets/app_snack_bar.dart';
import 'package:ronaq_barber/core/widgets/app_text_form_field.dart';
import 'package:ronaq_barber/core/widgets/user_type_toggle.dart';
import 'package:ronaq_barber/features/auth/presentation/components/sign_in_header.dart';
import 'package:ronaq_barber/features/salon_auth/presentation/cubit/salon_register_cubit.dart';
import 'package:ronaq_barber/features/salon_auth/presentation/cubit/salon_register_state.dart';

class SalonRegisterView extends StatefulWidget {
  const SalonRegisterView({super.key});

  @override
  State<SalonRegisterView> createState() => _SalonRegisterViewState();
}

class _SalonRegisterViewState extends State<SalonRegisterView> {
  final _ownerNameController = TextEditingController();
  final _salonNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _crNumberController = TextEditingController();
  final _imagePicker = ImagePicker();

  @override
  void dispose() {
    _ownerNameController.dispose();
    _salonNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _crNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SalonRegisterCubit, SalonRegisterState>(
      listenWhen: (previous, current) {
        if (current is SalonRegisterFormState) {
          if (previous is SalonRegisterFormState) {
            return current.apiError != null &&
                current.apiError != previous.apiError;
          }
          return current.apiError != null;
        }
        return true;
      },
      listener: (context, state) {
        switch (state) {
          case SalonRegisterNavigate(:final target):
            context.go(target);
          case SalonRegisterSuccess(:final email):
            context.go(AppRoutes.salonVerifyOtp, extra: email);
          case SalonRegisterFormState(:final apiError) when apiError != null:
            AppSnackBar.show(context, message: apiError);
          case SalonRegisterFormState():
            break;
        }
      },
      child: BlocBuilder<SalonRegisterCubit, SalonRegisterState>(
        buildWhen: (_, current) => current is SalonRegisterFormState,
        builder: (context, state) {
          final formState = state as SalonRegisterFormState;
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SignInHeader(),
                        _buildHeading(context),
                        UserTypeToggle(
                          isCustomer: false,
                          onCustomerTap: () =>
                              context.go(AppRoutes.signup, extra: 'toggle'),
                          onSalonOwnerTap: () {},
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

  Widget _buildHeading(BuildContext context) {
    final colors = AppColors.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr('salon_auth.register_title'),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: colors.neutral900,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            tr('salon_auth.register_subtitle'),
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

  Widget _buildStepIndicator(BuildContext context, SalonRegisterFormState state) {
    final colors = AppColors.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
      child: Row(
        children: [
          _buildStepChip(
            label: tr('salon_auth.step_account'),
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
            label: tr('salon_auth.step_details'),
            index: 1,
            currentStep: state.currentStep,
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildStepChip({
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

  // ── Step 1: Account Info ─────────────────────────────────────────────────

  Widget _buildStep1(BuildContext context, SalonRegisterFormState state) {
    final colors = AppColors.of(context);
    final cubit = context.read<SalonRegisterCubit>();

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextFormField(
            label: tr('salon_auth.owner_name_label'),
            hint: tr('salon_auth.owner_name_hint'),
            controller: _ownerNameController,
            onChanged: cubit.onOwnerNameChanged,
            errorText: state.ownerNameError != null
                ? tr(state.ownerNameError!)
                : null,
            isRequired: true,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('salon_auth.salon_name_label'),
            hint: tr('salon_auth.salon_name_hint'),
            controller: _salonNameController,
            onChanged: cubit.onSalonNameChanged,
            errorText: state.salonNameError != null
                ? tr(state.salonNameError!)
                : null,
            isRequired: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('salon_auth.phone_label'),
            hint: tr('salon_auth.phone_hint'),
            controller: _phoneController,
            onChanged: cubit.onPhoneChanged,
            errorText:
                state.phoneError != null ? tr(state.phoneError!) : null,
            isRequired: true,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('salon_auth.email_label'),
            hint: tr('salon_auth.email_hint'),
            controller: _emailController,
            onChanged: cubit.onEmailChanged,
            errorText:
                state.emailError != null ? tr(state.emailError!) : null,
            isRequired: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('salon_auth.password_label'),
            hint: tr('salon_auth.password_hint'),
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
              tr('salon_auth.password_hint_min'),
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
            ),
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('salon_auth.password_confirmation_label'),
            hint: tr('salon_auth.password_confirmation_hint'),
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
          AppGradientButton(
            label: tr('salon_auth.next'),
            onTap: cubit.goToStep2,
          ),
        ],
      ),
    );
  }

  // ── Step 2: Salon Details ────────────────────────────────────────────────

  Widget _buildStep2(BuildContext context, SalonRegisterFormState state) {
    final cubit = context.read<SalonRegisterCubit>();

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSpecializationSelector(context, state, cubit),
          SizedBox(height: 16.h),
          _buildCategoriesSection(context, state, cubit),
          SizedBox(height: 16.h),
          AppDropdownField(
            label: tr('salon_auth.city_label'),
            hint: tr('salon_auth.city_hint'),
            items: state.cities,
            itemLabel: (city) => city.name,
            value: state.selectedCity,
            isLoading: state.citiesLoading,
            errorText: state.cityError != null ? tr(state.cityError!) : null,
            onChanged: (city) {
              if (city != null) cubit.onCitySelected(city);
            },
          ),
          SizedBox(height: 16.h),
          AppDropdownField(
            label: tr('salon_auth.neighborhood_label'),
            hint: tr('salon_auth.neighborhood_hint'),
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
            label: tr('salon_auth.description_label'),
            hint: tr('salon_auth.description_hint'),
            controller: _descriptionController,
            onChanged: cubit.onDescriptionChanged,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 3,
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('salon_auth.location_label'),
            hint: tr('salon_auth.location_hint'),
            controller: _locationController,
            onChanged: cubit.onLocationChanged,
            keyboardType: TextInputType.streetAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            label: tr('salon_auth.cr_number_label'),
            hint: tr('salon_auth.cr_number_hint'),
            controller: _crNumberController,
            onChanged: cubit.onCrNumberChanged,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(height: 24.h),
          _buildLogoSection(context, state, cubit),
          SizedBox(height: 24.h),
          _buildCrImageSection(context, state, cubit),
          SizedBox(height: 32.h),
          AppGradientButton(
            label: tr('salon_auth.complete_registration'),
            isLoading: state.isSubmitting,
            onTap: cubit.register,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationSelector(
    BuildContext context,
    SalonRegisterFormState state,
    SalonRegisterCubit cubit,
  ) {
    final colors = AppColors.of(context);
    final options = [
      (value: 2, label: tr('salon_auth.spec_men')),
      (value: 1, label: tr('salon_auth.spec_women')),
      (value: 3, label: tr('salon_auth.spec_both')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: tr('salon_auth.specialization_label'),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.neutral900,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 16.sp, color: colors.error500),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            for (int i = 0; i < options.length; i++) ...[
              if (i > 0) SizedBox(width: 8.w),
              Expanded(child: _buildSpecChip(options[i], state, cubit, colors)),
            ],
          ],
        ),
        if (state.specializationError != null) ...[
          SizedBox(height: 6.h),
          Text(
            tr(state.specializationError!),
            style: TextStyle(fontSize: 12.sp, color: colors.error500),
          ),
        ],
      ],
    );
  }

  Widget _buildSpecChip(
    ({int value, String label}) opt,
    SalonRegisterFormState state,
    SalonRegisterCubit cubit,
    AppColors colors,
  ) {
    final isSelected = state.specialization == opt.value;
    return GestureDetector(
      onTap: () => cubit.onSpecializationSelected(opt.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? splashOrange.withValues(alpha: 0.08)
              : colors.neutral50,
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected ? splashOrange : colors.neutral300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          opt.label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? splashOrange : colors.neutral700,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(
    BuildContext context,
    SalonRegisterFormState state,
    SalonRegisterCubit cubit,
  ) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: tr('salon_auth.categories_label'),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.neutral900,
                ),
              ),
              TextSpan(
                text: ' *',
                style: TextStyle(fontSize: 16.sp, color: colors.error500),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        if (state.specialization == null)
          Text(
            tr('salon_auth.categories_select_spec_first'),
            style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
          )
        else if (state.categoriesLoading)
          Center(
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(splashOrange),
              ),
            ),
          )
        else if (state.availableCategories.isEmpty)
          Text(
            tr('salon_auth.categories_empty'),
            style: TextStyle(fontSize: 13.sp, color: colors.neutral500),
          )
        else
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: state.availableCategories.map((category) {
              final isSelected =
                  state.selectedCategoryIds.contains(category.id);
              return GestureDetector(
                onTap: () => cubit.onCategoryToggled(category.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? splashOrange.withValues(alpha: 0.1)
                        : colors.neutral50,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(
                      color: isSelected ? splashOrange : colors.neutral300,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color:
                          isSelected ? splashOrange : colors.neutral700,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        if (state.categoriesError != null) ...[
          SizedBox(height: 6.h),
          Text(
            tr(state.categoriesError!),
            style: TextStyle(fontSize: 12.sp, color: colors.error500),
          ),
        ],
      ],
    );
  }

  Widget _buildLogoSection(
    BuildContext context,
    SalonRegisterFormState state,
    SalonRegisterCubit cubit,
  ) {
    final colors = AppColors.of(context);
    final hasLogo = state.logoPath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('salon_auth.logo_label'),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: colors.neutral900,
          ),
        ),
        SizedBox(height: 8.h),
        Center(
          child: GestureDetector(
            onTap: () => _pickImage(
              onPicked: cubit.onLogoPickedChanged,
            ),
            child: Stack(
              children: [
                Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.neutral100,
                    border: Border.all(color: colors.neutral200, width: 2),
                    image: hasLogo
                        ? DecorationImage(
                            image: FileImage(File(state.logoPath!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hasLogo
                      ? null
                      : Icon(
                          Icons.store_rounded,
                          size: 36.w,
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
        ),
        SizedBox(height: 6.h),
        Center(
          child: Text(
            hasLogo
                ? tr('salon_auth.change_logo')
                : tr('salon_auth.add_logo'),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: splashOrange,
            ),
          ),
        ),
        Center(
          child: Text(
            tr('salon_auth.optional'),
            style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
          ),
        ),
      ],
    );
  }

  Widget _buildCrImageSection(
    BuildContext context,
    SalonRegisterFormState state,
    SalonRegisterCubit cubit,
  ) {
    final colors = AppColors.of(context);
    final hasCrImage = state.commercialRegistrationImagePath != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('salon_auth.cr_image_label'),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: colors.neutral900,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          tr('salon_auth.cr_image_hint'),
          style: TextStyle(fontSize: 12.sp, color: colors.neutral500),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => _pickImage(onPicked: cubit.onCrImagePickedChanged),
          child: Container(
            height: 120.h,
            decoration: BoxDecoration(
              color: hasCrImage ? null : colors.neutral100,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: hasCrImage ? splashOrange : colors.neutral300,
                width: hasCrImage ? 1.5 : 1,
                style: hasCrImage ? BorderStyle.solid : BorderStyle.solid,
              ),
              image: hasCrImage
                  ? DecorationImage(
                      image: FileImage(
                        File(state.commercialRegistrationImagePath!),
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: hasCrImage
                ? null
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.upload_file_rounded,
                        size: 32.w,
                        color: colors.neutral400,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        tr('salon_auth.cr_image_upload'),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: colors.neutral500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (hasCrImage) ...[
          SizedBox(height: 6.h),
          TextButton.icon(
            onPressed: () => cubit.onCrImagePickedChanged(null),
            icon: Icon(Icons.delete_outline, size: 16.w, color: colors.error500),
            label: Text(
              tr('salon_auth.remove'),
              style: TextStyle(fontSize: 13.sp, color: colors.error500),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFooter(BuildContext context, SalonRegisterFormState state) {
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
                  tr('salon_auth.have_account'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.neutral600,
                  ),
                ),
                SizedBox(width: 4.w),
                GestureDetector(
                  onTap: () =>
                      context.read<SalonRegisterCubit>().navigateToSignIn(),
                  child: Text(
                    tr('salon_auth.sign_in_link'),
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
                  : () => context.read<SalonRegisterCubit>().goToStep1(),
              child: Text(
                '← ${tr('salon_auth.step_account')}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.neutral600,
                ),
              ),
            ),
    );
  }

  Future<void> _pickImage({required void Function(String?) onPicked}) async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (picked != null) {
      onPicked(picked.path);
    }
  }
}
