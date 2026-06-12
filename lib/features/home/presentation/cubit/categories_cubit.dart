import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_categories_use_case.dart';

import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._getCategoriesUseCase) : super(const CategoriesLoading()) {
    _load();
  }

  final GetCategoriesUseCase _getCategoriesUseCase;

  Future<void> _load() async {
    final result = await _getCategoriesUseCase();
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(CategoriesLoaded(data));
      case Failure():
        emit(const CategoriesError());
    }
  }

  Future<void> refresh() async {
    emit(const CategoriesLoading());
    await _load();
  }
}
