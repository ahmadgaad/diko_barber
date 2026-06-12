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

  Future<void> _load() async {
    // Fetch location first so lat/lng are available for every subsequent request.
    // Location failure is non-fatal — API falls back to the user's profile location.
    final position = await _locationService.getCurrentPosition();
    if (isClosed) return;

    _lat = position?.latitude;
    _lng = position?.longitude;

    // Absorb any category selected while location was resolving so the initial
    // salons request already carries the correct filter — one request instead of two.
    if (_pendingCategory != null) {
      _selectedCategory = _pendingCategory;
      _pendingCategory = null;
    }

    // Load categories and salons in parallel with correct coordinates and filter.
    final (categoriesResult, salonsResult) = await (
      _getCategoriesUseCase(),
      _getNearestSalonsUseCase(
        NearestSalonsParams(
          lat: _lat,
          long: _lng,
          categoryIds: _selectedCategory != null ? [_selectedCategory!.id] : null,
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
        emit(ExploreLoaded(
          salons: data,
          categories: _categories,
          selectedCategory: _selectedCategory,
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
    // If still on the initial load, store the selection and apply it once ready.
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

  Future<void> _fetchSalons() async {
    final current = state;
    if (current is ExploreLoaded) {
      emit(current.copyWith(
        isLoadingSalons: true,
        selectedCategory: () => _selectedCategory,
        query: _query,
      ));
    }

    final result = await _getNearestSalonsUseCase(
      NearestSalonsParams(
        categoryIds:
            _selectedCategory != null ? [_selectedCategory!.id] : null,
        search: _query.isEmpty ? null : _query,
        lat: _lat,
        long: _lng,
      ),
    );

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        final current = state;
        if (current is ExploreLoaded) {
          emit(current.copyWith(
            salons: data,
            isLoadingSalons: false,
            selectedCategory: () => _selectedCategory,
            query: _query,
          ));
        }
      case Failure():
        emit(const ExploreError());
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
