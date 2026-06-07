import 'package:equatable/equatable.dart';
import 'package:ronaq_barber/core/shared/domain/entities/city.dart';
import 'package:ronaq_barber/core/shared/domain/entities/neighborhood.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();
}

final class SignUpFormState extends SignUpState {
  const SignUpFormState({
    this.currentStep = 0,
    // Step 1 fields
    this.name = '',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    // Step 1 errors
    this.nameError,
    this.contactError,
    this.passwordError,
    this.passwordConfirmationError,
    // Step 2 fields
    this.gender,
    this.selectedCity,
    this.selectedNeighborhood,
    this.age = '',
    this.imagePath,
    // Step 2 data
    this.cities = const [],
    this.neighborhoods = const [],
    this.citiesLoading = false,
    this.neighborhoodsLoading = false,
    // API error
    this.apiError,
    this.isSubmitting = false,
  });

  final int currentStep;

  // Step 1
  final String name;
  final String phone;
  final String email;
  final String password;
  final String passwordConfirmation;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String? nameError;
  final String? contactError;
  final String? passwordError;
  final String? passwordConfirmationError;

  // Step 2
  final int? gender;
  final City? selectedCity;
  final Neighborhood? selectedNeighborhood;
  final String age;
  final String? imagePath;
  final List<City> cities;
  final List<Neighborhood> neighborhoods;
  final bool citiesLoading;
  final bool neighborhoodsLoading;

  final String? apiError;
  final bool isSubmitting;

  bool get isStep1Valid =>
      name.isNotEmpty &&
      email.isNotEmpty &&
      password.isNotEmpty &&
      passwordConfirmation.isNotEmpty &&
      nameError == null &&
      contactError == null &&
      passwordError == null &&
      passwordConfirmationError == null;

  SignUpFormState copyWith({
    int? currentStep,
    String? name,
    String? phone,
    String? email,
    String? password,
    String? passwordConfirmation,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? Function()? nameError,
    String? Function()? contactError,
    String? Function()? passwordError,
    String? Function()? passwordConfirmationError,
    int? Function()? gender,
    City? Function()? selectedCity,
    Neighborhood? Function()? selectedNeighborhood,
    String? age,
    String? Function()? imagePath,
    List<City>? cities,
    List<Neighborhood>? neighborhoods,
    bool? citiesLoading,
    bool? neighborhoodsLoading,
    String? Function()? apiError,
    bool? isSubmitting,
  }) {
    return SignUpFormState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      nameError: nameError != null ? nameError() : this.nameError,
      contactError: contactError != null ? contactError() : this.contactError,
      passwordError:
          passwordError != null ? passwordError() : this.passwordError,
      passwordConfirmationError: passwordConfirmationError != null
          ? passwordConfirmationError()
          : this.passwordConfirmationError,
      gender: gender != null ? gender() : this.gender,
      selectedCity: selectedCity != null ? selectedCity() : this.selectedCity,
      selectedNeighborhood: selectedNeighborhood != null
          ? selectedNeighborhood()
          : this.selectedNeighborhood,
      age: age ?? this.age,
      imagePath: imagePath != null ? imagePath() : this.imagePath,
      cities: cities ?? this.cities,
      neighborhoods: neighborhoods ?? this.neighborhoods,
      citiesLoading: citiesLoading ?? this.citiesLoading,
      neighborhoodsLoading: neighborhoodsLoading ?? this.neighborhoodsLoading,
      apiError: apiError != null ? apiError() : this.apiError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        name,
        phone,
        email,
        password,
        passwordConfirmation,
        obscurePassword,
        obscureConfirmPassword,
        nameError,
        contactError,
        passwordError,
        passwordConfirmationError,
        gender,
        selectedCity,
        selectedNeighborhood,
        age,
        imagePath,
        cities,
        neighborhoods,
        citiesLoading,
        neighborhoodsLoading,
        apiError,
        isSubmitting,
      ];
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess({required this.email, required this.phone});

  final String email;
  final String phone;

  @override
  List<Object?> get props => [email, phone];
}

final class SignUpSocialSuccess extends SignUpState {
  const SignUpSocialSuccess();

  @override
  List<Object?> get props => [];
}

final class SignUpNavigate extends SignUpState {
  const SignUpNavigate({required this.target});

  final String target;

  @override
  List<Object?> get props => [target];
}
