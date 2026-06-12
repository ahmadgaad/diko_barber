import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/services/location_service.dart';
import 'package:ronaq_barber/core/shared/domain/entities/category.dart';
import 'package:ronaq_barber/core/shared/domain/entities/nearest_salons_params.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_categories_use_case.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_nearest_salons_use_case.dart';

import 'explore_state.dart';

class ExploreCubit extends Cubit<ExploreState> {
  ExploreCubit(
    this._getCategoriesUseCase,
    this._getNearestSalonsUseCase,
    this._locationService,
  ) : super(const ExploreLoading()) {
    _load();
  }

  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetNearestSalonsUseCase _getNearestSalonsUseCase;
  final LocationService _locationService;

  Timer? _debounce;
  List<Category> _categories = [];
  Category? _selectedCategory;
  // Holds a category selection that arrived while the initial load was in progress.
  Category? _pendingCategory;
  String _query = '';
  double? _lat;
  double? _lng;
  int _currentPage = 1;
  bool _hasMore = false;

  Future<void> _load() async {
    // Fetch location first so lat/lng are available for every subsequent request.
    final position = await _locationService.getCurrentPosition();
    if (isClosed) return;

    _lat = position?.latitude;
    _lng = position?.longitude;

    // Absorb any category selected while location was resolving.
    if (_pendingCategory != null) {
      _selectedCategory = _pendingCategory;
      _pendingCategory = null;
    }

    final (categoriesResult, salonsResult) = await (
      _getCategoriesUseCase(),
      _getNearestSalonsUseCase(
        NearestSalonsParams(
          lat: _lat,
          long: _lng,
          categoryIds: _selectedCategory != null ? [_selectedCategory!.id] : null,
          page: 1,
        ),
      ),
    ).wait;

    if (isClosed) return;

    _categories = switch (categoriesResult) {
      Success(:final data) => data,
      Failure() => [],
    };

    switch (salonsResult) {
      case Success(:final data):
        _currentPage = 1;
        _hasMore = data.hasMore;
        emit(ExploreLoaded(
          salons: data.salons,
          categories: _categories,
          selectedCategory: _selectedCategory,
          hasMore: _hasMore,
          userLat: _lat,
          userLng: _lng,
        ));
      case Failure():
        emit(const ExploreError());
    }
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (isClosed) return;
      _query = query.trim();
      _fetchSalons();
    });
  }

  void selectCategory(Category? category) {
    if (state is ExploreLoading) {
      _pendingCategory = category;
      return;
    }
    _applyCategory(category);
  }

  void _applyCategory(Category? category) {
    if (category?.id == _selectedCategory?.id) return;
    _selectedCategory = category;
    _fetchSalons();
  }

  void highlightSalon(int? id) {
    final current = state;
    if (current is! ExploreLoaded) return;
    emit(current.copyWith(highlightedSalonId: () => id));
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final current = state;
    if (current is! ExploreLoaded) return;
    if (current.isLoadingMore || current.isLoadingSalons) return;

    _currentPage++;
    await _fetchSalons(resetPage: false);
  }

  Future<void> _fetchSalons({bool resetPage = true}) async {
    if (resetPage) _currentPage = 1;

    final current = state;
    if (current is ExploreLoaded) {
      emit(current.copyWith(
        isLoadingSalons: resetPage,
        isLoadingMore: !resetPage,
        loadMoreFailed: false,
        selectedCategory: () => _selectedCategory,
        query: _query,
      ));
    }

    final result = await _getNearestSalonsUseCase(
      NearestSalonsParams(
        categoryIds: _selectedCategory != null ? [_selectedCategory!.id] : null,
        search: _query.isEmpty ? null : _query,
        lat: _lat,
        long: _lng,
        page: _currentPage,
        perPage: 15,
      ),
    );

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        _hasMore = data.hasMore;
        final current = state;
        if (current is ExploreLoaded) {
          final newSalons = resetPage
              ? data.salons
              : [...current.salons, ...data.salons];
          emit(current.copyWith(
            salons: newSalons,
            isLoadingSalons: false,
            isLoadingMore: false,
            hasMore: _hasMore,
            selectedCategory: () => _selectedCategory,
            query: _query,
          ));
        }
      case Failure():
        if (resetPage) {
          emit(const ExploreError());
        } else {
          // Roll back page so retry fetches the same page again.
          _currentPage--;
          final current = state;
          if (current is ExploreLoaded) {
            emit(current.copyWith(isLoadingMore: false, loadMoreFailed: true));
          }
        }
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
