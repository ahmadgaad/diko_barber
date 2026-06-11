import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';

sealed class SalonsState {
  const SalonsState();
}

class SalonsLoading extends SalonsState {
  const SalonsLoading();
}

class SalonsLoaded extends SalonsState {
  const SalonsLoaded(this.salons);
  final List<Salon> salons;
}

class SalonsError extends SalonsState {
  const SalonsError();
}
