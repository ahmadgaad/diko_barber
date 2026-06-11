import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/shared/domain/entities/featured_service.dart';

import 'featured_services_state.dart';

class FeaturedServicesCubit extends Cubit<FeaturedServicesState> {
  FeaturedServicesCubit() : super(const FeaturedServicesLoading()) {
    _loadMock();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 550));
    if (isClosed) return;
    emit(const FeaturedServicesLoaded(_mockServices));
  }

  static const _mockServices = [
    FeaturedService(
      id: 1,
      name: 'قص الشعر',
      image: '',
      price: 150,
      rating: 4.8,
    ),
    FeaturedService(
      id: 2,
      name: 'تشذيب اللحية',
      image: '',
      price: 80,
      rating: 4.7,
    ),
    FeaturedService(
      id: 3,
      name: 'تنظيف البشرة',
      image: '',
      price: 120,
      rating: 4.6,
    ),
    FeaturedService(
      id: 4,
      name: 'تصفيف الشعر',
      image: '',
      price: 100,
      rating: 4.5,
    ),
  ];
}
