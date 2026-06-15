import 'package:zain/core/shared/domain/entities/city.dart';
import 'package:zain/core/shared/domain/entities/neighborhood.dart';

export 'package:zain/core/shared/domain/entities/city.dart';
export 'package:zain/core/shared/domain/entities/neighborhood.dart';

class Gender {
  final int id;
  final String name;
  const Gender({required this.id, required this.name});
}

class User {
  final int id;
  final String name;
  final int age;
  final Gender? gender;
  final City? city;
  final Neighborhood? neighborhood;
  final String email;
  final String phone;
  final String? lat;
  final String? long;
  final String? location;
  final String? image;
  final bool isActive;
  final bool isNotify;
  final double averageRating;
  final int ratingsCount;

  const User({
    required this.id,
    required this.name,
    required this.age,
    this.gender,
    this.city,
    this.neighborhood,
    required this.email,
    required this.phone,
    this.lat,
    this.long,
    this.location,
    this.image,
    required this.isActive,
    required this.isNotify,
    required this.averageRating,
    required this.ratingsCount,
  });
}
