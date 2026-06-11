import 'package:ronaq_barber/core/shared/domain/entities/salon_details.dart';

sealed class SalonDetailsState {
  const SalonDetailsState();
}

class SalonDetailsLoading extends SalonDetailsState {
  const SalonDetailsLoading();
}

class SalonDetailsLoaded extends SalonDetailsState {
  const SalonDetailsLoaded({required this.salon, this.isFavorite = false});

  final SalonDetails salon;
  final bool isFavorite;

  SalonDetailsLoaded copyWith({SalonDetails? salon, bool? isFavorite}) {
    return SalonDetailsLoaded(
      salon: salon ?? this.salon,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class SalonDetailsError extends SalonDetailsState {
  const SalonDetailsError();
}
