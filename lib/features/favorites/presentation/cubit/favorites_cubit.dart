import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/shared/domain/entities/distance.dart';
import 'package:ronaq_barber/core/shared/domain/entities/package.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon_service.dart';
import 'package:ronaq_barber/core/shared/domain/entities/specialization.dart';
import 'package:ronaq_barber/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesLoading()) {
    _load();
  }

  void _load() {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (isClosed) return;
      emit(FavoritesLoaded(
        salons: _mockSalons(),
        packages: _mockPackages(),
        services: _mockServices(),
      ));
    });
  }

  List<Salon> _mockSalons() => [
        Salon(
          id: 1,
          name: 'صالون القص الملكي',
          image: 'https://picsum.photos/seed/salon1/200/200',
          averageRating: 4.9,
          ratingsCount: 0,
          distance: const Distance(value: 1200, unit: 'متر'),
          specialization: const Specialization(id: 1, name: 'رجال'),
          categories: const ['شعر', 'لحية'],
          isOpen: true,
          isFavorite: true,
          lat: 24.7136,
          lng: 46.6753,
        ),
        Salon(
          id: 3,
          name: 'ركن الرجل الأنيق',
          image: 'https://picsum.photos/seed/salon3/200/200',
          averageRating: 4.7,
          ratingsCount: 0,
          distance: const Distance(value: 3, unit: 'كم'),
          specialization: const Specialization(id: 1, name: 'رجال'),
          categories: const ['شعر', 'بشرة'],
          isOpen: false,
          isFavorite: true,
          lat: 24.7080,
          lng: 46.6680,
        ),
        Salon(
          id: 5,
          name: 'أكاديمية الحلاقة الحديثة',
          image: 'https://picsum.photos/seed/salon5/200/200',
          averageRating: 4.6,
          ratingsCount: 0,
          distance: const Distance(value: 5, unit: 'كم'),
          specialization: const Specialization(id: 1, name: 'رجال'),
          categories: const ['تصفيف', 'لحية'],
          isOpen: true,
          isFavorite: true,
          lat: 24.7050,
          lng: 46.6820,
        ),
      ];

  List<Package> _mockPackages() => [
        const Package(
          id: 2,
          name: 'الباقة الكاملة',
          description: 'عناية شاملة: قص + لحية + غسيل + تصفيف',
          image: 'https://picsum.photos/seed/pkg2/400/300',
          price: 320,
          rating: 4.9,
          isFavorite: true,
        ),
        const Package(
          id: 3,
          name: 'تجربة VIP',
          description: 'عناية فاخرة كاملة مع تنظيف البشرة والعلاج',
          image: 'https://picsum.photos/seed/pkg3/400/300',
          price: 500,
          rating: 5.0,
          isFavorite: true,
        ),
        const Package(
          id: 4,
          name: 'باقة العريس',
          description: 'عناية متكاملة ليومك الأهم: شعر + لحية + بشرة',
          image: 'https://picsum.photos/seed/pkg4/400/300',
          price: 750,
          rating: 5.0,
          isFavorite: true,
        ),
      ];

  List<SalonService> _mockServices() => [
        const SalonService(
          id: 1,
          name: 'قص الشعر الكلاسيكي',
          description: 'قصة شعر احترافية بالمقص وماكينة القص',
          image: 'https://picsum.photos/seed/svc1/300/200',
          price: 120,
          durationMinutes: 30,
          rating: 4.9,
          isFavorite: true,
        ),
        const SalonService(
          id: 3,
          name: 'قص الشعر + تشذيب اللحية',
          description: 'الباقة الأساسية شاملة قصة الشعر وتشذيب اللحية',
          image: 'https://picsum.photos/seed/svc3/300/200',
          price: 180,
          durationMinutes: 50,
          rating: 4.9,
          isFavorite: true,
        ),
        const SalonService(
          id: 4,
          name: 'تنظيف البشرة العميق',
          description: 'تنظيف وترطيب البشرة بأفضل المنتجات',
          image: 'https://picsum.photos/seed/svc4/300/200',
          price: 200,
          durationMinutes: 45,
          rating: 4.7,
          isFavorite: true,
        ),
      ];
}
