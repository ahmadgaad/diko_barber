import 'package:equatable/equatable.dart';

import 'salon_service.dart';

class Package extends Equatable {
  const Package({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    this.services = const [],
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  final double rating;
  final List<SalonService> services;
  final bool isFavorite;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        image,
        price,
        rating,
        services,
        isFavorite,
      ];
}
