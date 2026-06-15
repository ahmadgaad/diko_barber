import 'package:zain/features/salon_details/domain/entities/salon_details.dart';

sealed class SalonDetailsState {
  const SalonDetailsState();
}

class SalonDetailsLoading extends SalonDetailsState {
  const SalonDetailsLoading();
}

class SalonDetailsLoaded extends SalonDetailsState {
  const SalonDetailsLoaded({
    required this.salon,
    this.isFavorite = false,
    this.couponCode,
    this.selectedServiceIds = const {},
    this.selectedPackageIds = const {},
  });

  final SalonDetails salon;
  final bool isFavorite;
  final String? couponCode;
  final Set<int> selectedServiceIds;
  final Set<int> selectedPackageIds;

  SalonDetailsLoaded copyWith({
    SalonDetails? salon,
    bool? isFavorite,
    String? couponCode,
    Set<int>? selectedServiceIds,
    Set<int>? selectedPackageIds,
  }) {
    return SalonDetailsLoaded(
      salon: salon ?? this.salon,
      isFavorite: isFavorite ?? this.isFavorite,
      couponCode: couponCode ?? this.couponCode,
      selectedServiceIds: selectedServiceIds ?? this.selectedServiceIds,
      selectedPackageIds: selectedPackageIds ?? this.selectedPackageIds,
    );
  }
}

class SalonDetailsError extends SalonDetailsState {
  const SalonDetailsError();
}
