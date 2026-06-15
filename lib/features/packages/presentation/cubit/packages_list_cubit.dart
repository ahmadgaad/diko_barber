import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/services/location_service.dart';
import 'package:zain/core/shared/domain/entities/category.dart';
import 'package:zain/core/shared/domain/entities/favorite_type.dart';
import 'package:zain/core/shared/domain/entities/nearest_package.dart';
import 'package:zain/core/shared/domain/entities/nearest_packages_params.dart';
import 'package:zain/core/shared/domain/use_cases/get_categories_use_case.dart';
import 'package:zain/core/shared/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:zain/features/packages/domain/use_cases/get_packages_use_case.dart';
import 'package:zain/features/packages/presentation/cubit/packages_list_state.dart';

class PackagesListCubit extends Cubit<PackagesListState> {
  PackagesListCubit(
    this._useCase,
    this._locationService,
    this._getCategoriesUseCase,
    this._toggleFavoriteUseCase,
  ) : super(const PackagesListLoading()) {
    _init();
    _eventSub = _toggleFavoriteUseCase.events.listen(_onFavoriteEvent);
  }

  final GetPackagesUseCase _useCase;
  final LocationService _locationService;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  late final StreamSubscription<FavoriteToggleEvent> _eventSub;
  final _pendingToggles = <int>{};

  double? _lat;
  double? _lng;
  int _currentPage = 1;
  bool _hasMore = false;

  String _search = '';
  List<int> _categoryIds = [];
  List<String> _sortBy = [];

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  Timer? _debounce;

  Future<void> _init() async {
    try {
      final results = await Future.wait([
        _locationService.getCurrentPosition(),
        _getCategoriesUseCase(),
      ]);
      if (isClosed) return;

      final position = results[0] as dynamic;
      _lat = position?.latitude as double?;
      _lng = position?.longitude as double?;

      final catResult = results[1] as Result;
      if (catResult is Success) {
        _categories = (catResult as Success<dynamic, List<Category>>).data;
      }

      await _fetch(resetPage: true);
    } catch (e, st) {
      log('PackagesListCubit._init failed', error: e, stackTrace: st);
      if (!isClosed) emit(const PackagesListError());
    }
  }

  Future<void> refresh() async {
    emit(const PackagesListLoading());
    _search = '';
    _categoryIds = [];
    _sortBy = [];
    await _init();
  }

  void updateSearch(String value) {
    _search = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _fetch(resetPage: true);
    });
  }

  void applyFilters({
    required List<int> categoryIds,
    required List<String> sortBy,
  }) {
    _categoryIds = categoryIds;
    _sortBy = sortBy;
    _fetch(resetPage: true);
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    final current = state;
    if (current is! PackagesListLoaded) return;
    if (current.isLoadingMore) return;
    _currentPage++;
    await _fetch(resetPage: false);
  }

  Future<void> _fetch({required bool resetPage}) async {
    if (resetPage) {
      _currentPage = 1;
      emit(const PackagesListLoading());
    } else {
      final current = state;
      if (current is PackagesListLoaded) {
        emit(current.copyWith(isLoadingMore: true, loadMoreFailed: false));
      }
    }

    final result = await _useCase(
      NearestPackagesParams(
        lat: _lat,
        long: _lng,
        page: _currentPage,
        perPage: 20,
        isHome: false,
        search: _search.isEmpty ? null : _search,
        categoryIds: _categoryIds,
        sortBy: _sortBy,
      ),
    );

    if (isClosed) return;

    switch (result) {
      case Success(:final data):
        _hasMore = data.hasMore;
        final prev = state;
        final merged = resetPage
            ? data.packages
            : <NearestPackage>[
                ...(prev is PackagesListLoaded ? prev.packages : []),
                ...data.packages,
              ];
        emit(PackagesListLoaded(
          packages: merged,
          hasMore: _hasMore,
          isLoadingMore: false,
          search: _search,
          categoryIds: _categoryIds,
          sortBy: _sortBy,
        ));
      case Failure():
        if (resetPage) {
          emit(const PackagesListError());
        } else {
          _currentPage--;
          final prev = state;
          if (prev is PackagesListLoaded) {
            emit(prev.copyWith(isLoadingMore: false, loadMoreFailed: true));
          }
        }
    }
  }

  Future<void> toggleFavorite(int packageId) async {
    final current = state;
    if (current is! PackagesListLoaded) return;

    final pkg = current.packages.firstWhere((p) => p.id == packageId);
    final newIsFavorite = !pkg.isFavorite;
    _pendingToggles.add(packageId);
    emit(current.copyWith(
      packages: _applyFavorite(current.packages, packageId, newIsFavorite),
    ));

    final result = await _toggleFavoriteUseCase(
      id: packageId,
      type: FavoriteType.package,
      isFavorite: newIsFavorite,
    );
    _pendingToggles.remove(packageId);

    if (result.isFailure && !isClosed) {
      emit(current);
    }
  }

  void _onFavoriteEvent(FavoriteToggleEvent event) {
    if (event.type != FavoriteType.package) return;
    if (_pendingToggles.contains(event.id)) return;
    final current = state;
    if (current is! PackagesListLoaded) return;
    emit(current.copyWith(
      packages: _applyFavorite(current.packages, event.id, event.isFavorite),
    ));
  }

  List<NearestPackage> _applyFavorite(
    List<NearestPackage> packages,
    int id,
    bool isFavorite,
  ) =>
      packages
          .map((p) => p.id == id ? p.copyWith(isFavorite: isFavorite) : p)
          .toList();

  @override
  Future<void> close() {
    _debounce?.cancel();
    _eventSub.cancel();
    return super.close();
  }
}
