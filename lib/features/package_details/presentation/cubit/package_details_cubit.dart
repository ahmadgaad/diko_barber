import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/shared/domain/use_cases/get_package_details_use_case.dart';
import 'package:ronaq_barber/features/package_details/presentation/cubit/package_details_state.dart';

class PackageDetailsCubit extends Cubit<PackageDetailsState> {
  PackageDetailsCubit(this._getPackageDetails)
      : super(const PackageDetailsLoading());

  final GetPackageDetailsUseCase _getPackageDetails;

  Future<void> load(int id) async {
    emit(const PackageDetailsLoading());
    final result = await _getPackageDetails(id);
    if (isClosed) return;
    result.when(
      failure: (e) => emit(PackageDetailsError(message: e.message)),
      success: (pkg) => emit(PackageDetailsLoaded(package: pkg)),
    );
  }
}
