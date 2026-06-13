import 'package:equatable/equatable.dart';

class SalonStaff extends Equatable {
  const SalonStaff({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.ratingsCount,
  });

  final int id;
  final String name;
  final String image;
  final double rating;
  final int ratingsCount;

  @override
  List<Object?> get props => [id, name, image, rating, ratingsCount];
}
