import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/services/location_service.dart';
import 'package:zain/core/shared/domain/entities/city.dart';
import 'package:zain/core/shared/domain/entities/neighborhood.dart';
import 'package:zain/core/shared/domain/use_cases/get_categories_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/get_cities_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/get_neighborhoods_use_case.dart';
import 'package:zain/features/salon_auth/domain/entities/salon_register_params.dart';
import 'package:zain/features/salon_auth/domain/use_cases/salon_register_use_case.dart';

import 'salon_register_state.dart';

class SalonRegisterCubit extends Cubit<SalonRegisterState> {
  SalonRegisterCubit({
    required SalonRegisterUseCase salonRegisterUseCase,
    required GetCitiesUseCase getCitiesUseCase,
    required GetNeighborhoodsUseCase getNeighborhoodsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required LocationService locationService,
  })  : _salonRegisterUseCase = salonRegisterUseCase,
        _getCitiesUseCase = getCitiesUseCase,
        _getNeighborhoodsUseCase = getNeighborhoodsUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        _locationService = locationService,
        super(const SalonRegisterFormState()) {
    _loadCities();
  }

  final SalonRegisterUseCase _salonRegisterUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetNeighborhoodsUseCase _getNeighborhoodsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final LocationService _locationService;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final _phoneRegex = RegExp(r'^01[0-9]{9}$');

  SalonRegisterFormState get _formState => state as SalonRegisterFormState;

  // ── Step 1 field changes ─────────────────────────────────────────────────

  void onOwnerNameChanged(String value) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(ownerName: value, ownerNameError: () => null));
  }

  void onSalonNameChanged(String value) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(salonName: value, salonNameError: () => null));
  }

  void onPhoneChanged(String value) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(phone: value, phoneError: () => null));
  }

  void onEmailChanged(String value) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(email: value, emailError: () => null));
  }

  void onPasswordChanged(String value) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(password: value, passwordError: () => null));
  }

  void onPasswordConfirmationChanged(String value) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(
      passwordConfirmation: value,
      passwordConfirmationError: () => null,
    ));
  }

  void togglePasswordVisibility() {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(obscurePassword: !_formState.obscurePassword));
  }

  void toggleConfirmPasswordVisibility() {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(
      obscureConfirmPassword: !_formState.obscureConfirmPassword,
    ));
  }

  // ── Step 2 field changes ─────────────────────────────────────────────────

  void onSpecializationSelected(int value) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(
      specialization: () => value,
      availableCategories: [],
      selectedCategoryIds: [],
      specializationError: () => null,
      categoriesError: () => null,
    ));
    _loadCategories(value);
  }

  void onCategoryToggled(int categoryId) {
    if (state is! SalonRegisterFormState) return;
    final current = List<int>.from(_formState.selectedCategoryIds);
    if (current.contains(categoryId)) {
      current.remove(categoryId);
    } else {
      current.add(categoryId);
    }
    emit(_formState.copyWith(
      selectedCategoryIds: current,
      categoriesError: () => null,
    ));
  }

  void onCitySelected(City city) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(
      selectedCity: () => city,
      selectedNeighborhood: () => null,
      neighborhoods: [],
      cityError: () => null,
    ));
    _loadNeighborhoods(city.id);
  }

  void onNeighborhoodSelected(Neighborhood neighborhood) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(selectedNeighborhood: () => neighborhood));
  }

  void onDescriptionChanged(String value) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(description: value));
  }

  void onLocationChanged(String value) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(location: value));
  }

  void onCrNumberChanged(String value) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(commercialRegistrationNumber: value));
  }

  void onLogoPickedChanged(String? path) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(logoPath: () => path));
  }

  void onCrImagePickedChanged(String? path) {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(commercialRegistrationImagePath: () => path));
  }

  // ── Navigation ───────────────────────────────────────────────────────────

  void goToStep2() {
    if (state is! SalonRegisterFormState) return;

    final ownerNameError = _validateRequired(_formState.ownerName, 'salon_auth.owner_name_required');
    final salonNameError = _validateRequired(_formState.salonName, 'salon_auth.salon_name_required');
    final phoneError = _validatePhone(_formState.phone);
    final emailError = _validateEmail(_formState.email);
    final passwordError = _validatePassword(_formState.password);
    final confirmError = _validateConfirmPassword(
      _formState.password,
      _formState.passwordConfirmation,
    );

    if (ownerNameError != null ||
        salonNameError != null ||
        phoneError != null ||
        emailError != null ||
        passwordError != null ||
        confirmError != null) {
      emit(_formState.copyWith(
        ownerNameError: () => ownerNameError,
        salonNameError: () => salonNameError,
        phoneError: () => phoneError,
        emailError: () => emailError,
        passwordError: () => passwordError,
        passwordConfirmationError: () => confirmError,
      ));
      return;
    }

    emit(_formState.copyWith(
      currentStep: 1,
      ownerNameError: () => null,
      salonNameError: () => null,
      phoneError: () => null,
      emailError: () => null,
      passwordError: () => null,
      passwordConfirmationError: () => null,
    ));
  }

  void goToStep1() {
    if (state is! SalonRegisterFormState) return;
    emit(_formState.copyWith(currentStep: 0));
  }

  void navigateToSignIn() {
    final current = _formState.copyWith(apiError: () => null);
    emit(SalonRegisterNavigate(target: AppRoutes.login));
    emit(current);
  }

  // ── Submit ───────────────────────────────────────────────────────────────

  Future<void> register() async {
    if (state is! SalonRegisterFormState) return;

    final specializationError = _formState.specialization == null
        ? 'salon_auth.specialization_required'
        : null;
    final categoriesError = _formState.selectedCategoryIds.isEmpty
        ? 'salon_auth.categories_required'
        : null;
    final cityError = _formState.selectedCity == null
        ? 'salon_auth.city_required'
        : null;

    if (specializationError != null ||
        categoriesError != null ||
        cityError != null) {
      emit(_formState.copyWith(
        specializationError: () => specializationError,
        categoriesError: () => categoriesError,
        cityError: () => cityError,
      ));
      return;
    }

    emit(_formState.copyWith(isSubmitting: true, apiError: () => null));

    final position = await _locationService.getCurrentPosition();
    String? address;
    if (position != null) {
      address = await _locationService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );
    }
    address ??= _buildLocationFallback();

    final params = SalonRegisterParams(
      ownerName: _formState.ownerName,
      name: _formState.salonName,
      phone: _formState.phone,
      email: _formState.email,
      password: _formState.password,
      passwordConfirmation: _formState.passwordConfirmation,
      specialization: _formState.specialization!,
      categoryIds: _formState.selectedCategoryIds,
      cityId: _formState.selectedCity!.id,
      neighborhoodId: _formState.selectedNeighborhood?.id,
      description:
          _formState.description.isNotEmpty ? _formState.description : null,
      location: address ?? (_formState.location.isNotEmpty ? _formState.location : null),
      lat: position?.latitude,
      lng: position?.longitude,
      commercialRegistrationNumber:
          _formState.commercialRegistrationNumber.isNotEmpty
              ? _formState.commercialRegistrationNumber
              : null,
      logoPath: _formState.logoPath,
      commercialRegistrationImagePath:
          _formState.commercialRegistrationImagePath,
    );

    final result = await _salonRegisterUseCase(params);

    switch (result) {
      case Success():
        emit(SalonRegisterSuccess(email: _formState.email));
      case Failure(:final error):
        emit(_formState.copyWith(
          isSubmitting: false,
          apiError: () => error.message,
        ));
    }
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<void> _loadCities() async {
    emit(_formState.copyWith(citiesLoading: true));
    final result = await _getCitiesUseCase();
    if (state is! SalonRegisterFormState) return;
    switch (result) {
      case Success(:final data):
        emit(_formState.copyWith(cities: data, citiesLoading: false));
      case Failure():
        emit(_formState.copyWith(citiesLoading: false));
    }
  }

  Future<void> _loadNeighborhoods(int cityId) async {
    emit(_formState.copyWith(neighborhoodsLoading: true));
    final result = await _getNeighborhoodsUseCase(cityId: cityId);
    if (state is! SalonRegisterFormState) return;
    switch (result) {
      case Success(:final data):
        emit(_formState.copyWith(
          neighborhoods: data,
          neighborhoodsLoading: false,
        ));
      case Failure():
        emit(_formState.copyWith(neighborhoodsLoading: false));
    }
  }

  Future<void> _loadCategories(int specialization) async {
    emit(_formState.copyWith(categoriesLoading: true));
    final result =
        await _getCategoriesUseCase(specialization: specialization);
    if (state is! SalonRegisterFormState) return;
    switch (result) {
      case Success(:final data):
        emit(_formState.copyWith(
          availableCategories: data,
          categoriesLoading: false,
        ));
      case Failure():
        emit(_formState.copyWith(categoriesLoading: false));
    }
  }

  String? _validateRequired(String value, String errorKey) =>
      value.trim().isEmpty ? errorKey : null;

  String? _validatePhone(String phone) {
    if (phone.trim().isEmpty) return 'salon_auth.phone_required';
    if (!_phoneRegex.hasMatch(phone.trim())) return 'salon_auth.phone_invalid';
    return null;
  }

  String? _validateEmail(String email) {
    if (email.trim().isEmpty) return 'salon_auth.email_required';
    if (!_emailRegex.hasMatch(email.trim())) return 'salon_auth.email_invalid';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'salon_auth.password_required';
    if (password.length < 8) return 'salon_auth.password_min_length';
    return null;
  }

  String? _validateConfirmPassword(String password, String confirmation) {
    if (confirmation.isEmpty) return 'salon_auth.password_confirmation_required';
    if (password != confirmation) {
      return 'salon_auth.password_confirmation_mismatch';
    }
    return null;
  }

  String? _buildLocationFallback() {
    final parts = [
      _formState.selectedCity?.name,
      _formState.selectedNeighborhood?.name,
    ].whereType<String>().toList();
    return parts.isEmpty ? null : parts.join(', ');
  }
}
