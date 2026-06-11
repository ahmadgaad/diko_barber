import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';

import 'salons_state.dart';

class SalonsCubit extends Cubit<SalonsState> {
  SalonsCubit() : super(const SalonsLoading()) {
    _loadMock();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    emit(const SalonsLoaded(_mockSalons));
  }

  static const _mockSalons = [
    Salon(
      id: 1,
      name: 'صالون القص الملكي',
      logo: '',
      rating: 4.8,
      distance: 1.2,
      categories: ['شعر', 'لحية'],
      isOpen: true,
      closingTime: '10:00 م',
      lat: 24.7136,
      lng: 46.6753,
    ),
    Salon(
      id: 2,
      name: 'صالون البرستيج',
      logo: '',
      rating: 4.6,
      distance: 2.5,
      categories: ['شعر', 'بشرة'],
      isOpen: true,
      closingTime: '9:00 م',
      lat: 24.7200,
      lng: 46.6900,
    ),
    Salon(
      id: 3,
      name: 'ركن الرجل الأنيق',
      logo: '',
      rating: 4.9,
      distance: 0.8,
      categories: ['شعر', 'لحية', 'بشرة'],
      isOpen: false,
      lat: 24.7080,
      lng: 46.6680,
    ),
    Salon(
      id: 4,
      name: 'العناية العصرية',
      logo: '',
      rating: 4.5,
      distance: 3.1,
      categories: ['شعر'],
      isOpen: true,
      closingTime: '11:00 م',
      lat: 24.7300,
      lng: 46.7050,
    ),
  ];
}
