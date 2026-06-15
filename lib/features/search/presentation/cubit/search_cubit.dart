import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/cache/cache_keys.dart';
import 'package:zain/core/cache/shared_pref_cache_client.dart';
import 'package:zain/core/shared/domain/entities/coupon.dart';
import 'package:zain/core/shared/domain/entities/distance.dart';
import 'package:zain/core/shared/domain/entities/salon.dart';
import 'package:zain/core/shared/domain/entities/specialization.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._cache) : super(const SearchLoading()) {
    _init();
  }

  final SharedPrefCacheClient _cache;

  static const _mockSalons = [
    Salon(id: 1, name: 'صالون القص الملكي', image: '', averageRating: 4.8, ratingsCount: 0, distance: Distance(value: 1200, unit: 'متر'), specialization: Specialization(id: 1, name: 'رجال'), categories: ['شعر', 'لحية'], isOpen: true, isFavorite: true, lat: 24.7136, lng: 46.6753),
    Salon(id: 2, name: 'صالون البرستيج', image: '', averageRating: 4.6, ratingsCount: 0, distance: Distance(value: 3, unit: 'كم'), specialization: Specialization(id: 1, name: 'رجال'), categories: ['شعر', 'بشرة'], isOpen: true, isFavorite: false, lat: 24.7200, lng: 46.6900),
    Salon(id: 3, name: 'ركن الرجل الأنيق', image: '', averageRating: 4.9, ratingsCount: 0, distance: Distance(value: 800, unit: 'متر'), specialization: Specialization(id: 1, name: 'رجال'), categories: ['شعر', 'لحية', 'بشرة'], isOpen: false, isFavorite: false, lat: 24.7080, lng: 46.6680),
    Salon(id: 4, name: 'العناية العصرية', image: '', averageRating: 4.5, ratingsCount: 0, distance: Distance(value: 3, unit: 'كم'), specialization: Specialization(id: 1, name: 'رجال'), categories: ['شعر'], isOpen: true, isFavorite: false, lat: 24.7300, lng: 46.7050),
    Salon(id: 5, name: 'بارز ستايل', image: '', averageRating: 4.7, ratingsCount: 0, distance: Distance(value: 2, unit: 'كم'), specialization: Specialization(id: 1, name: 'رجال'), categories: ['شعر', 'لحية'], isOpen: true, isFavorite: false, lat: 24.7050, lng: 46.6820),
    Salon(id: 6, name: 'صالون النخبة', image: '', averageRating: 4.3, ratingsCount: 0, distance: Distance(value: 4, unit: 'كم'), specialization: Specialization(id: 1, name: 'رجال'), categories: ['بشرة'], isOpen: false, isFavorite: false, lat: 24.7400, lng: 46.7150),
  ];

  Future<void> _init() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (isClosed) return;
    final recents = await _loadRecents();
    emit(_idle(recents));
  }

  void search(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _returnToIdle();
      return;
    }
    emit(SearchActive(query: trimmed, results: _filter(trimmed)));
  }

  void submitSearch(String query) => search(query);

  Future<void> selectSalon(Salon salon) async {
    final recents = [...await _loadRecents()]
      ..removeWhere((s) => s.id == salon.id)
      ..insert(0, salon);
    final trimmed =
        recents.length > 6 ? recents.sublist(0, 6) : recents;
    await _saveRecents(trimmed);
  }

  Future<void> removeRecent(int salonId) async {
    final recents = [..._currentRecents]
      ..removeWhere((s) => s.id == salonId);
    await _saveRecents(recents);
    final current = state;
    if (current is SearchIdle) {
      emit(_idle(recents,
          trending: current.trendingSalons, offers: current.hotOffers));
    }
  }

  Future<void> clearRecents() async {
    await _saveRecents(const []);
    final current = state;
    if (current is SearchIdle) {
      emit(_idle(const [],
          trending: current.trendingSalons, offers: current.hotOffers));
    }
  }

  void clearQuery() => _returnToIdle();

  Future<void> _returnToIdle() async {
    final recents = await _loadRecents();
    if (isClosed) return;
    emit(_idle(recents));
  }

  List<Salon> _filter(String query) {
    final q = query.toLowerCase();
    return _mockSalons
        .where((s) =>
            s.name.toLowerCase().contains(q) ||
            s.categories.any((c) => c.toLowerCase().contains(q)))
        .toList();
  }

  SearchIdle _idle(
    List<Salon> recents, {
    List<Salon>? trending,
    List<Coupon>? offers,
  }) {
    final now = DateTime.now();
    return SearchIdle(
      recentSalons: recents,
      trendingSalons: trending ?? _mockSalons.take(4).toList(),
      hotOffers: offers ??
          [
            Coupon(
              id: 1,
              code: 'SAVE20',
              name: 'خصم على قص الشعر',
              type: 1,
              typeLabel: 'نسبة مئوية',
              appliesTo: const CouponAppliesTo(id: 1, name: 'قص الشعر'),
              amount: 20,
              endDate: now.add(const Duration(days: 2)),
              salon: CouponSalon(
                id: 1,
                name: 'صالون القص الملكي',
                image: '',
                distance: const Distance(value: 1200, unit: 'متر'),
              ),
            ),
            Coupon(
              id: 2,
              code: 'VIP30',
              name: 'عرض كبار الشخصيات',
              type: 1,
              typeLabel: 'نسبة مئوية',
              appliesTo: const CouponAppliesTo(id: 2, name: 'باقة VIP'),
              amount: 30,
              endDate: now.add(const Duration(hours: 5)),
              salon: CouponSalon(
                id: 3,
                name: 'ركن الرجل الأنيق',
                image: '',
                distance: const Distance(value: 800, unit: 'متر'),
              ),
            ),
          ],
    );
  }

  List<Salon> get _currentRecents => switch (state) {
        SearchIdle(:final recentSalons) => recentSalons,
        _ => const [],
      };

  Future<List<Salon>> _loadRecents() async {
    final raw = await _cache.get(CacheKeys.recentSearches);
    if (raw == null) return const [];
    try {
      final list = jsonDecode(raw) as List;
      return list
          .whereType<Map<String, dynamic>>()
          .map(_salonFromMap)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _saveRecents(List<Salon> recents) async {
    final encoded =
        jsonEncode(recents.map(_salonToMap).toList());
    await _cache.set(CacheKeys.recentSearches, encoded);
  }

  Map<String, dynamic> _salonToMap(Salon s) => {
        'id': s.id,
        'name': s.name,
        'image': s.image,
        'averageRating': s.averageRating,
        'ratingsCount': s.ratingsCount,
        'distance': s.distance == null
            ? null
            : {'value': s.distance!.value, 'unit': s.distance!.unit},
        'specialization': {
          'id': s.specialization.id,
          'name': s.specialization.name,
        },
        'categories': s.categories,
        'isOpen': s.isOpen,
        'isFavorite': s.isFavorite,
        'lat': s.lat,
        'lng': s.lng,
      };

  Salon _salonFromMap(Map<String, dynamic> m) {
    final distMap = m['distance'] as Map<String, dynamic>?;
    final specMap = m['specialization'] as Map<String, dynamic>?;
    return Salon(
      id: m['id'] as int,
      name: m['name'] as String,
      image: m['image'] as String? ?? '',
      averageRating: (m['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingsCount: m['ratingsCount'] as int? ?? 0,
      distance: distMap == null
          ? null
          : Distance(
              value: distMap['value'] as num,
              unit: distMap['unit'] as String,
            ),
      specialization: Specialization(
        id: specMap?['id'] as int? ?? 0,
        name: specMap?['name'] as String? ?? '',
      ),
      categories: List<String>.from(m['categories'] as List),
      isOpen: m['isOpen'] as bool,
      isFavorite: m['isFavorite'] as bool? ?? false,
      lat: (m['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (m['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
