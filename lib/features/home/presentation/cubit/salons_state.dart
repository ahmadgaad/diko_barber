import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';

sealed class SalonsState {
  const SalonsState();
}

class SalonsLoading extends SalonsState {
  const SalonsLoading();
}

class SalonsLoaded extends SalonsState {
  const SalonsLoaded(this.salons, {this.location});
  final List<Salon> salons;
  final String? location;
}

class SalonsError extends SalonsState {
  const SalonsError();
}
