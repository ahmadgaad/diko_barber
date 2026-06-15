import 'dart:async';

import 'package:zain/core/networking/api_error_model.dart';
import 'package:zain/core/networking/result.dart';
import 'package:zain/core/shared/domain/entities/favorite_type.dart';
import 'package:zain/core/shared/domain/repositories/shared_repository.dart';

class FavoriteToggleEvent {
  const FavoriteToggleEvent({
    required this.id,
    required this.type,
    required this.isFavorite,
  });
  final int id;
  final FavoriteType type;
  /// true = item was just added to favorites; false = removed
  final bool isFavorite;
}

class ToggleFavoriteUseCase {
  ToggleFavoriteUseCase(this._repository);

  final SharedRepository _repository;
  final _controller = StreamController<FavoriteToggleEvent>.broadcast(sync: true);

  Stream<FavoriteToggleEvent> get events => _controller.stream;

  Future<Result<ApiErrorModel, void>> call({
    required int id,
    required FavoriteType type,
    required bool isFavorite,
  }) async {
    final result = await _repository.toggleFavorite(id: id, type: type);
    if (result.isSuccess) {
      _controller.add(
        FavoriteToggleEvent(id: id, type: type, isFavorite: isFavorite),
      );
    }
    return result;
  }
}
