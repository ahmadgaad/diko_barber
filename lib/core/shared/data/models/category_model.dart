import 'package:ronaq_barber/core/shared/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({required super.id, required super.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      CategoryModel(id: json['id'] as int, name: json['name'] as String);
}
