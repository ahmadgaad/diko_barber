import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/shared/domain/entities/banner.dart';
import 'package:zain/core/shared/domain/repositories/shared_repository.dart';

class GetBannersUseCase {
  const GetBannersUseCase(this._repository);

  final SharedRepository _repository;

  Future<Result<ApiErrorModel, List<Banner>>> call() =>
      _repository.getBanners();
}
