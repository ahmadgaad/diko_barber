class FeaturedService {
  const FeaturedService({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.rating,
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String image;
  final double price;
  final double rating;
  final bool isFavorite;
}
