class SalonService {
  const SalonService({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.durationMinutes,
    required this.rating,
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String description;
  final String image;
  final double price;
  final int durationMinutes;
  final double rating;
  final bool isFavorite;
}
