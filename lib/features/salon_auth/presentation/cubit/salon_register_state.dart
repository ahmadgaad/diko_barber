import 'package:equatable/equatable.dart';
import 'package:zain/core/shared/domain/entities/category.dart';
import 'package:zain/core/shared/domain/entities/city.dart';
import 'package:zain/core/shared/domain/entities/neighborhood.dart';

sealed class SalonRegisterState extends Equatable {
  const SalonRegisterState();
}

final class SalonRegisterFormState extends SalonRegisterState {
  const SalonRegisterFormState({
    this.currentStep = 0,
    // Step 1 - Account
    this.ownerName = '',
    this.salonName = '',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.passwordConfirmation = '',
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    // Step 1 errors
    this.ownerNameError,
    this.salonNameError,
    this.phoneError,
    this.emailError,
    this.passwordError,
    this.passwordConfirmationError,
    // Step 2 - Salon Details
    this.specialization,
    this.availableCategories = const [],
    this.selectedCategoryIds = const [],
    this.categoriesLoading = false,
    this.cities = const [],
    this.selectedCity,
    this.neighborhoods = const [],
    this.selectedNeighborhood,
    this.citiesLoading = false,
    this.neighborhoodsLoading = false,
    this.description = '',
    this.location = '',
    this.commercialRegistrationNumber = '',
    this.pickedLat,
    this.pickedLng,
    this.pickedAddress,
    this.logoPath,
    this.commercialRegistrationImagePath,
    // Step 2 errors
    this.specializationError,
    this.categoriesError,
    this.cityError,
    // Common
    this.apiError,
    this.isSubmitting = false,
  });

  final int currentStep;

  // Step 1
  final String ownerName;
  final String salonName;
  final String phone;
  final String email;
  final String password;
  final String passwordConfirmation;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final String? ownerNameError;
  final String? salonNameError;
  final String? phoneError;
  final String? emailError;
  final String? passwordError;
  final String? passwordConfirmationError;

  // Step 2
  final int? specialization;
  final List<Category> availableCategories;
  final List<int> selectedCategoryIds;
  final bool categoriesLoading;
  final List<City> cities;
  final City? selectedCity;
  final List<Neighborhood> neighborhoods;
  final Neighborhood? selectedNeighborhood;
  final bool citiesLoading;
  final bool neighborhoodsLoading;
  final String description;
  final String location;
  final String commercialRegistrationNumber;
  final double? pickedLat;
  final double? pickedLng;
  final String? pickedAddress;
  final String? logoPath;
  final String? commercialRegistrationImagePath;
  final String? specializationError;
  final String? categoriesError;
  final String? cityError;

  final String? apiError;
  final bool isSubmitting;

  SalonRegisterFormState copyWith({
    int? currentStep,
    String? ownerName,
    String? salonName,
    String? phone,
    String? email,
    String? password,
    String? passwordConfirmation,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    String? Function()? ownerNameError,
    String? Function()? salonNameError,
    String? Function()? phoneError,
    String? Function()? emailError,
    String? Function()? passwordError,
    String? Function()? passwordConfirmationError,
    int? Function()? specialization,
    List<Category>? availableCategories,
    List<int>? selectedCategoryIds,
    bool? categoriesLoading,
    List<City>? cities,
    City? Function()? selectedCity,
    List<Neighborhood>? neighborhoods,
    Neighborhood? Function()? selectedNeighborhood,
    bool? citiesLoading,
    bool? neighborhoodsLoading,
    String? description,
    String? location,
    String? commercialRegistrationNumber,
    double? Function()? pickedLat,
    double? Function()? pickedLng,
    String? Function()? pickedAddress,
    String? Function()? logoPath,
    String? Function()? commercialRegistrationImagePath,
    String? Function()? specializationError,
    String? Function()? categoriesError,
    String? Function()? cityError,
    String? Function()? apiError,
    bool? isSubmitting,
  }) {
    return SalonRegisterFormState(
      currentStep: currentStep ?? this.currentStep,
      ownerName: ownerName ?? this.ownerName,
      salonName: salonName ?? this.salonName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword:
          obscureConfirmPassword ?? this.obscureConfirmPassword,
      ownerNameError:
          ownerNameError != null ? ownerNameError() : this.ownerNameError,
      salonNameError:
          salonNameError != null ? salonNameError() : this.salonNameError,
      phoneError: phoneError != null ? phoneError() : this.phoneError,
      emailError: emailError != null ? emailError() : this.emailError,
      passwordError:
          passwordError != null ? passwordError() : this.passwordError,
      passwordConfirmationError: passwordConfirmationError != null
          ? passwordConfirmationError()
          : this.passwordConfirmationError,
      specialization:
          specialization != null ? specialization() : this.specialization,
      availableCategories: availableCategories ?? this.availableCategories,
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      cities: cities ?? this.cities,
      selectedCity: selectedCity != null ? selectedCity() : this.selectedCity,
      neighborhoods: neighborhoods ?? this.neighborhoods,
      selectedNeighborhood: selectedNeighborhood != null
          ? selectedNeighborhood()
          : this.selectedNeighborhood,
      citiesLoading: citiesLoading ?? this.citiesLoading,
      neighborhoodsLoading: neighborhoodsLoading ?? this.neighborhoodsLoading,
      description: description ?? this.description,
      location: location ?? this.location,
      commercialRegistrationNumber:
          commercialRegistrationNumber ?? this.commercialRegistrationNumber,
      pickedLat: pickedLat != null ? pickedLat() : this.pickedLat,
      pickedLng: pickedLng != null ? pickedLng() : this.pickedLng,
      pickedAddress:
          pickedAddress != null ? pickedAddress() : this.pickedAddress,
      logoPath: logoPath != null ? logoPath() : this.logoPath,
      commercialRegistrationImagePath: commercialRegistrationImagePath != null
          ? commercialRegistrationImagePath()
          : this.commercialRegistrationImagePath,
      specializationError: specializationError != null
          ? specializationError()
          : this.specializationError,
      categoriesError:
          categoriesError != null ? categoriesError() : this.categoriesError,
      cityError: cityError != null ? cityError() : this.cityError,
      apiError: apiError != null ? apiError() : this.apiError,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        ownerName,
        salonName,
        phone,
        email,
        password,
        passwordConfirmation,
        obscurePassword,
        obscureConfirmPassword,
        ownerNameError,
        salonNameError,
        phoneError,
        emailError,
        passwordError,
        passwordConfirmationError,
        specialization,
        availableCategories,
        selectedCategoryIds,
        categoriesLoading,
        cities,
        selectedCity,
        neighborhoods,
        selectedNeighborhood,
        citiesLoading,
        neighborhoodsLoading,
        description,
        location,
        commercialRegistrationNumber,
        pickedLat,
        pickedLng,
        pickedAddress,
        logoPath,
        commercialRegistrationImagePath,
        specializationError,
        categoriesError,
        cityError,
        apiError,
        isSubmitting,
      ];
}

final class SalonRegisterSuccess extends SalonRegisterState {
  const SalonRegisterSuccess({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

final class SalonRegisterNavigate extends SalonRegisterState {
  const SalonRegisterNavigate({required this.target});

  final String target;

  @override
  List<Object?> get props => [target];
}
