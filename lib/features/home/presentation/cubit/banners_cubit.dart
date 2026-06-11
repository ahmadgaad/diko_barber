import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_banners_use_case.dart';

import 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  BannersCubit(this._getBannersUseCase) : super(const BannersLoading()) {
    _load();
  }

  final GetBannersUseCase _getBannersUseCase;

  Future<void> _load() async {
    final result = await _getBannersUseCase();
    switch (result) {
      case Success(:final data):
        emit(BannersLoaded(data));
      case Failure():
        emit(const BannersError());
    }
  }
}
