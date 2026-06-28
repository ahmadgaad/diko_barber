import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:zain/core/cache/cache_keys.dart';
import 'package:zain/core/cache/secure_storage_cache_client.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/router/app_routes.dart';
import 'package:zain/core/services/firebase_messaging_service.dart';
import 'package:zain/core/services/location_service.dart';
import 'package:zain/core/shared/domain/entities/city.dart';
import 'package:zain/core/shared/domain/entities/neighborhood.dart';
import 'package:zain/core/shared/domain/use_cases/get_cities_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/get_neighborhoods_use_case.dart';
import 'package:zain/features/auth/domain/entities/sign_up_params.dart';
import 'package:zain/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:zain/features/auth/domain/use_cases/social_login_use_case.dart';

import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    required SignUpUseCase signUpUseCase,
    required GetCitiesUseCase getCitiesUseCase,
    required GetNeighborhoodsUseCase getNeighborhoodsUseCase,
    required SecureStorageCacheClient secureStorage,
    required SocialLoginUseCase socialLoginUseCase,
    required LocationService locationService,
  }) : _signUpUseCase = signUpUseCase,
       _getCitiesUseCase = getCitiesUseCase,
       _getNeighborhoodsUseCase = getNeighborhoodsUseCase,
       _secureStorage = secureStorage,
       _socialLoginUseCase = socialLoginUseCase,
       _locationService = locationService,
       super(const SignUpFormState()) {
    _loadCities();
  }

  final SignUpUseCase _signUpUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final GetNeighborhoodsUseCase _getNeighborhoodsUseCase;
  final SecureStorageCacheClient _secureStorage;
  final SocialLoginUseCase _socialLoginUseCase;
  final LocationService _locationService;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final _phoneRegex = RegExp(r'^[+]?[0-9]{7,15}$');

  SignUpFormState get _formState => state as SignUpFormState;

  // ── Step 1 field changes ─────────────────────────────────────────────────

  void onNameChanged(String value) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(name: value, nameError: () => null));
  }

  void onPhoneChanged(String value) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(phone: value, contactError: () => null));
  }

  void onEmailChanged(String value) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(email: value, contactError: () => null));
  }

  void onPasswordChanged(String value) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(password: value, passwordError: () => null));
  }

  void onPasswordConfirmationChanged(String value) {
    if (state is! SignUpFormState) return;
    emit(
      _formState.copyWith(
        passwordConfirmation: value,
        passwordConfirmationError: () => null,
      ),
    );
  }

  void togglePasswordVisibility() {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(obscurePassword: !_formState.obscurePassword));
  }

  void toggleConfirmPasswordVisibility() {
    if (state is! SignUpFormState) return;
    emit(
      _formState.copyWith(
        obscureConfirmPassword: !_formState.obscureConfirmPassword,
      ),
    );
  }

  // ── Step 2 field changes ─────────────────────────────────────────────────

  void onGenderSelected(int gender) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(gender: () => gender));
  }

  void onCitySelected(City city) {
    if (state is! SignUpFormState) return;
    emit(
      _formState.copyWith(
        selectedCity: () => city,
        selectedNeighborhood: () => null,
        neighborhoods: [],
      ),
    );
    _loadNeighborhoods(city.id);
  }

  void onNeighborhoodSelected(Neighborhood neighborhood) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(selectedNeighborhood: () => neighborhood));
  }

  void onAgeChanged(String value) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(age: value));
  }

  void onImagePicked(String path) {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(imagePath: () => path));
  }

  void removeImage() {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(imagePath: () => null));
  }

  // ── Navigation ───────────────────────────────────────────────────────────

  void goToStep2() {
    if (state is! SignUpFormState) return;

    final nameError = _validateName(_formState.name);
    final contactError = _validateContact(
      phone: _formState.phone,
      email: _formState.email,
    );
    final passwordError = _validatePassword(_formState.password);
    final confirmError = _validateConfirmPassword(
      _formState.password,
      _formState.passwordConfirmation,
    );

    if (nameError != null ||
        contactError != null ||
        passwordError != null ||
        confirmError != null) {
      emit(
        _formState.copyWith(
          nameError: () => nameError,
          contactError: () => contactError,
          passwordError: () => passwordError,
          passwordConfirmationError: () => confirmError,
        ),
      );
      return;
    }

    emit(
      _formState.copyWith(
        currentStep: 1,
        nameError: () => null,
        contactError: () => null,
        passwordError: () => null,
        passwordConfirmationError: () => null,
      ),
    );
  }

  void goToStep1() {
    if (state is! SignUpFormState) return;
    emit(_formState.copyWith(currentStep: 0));
  }

  Future<void> loginWithFacebook() async {
    if (state is! SignUpFormState) return;

    emit(_formState.copyWith(isSubmitting: true, apiError: () => null));

    final loginResult = await FacebookAuth.instance.login();

    if (loginResult.status != LoginStatus.success) {
      emit(_formState.copyWith(isSubmitting: false));
      return;
    }

    final accessToken = loginResult.accessToken!.tokenString;
    final fcmToken = await FirebaseMessagingService.getFcmToken();

    final result = await _socialLoginUseCase(
      provider: 'facebook',
      accessToken: accessToken,
      fcmToken: fcmToken,
    );

    switch (result) {
      case Success(:final data):
        if (data.token != null) {
          await _secureStorage.set(CacheKeys.userAccessToken, data.token!);
        }
        await _secureStorage.set(
          CacheKeys.userIsVerified,
          data.isVerified.toString(),
        );
        await _secureStorage.set(CacheKeys.userName, data.user.name);
        emit(const SignUpSocialSuccess());
      case Failure(:final error):
        emit(
          _formState.copyWith(
            isSubmitting: false,
            apiError: () => error.message,
          ),
        );
    }
  }

  void navigateToSignIn() {
    emit(const SignUpNavigate(target: AppRoutes.login));
  }

  // ── Submit ───────────────────────────────────────────────────────────────

  Future<void> signUp() async {
    if (state is! SignUpFormState) return;

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

    final fcmToken = await FirebaseMessagingService.getFcmToken();

    final params = SignUpParams(
      name: _formState.name,
      phone: _formState.phone.isNotEmpty ? _formState.phone : null,
      email: _formState.email.isNotEmpty ? _formState.email : null,
      password: _formState.password,
      passwordConfirmation: _formState.passwordConfirmation,
      cityId: _formState.selectedCity?.id,
      neighborhoodId: _formState.selectedNeighborhood?.id,
      gender: _formState.gender,
      age: _formState.age.isNotEmpty ? int.tryParse(_formState.age) : null,
      imagePath: _formState.imagePath,
      lat: position?.latitude,
      lng: position?.longitude,
      location: address,
      fcmToken: fcmToken,
    );

    final result = await _signUpUseCase(params);

    switch (result) {
      case Success():
        emit(SignUpSuccess(email: _formState.email, phone: _formState.phone));
      case Failure(:final error):
        emit(
          _formState.copyWith(
            isSubmitting: false,
            apiError: () => error.message,
          ),
        );
    }
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<void> _loadCities() async {
    emit(_formState.copyWith(citiesLoading: true));
    final result = await _getCitiesUseCase();
    if (state is! SignUpFormState) return;
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
    if (state is! SignUpFormState) return;
    switch (result) {
      case Success(:final data):
        emit(
          _formState.copyWith(neighborhoods: data, neighborhoodsLoading: false),
        );
      case Failure():
        emit(_formState.copyWith(neighborhoodsLoading: false));
    }
  }

  String? _validateName(String value) {
    if (value.trim().isEmpty) return 'auth.name_required';
    return null;
  }

  String? _validateContact({required String phone, required String email}) {
    if (email.isEmpty) return 'auth.email_required';
    if (!_emailRegex.hasMatch(email)) return 'auth.email_invalid';
    if (phone.isNotEmpty && !_phoneRegex.hasMatch(phone)) {
      return 'auth.phone_invalid';
    }
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'auth.password_required';
    if (password.length < 8) return 'auth.password_min_length';
    return null;
  }

  String? _validateConfirmPassword(String password, String confirmation) {
    if (confirmation.isEmpty) return 'auth.password_confirmation_required';
    if (password != confirmation) return 'auth.password_confirmation_mismatch';
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
