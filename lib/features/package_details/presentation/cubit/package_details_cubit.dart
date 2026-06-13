import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/shared/domain/entities/favorite_type.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_package_details_use_case.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/toggle_favorite_use_case.dart';
import 'package:ronaq_barber/features/package_details/presentation/cubit/package_details_state.dart';

class PackageDetailsCubit extends Cubit<PackageDetailsState> {
  PackageDetailsCubit(this._getPackageDetails, this._toggleFavoriteUseCase)
      : super(const PackageDetailsLoading());

  final GetPackageDetailsUseCase _getPackageDetails;
  final ToggleFavoriteUseCase _toggleFavoriteUseCase;

  Future<void> load(int id) async {
    emit(const PackageDetailsLoading());
    final result = await _getPackageDetails(id);
    if (isClosed) return;
    result.when(
      failure: (e) => emit(PackageDetailsError(message: e.message)),
      success: (pkg) => emit(PackageDetailsLoaded(package: pkg)),
    );
  }

  Future<void> toggleFavorite() async {
    final current = state;
    if (current is! PackageDetailsLoaded) return;

    final newIsFavorite = !current.package.isFavorite;
    emit(current.copyWith(
      package: current.package.copyWith(isFavorite: newIsFavorite),
    ));

    final result = await _toggleFavoriteUseCase(
      id: current.package.id,
      type: FavoriteType.package,
      isFavorite: newIsFavorite,
    );
    if (result.isFailure) {
      emit(current);
    }
  }
}
