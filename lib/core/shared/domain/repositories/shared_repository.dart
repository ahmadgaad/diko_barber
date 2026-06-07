import 'package:ronaq_barber/core/networking/api_error_model.dart';
import 'package:ronaq_barber/core/networking/result.dart';

import '../entities/city.dart';
import '../entities/neighborhood.dart';

abstract class SharedRepository {
  Future<Result<ApiErrorModel, List<City>>> getCities();
  Future<Result<ApiErrorModel, List<Neighborhood>>> getNeighborhoods({
    required int cityId,
  });
}
