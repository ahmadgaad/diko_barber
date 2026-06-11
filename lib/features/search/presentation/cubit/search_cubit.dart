import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/shared_pref_cache_client.dart';
import 'package:ronaq_barber/core/shared/domain/entities/coupon.dart';
import 'package:ronaq_barber/core/shared/domain/entities/salon.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._cache) : super(const SearchLoading()) {
    _init();
  }

  final SharedPrefCacheClient _cache;

  static const _mockSalons = [
    Salon(id: 1, name: 'صالون القص الملكي', logo: '', rating: 4.8, distance: 1.2, categories: ['شعر', 'لحية'], isOpen: true, closingTime: '10:00 م', isFavorite: true, lat: 24.7136, lng: 46.6753),
    Salon(id: 2, name: 'صالون البرستيج', logo: '', rating: 4.6, distance: 2.5, categories: ['شعر', 'بشرة'], isOpen: true, closingTime: '9:00 م', lat: 24.7200, lng: 46.6900),
    Salon(id: 3, name: 'ركن الرجل الأنيق', logo: '', rating: 4.9, distance: 0.8, categories: ['شعر', 'لحية', 'بشرة'], isOpen: false, lat: 24.7080, lng: 46.6680),
    Salon(id: 4, name: 'العناية العصرية', logo: '', rating: 4.5, distance: 3.1, categories: ['شعر'], isOpen: true, closingTime: '11:00 م', lat: 24.7300, lng: 46.7050),
    Salon(id: 5, name: 'بارز ستايل', logo: '', rating: 4.7, distance: 1.9, categories: ['شعر', 'لحية'], isOpen: true, closingTime: '10:00 م', lat: 24.7050, lng: 46.6820),
    Salon(id: 6, name: 'صالون النخبة', logo: '', rating: 4.3, distance: 4.0, categories: ['بشرة'], isOpen: false, lat: 24.7400, lng: 46.7150),
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
            Coupon(id: 1, code: 'SAVE20', discountPercent: 20, serviceLabel: 'خدمة قص الشعر', salonName: 'صالون القص الملكي', salonLogo: '', expiresAt: now.add(const Duration(days: 2))),
            Coupon(id: 2, code: 'VIP30', discountPercent: 30, serviceLabel: 'باقة كبار الشخصيات', salonName: 'ركن الرجل الأنيق', salonLogo: '', expiresAt: now.add(const Duration(hours: 5))),
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
        'logo': s.logo,
        'rating': s.rating,
        'distance': s.distance,
        'categories': s.categories,
        'isOpen': s.isOpen,
        'closingTime': s.closingTime,
        'isFavorite': s.isFavorite,
        'lat': s.lat,
        'lng': s.lng,
      };

  Salon _salonFromMap(Map<String, dynamic> m) => Salon(
        id: m['id'] as int,
        name: m['name'] as String,
        logo: m['logo'] as String,
        rating: (m['rating'] as num).toDouble(),
        distance: (m['distance'] as num).toDouble(),
        categories: List<String>.from(m['categories'] as List),
        isOpen: m['isOpen'] as bool,
        closingTime: m['closingTime'] as String?,
        isFavorite: m['isFavorite'] as bool? ?? false,
        lat: (m['lat'] as num?)?.toDouble() ?? 0.0,
        lng: (m['lng'] as num?)?.toDouble() ?? 0.0,
      );
}
