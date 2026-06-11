import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';

import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit() : super(const ExploreLoading()) {
    _loadMock();
  }

  Timer? _debounce;

  Future<void> _loadMock() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (isClosed) return;
    emit(ExploreLoaded(salons: _mockSalons, categories: _allCategories));
  }

  void search(String query) {
    final current = state;
    if (current is! ExploreLoaded) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (isClosed) return;
      _applyFilters(query: query.trim(), category: current.selectedCategory);
    });
  }

  void selectCategory(String? category) {
    final current = state;
    if (current is! ExploreLoaded) return;
    _applyFilters(query: current.query, category: category);
  }

  void highlightSalon(int? id) {
    final current = state;
    if (current is! ExploreLoaded) return;
    emit(current.copyWith(highlightedSalonId: () => id));
  }

  void _applyFilters({required String query, required String? category}) {
    final lower = query.toLowerCase();
    final filtered = _mockSalons.where((salon) {
      final matchesQuery =
          lower.isEmpty || salon.name.toLowerCase().contains(lower);
      final matchesCategory =
          category == null || salon.categories.contains(category);
      return matchesQuery && matchesCategory;
    }).toList();

    emit(
      ExploreLoaded(
        salons: filtered,
        categories: _allCategories,
        query: query,
        selectedCategory: category,
      ),
    );
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  static final _allCategories = _mockSalons
      .expand((s) => s.categories)
      .toSet()
      .toList();

  static const _mockSalons = [
    Salon(
      id: 1,
      name: 'صالون القص الملكي',
      logo: 'https://picsum.photos/seed/explore1/400/300',
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
      logo: 'https://picsum.photos/seed/explore2/400/300',
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
      logo: 'https://picsum.photos/seed/explore3/400/300',
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
      logo: 'https://picsum.photos/seed/explore4/400/300',
      rating: 4.5,
      distance: 3.1,
      categories: ['شعر'],
      isOpen: true,
      closingTime: '11:00 م',
      lat: 24.7300,
      lng: 46.7050,
    ),
    Salon(
      id: 5,
      name: 'شفرة الأناقة',
      logo: 'https://picsum.photos/seed/explore5/400/300',
      rating: 4.7,
      distance: 1.9,
      categories: ['لحية', 'سبا'],
      isOpen: true,
      closingTime: '10:30 م',
      lat: 24.7050,
      lng: 46.6820,
    ),
    Salon(
      id: 6,
      name: 'صالة الفخامة',
      logo: 'https://picsum.photos/seed/explore6/400/300',
      rating: 4.4,
      distance: 4.2,
      categories: ['سبا', 'بشرة'],
      isOpen: false,
      lat: 24.7400,
      lng: 46.7150,
    ),
    Salon(
      id: 7,
      name: 'استوديو الفيد الكلاسيكي',
      logo: 'https://picsum.photos/seed/explore7/400/300',
      rating: 4.9,
      distance: 0.5,
      categories: ['شعر', 'تصفيف'],
      isOpen: true,
      closingTime: '12:00 ص',
      lat: 24.7160,
      lng: 46.6600,
    ),
    Salon(
      id: 8,
      name: 'الحلاق المحترف',
      logo: 'https://picsum.photos/seed/explore8/400/300',
      rating: 4.3,
      distance: 5.0,
      categories: ['شعر', 'لحية', 'تصفيف'],
      isOpen: true,
      closingTime: '9:30 م',
      lat: 24.6950,
      lng: 46.7200,
    ),
  ];
}
