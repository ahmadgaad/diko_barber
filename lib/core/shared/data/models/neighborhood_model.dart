import 'package:ronaq_barber/core/shared/domain/entities/neighborhood.dart';

class NeighborhoodModel extends Neighborhood {
  const NeighborhoodModel({required super.id, required super.name});

  factory NeighborhoodModel.fromJson(Map<String, dynamic> json) =>
      NeighborhoodModel(id: json['id'] as int, name: json['name'] as String);
}
