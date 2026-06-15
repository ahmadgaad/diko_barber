import 'package:zain/core/shared/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.image,
    required super.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
    type: CategoryType(
      id: (json['type'] as Map<String, dynamic>)['id'] as int,
      name: (json['type'] as Map<String, dynamic>)['name'] as String,
    ),
  );
}
