import 'package:ronaq_barber/features/auth/domain/entities/user.dart';

class GenderModel extends Gender {
  const GenderModel({required super.id, required super.name});

  factory GenderModel.fromJson(Map<String, dynamic> json) =>
      GenderModel(id: json['id'] as int, name: json['name'] as String);
}

class CityModel extends City {
  const CityModel({required super.id, required super.name});

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      CityModel(id: json['id'] as int, name: json['name'] as String);
}

class NeighborhoodModel extends Neighborhood {
  const NeighborhoodModel({required super.id, required super.name});

  factory NeighborhoodModel.fromJson(Map<String, dynamic> json) =>
      NeighborhoodModel(id: json['id'] as int, name: json['name'] as String);
}

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.age,
    super.gender,
    super.city,
    super.neighborhood,
    required super.email,
    required super.phone,
    super.lat,
    super.long,
    super.location,
    super.image,
    required super.isActive,
    required super.isNotify,
    required super.averageRating,
    required super.ratingsCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int,
    name: json['name'] as String,
    age: json['age'] as int? ?? 0,
    gender: json['gender'] is Map<String, dynamic>
        ? GenderModel.fromJson(json['gender'])
        : null,
    city: json['city'] is Map<String, dynamic>
        ? CityModel.fromJson(json['city'])
        : null,
    neighborhood: json['neighborhood'] is Map<String, dynamic>
        ? NeighborhoodModel.fromJson(json['neighborhood'])
        : null,
    email: json['email'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    lat: json['lat'] as String?,
    long: json['long'] as String?,
    location: json['location'] as String?,
    image: json['image'] as String?,
    isActive: (json['is_active'] as int? ?? 0) == 1,
    isNotify: (json['is_notify'] as int? ?? 0) == 1,
    averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
    ratingsCount: json['ratings_count'] as int? ?? 0,
  );
}
