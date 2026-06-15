import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/shared/domain/entities/category.dart';
import 'package:zain/core/shared/domain/repositories/shared_repository.dart';

class GetCategoriesUseCase {
  const GetCategoriesUseCase(this._repository);

  final SharedRepository _repository;

  Future<Result<ApiErrorModel, List<Category>>> call({
    int? specialization,
  }) =>
      _repository.getCategories(specialization: specialization);
}
