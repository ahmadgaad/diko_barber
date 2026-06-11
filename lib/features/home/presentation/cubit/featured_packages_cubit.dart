import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/shared/domain/entities/package.dart';

import 'featured_packages_state.dart';

class FeaturedPackagesCubit extends Cubit<FeaturedPackagesState> {
  FeaturedPackagesCubit() : super(const FeaturedPackagesLoading()) {
    _loadMock();
  }

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 650));
    if (isClosed) return;
    emit(const FeaturedPackagesLoaded(_mockPackages));
  }

  static const _mockPackages = [
    Package(
      id: 1,
      name: 'الباقة الأساسية',
      description: 'قصة شعر نظيفة وتشذيب لحية.',
      image: '',
      price: 200,
      rating: 4.8,
    ),
    Package(
      id: 2,
      name: 'الباقة الكاملة',
      description: 'عناية كاملة مع غسيل وتصفيف.',
      image: '',
      price: 350,
      rating: 4.7,
    ),
    Package(
      id: 3,
      name: 'تجربة فاخرة',
      description: 'عناية فاخرة للشعر والبشرة.',
      image: '',
      price: 500,
      rating: 4.9,
    ),
    Package(
      id: 4,
      name: 'باقة العريس',
      description: 'عناية كاملة ليومك المميز.',
      image: '',
      price: 800,
      rating: 4.9,
    ),
  ];
}
