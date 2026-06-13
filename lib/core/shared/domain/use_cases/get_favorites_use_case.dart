import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';
import 'package:ronaq_barber/core/shared/domain/entities/favorite_type.dart';
import 'package:ronaq_barber/core/shared/domain/entities/favorites_tab_result.dart';
import 'package:ronaq_barber/core/shared/domain/repositories/shared_repository.dart';

class GetFavoritesUseCase {
  const GetFavoritesUseCase(this._repository);
  final SharedRepository _repository;

  Future<Result<ApiErrorModel, FavoritesTabResult>> call(FavoriteType type) =>
      _repository.getFavorites(type);
}
