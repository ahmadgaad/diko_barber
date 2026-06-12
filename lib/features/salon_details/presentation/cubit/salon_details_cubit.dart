import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/shared/domain/entities/package.dart';
import 'package:ronaq_barber/core/shared/domain/entities/review.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon_details.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon_service.dart';
import 'package:ronaq_barber/features/salon_details/presentation/cubit/salon_details_state.dart';

class SalonDetailsCubit extends Cubit<SalonDetailsState> {
  SalonDetailsCubit() : super(const SalonDetailsLoading());

  void load(int salonId, {String? couponCode}) {
    emit(const SalonDetailsLoading());
    Future.delayed(const Duration(milliseconds: 600), () {
      if (isClosed) return;
      emit(SalonDetailsLoaded(salon: _mockSalon(salonId), couponCode: couponCode));
    });
  }

  void toggleFavorite() {
    final current = state;
    if (current is! SalonDetailsLoaded) return;
    emit(current.copyWith(isFavorite: !current.isFavorite));
  }

  SalonDetails _mockSalon(int id) {
    return SalonDetails(
      id: id,
      name: 'صالون القص الملكي',
      logo: 'https://picsum.photos/seed/salon$id/80/80',
      coverImage: 'https://picsum.photos/seed/cover$id/800/400',
      description:
          'صالون حلاقة فاخر يقدم أرقى خدمات العناية بالشعر واللحية. '
          'فريقنا من المحترفين المدربين يضمن تجربة استثنائية في كل زيارة.',
      rating: 4.8,
      reviewCount: 234,
      distance: 1.2,
      categories: ['شعر', 'لحية', 'بشرة'],
      isOpen: true,
      closingTime: '10:00 م',
      isFavorite: false,
      address: 'شارع التحرير، وسط البلد، القاهرة',
      gallery: List.generate(
        8,
        (i) => 'https://picsum.photos/seed/gallery${id}_$i/400/300',
      ),
      services: [
        const SalonService(
          id: 1,
          name: 'قص الشعر الكلاسيكي',
          description: 'قصة شعر احترافية بالمقص وماكينة القص',
          image: 'https://picsum.photos/seed/svc1/200/200',
          price: 120,
          durationMinutes: 30,
          rating: 4.9,
        ),
        const SalonService(
          id: 2,
          name: 'تشذيب وتشكيل اللحية',
          description: 'تشذيب وتشكيل اللحية مع الموس الاحترافي',
          image: 'https://picsum.photos/seed/svc2/200/200',
          price: 80,
          durationMinutes: 20,
          rating: 4.8,
        ),
        const SalonService(
          id: 3,
          name: 'قص الشعر + تشذيب اللحية',
          description: 'الباقة الأساسية شاملة قصة الشعر وتشذيب اللحية',
          image: 'https://picsum.photos/seed/svc3/200/200',
          price: 180,
          durationMinutes: 50,
          rating: 4.9,
        ),
        const SalonService(
          id: 4,
          name: 'تنظيف البشرة العميق',
          description: 'تنظيف وترطيب البشرة بأفضل المنتجات العناية',
          image: 'https://picsum.photos/seed/svc4/200/200',
          price: 200,
          durationMinutes: 45,
          rating: 4.7,
        ),
        const SalonService(
          id: 5,
          name: 'تصفيف الشعر',
          description: 'تصفيف وتشكيل الشعر بالكريمات الفاخرة',
          image: 'https://picsum.photos/seed/svc5/200/200',
          price: 100,
          durationMinutes: 25,
          rating: 4.6,
        ),
      ],
      packages: [
        const Package(
          id: 1,
          name: 'الباقة الأساسية',
          description: 'قصة شعر + تشذيب اللحية',
          image: 'https://picsum.photos/seed/pkg1/300/200',
          price: 180,
          rating: 4.8,
        ),
        const Package(
          id: 2,
          name: 'الباقة الكاملة',
          description: 'عناية شاملة: قص + لحية + غسيل + تصفيف',
          image: 'https://picsum.photos/seed/pkg2/300/200',
          price: 320,
          rating: 4.9,
        ),
        const Package(
          id: 3,
          name: 'تجربة VIP',
          description: 'عناية فاخرة كاملة مع تنظيف البشرة والعلاج',
          image: 'https://picsum.photos/seed/pkg3/300/200',
          price: 500,
          rating: 5.0,
        ),
        const Package(
          id: 4,
          name: 'باقة العريس',
          description: 'عناية متكاملة ليومك الأهم: شعر + لحية + بشرة',
          image: 'https://picsum.photos/seed/pkg4/300/200',
          price: 750,
          rating: 5.0,
        ),
      ],
      reviews: [
        Review(
          id: 1,
          userName: 'أحمد محمد',
          userAvatar: 'https://picsum.photos/seed/user1/80/80',
          rating: 5.0,
          comment:
              'خدمة ممتازة وفريق محترف جداً. سأعود بالتأكيد!',
          createdAt: DateTime(2026, 5, 20),
        ),
        Review(
          id: 2,
          userName: 'محمود علي',
          userAvatar: 'https://picsum.photos/seed/user2/80/80',
          rating: 4.5,
          comment:
              'المكان نظيف وأنيق، والحلاق متميز في عمله. أنصح به بشدة.',
          createdAt: DateTime(2026, 5, 15),
        ),
        Review(
          id: 3,
          userName: 'عمر خالد',
          userAvatar: 'https://picsum.photos/seed/user3/80/80',
          rating: 5.0,
          comment:
              'أفضل صالون جربته على الإطلاق. القصة بالضبط اللي طلبتها!',
          createdAt: DateTime(2026, 5, 10),
        ),
        Review(
          id: 4,
          userName: 'كريم إبراهيم',
          userAvatar: 'https://picsum.photos/seed/user4/80/80',
          rating: 4.0,
          comment:
              'جودة عالية وأسعار معقولة بالنسبة للخدمة المقدمة.',
          createdAt: DateTime(2026, 4, 28),
        ),
      ],
    );
  }
}
