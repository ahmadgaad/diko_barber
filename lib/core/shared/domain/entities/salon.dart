class Salon {
  const Salon({
    required this.id,
    required this.name,
    required this.logo,
    required this.rating,
    required this.distance,
    required this.categories,
    required this.isOpen,
    required this.lat,
    required this.lng,
    this.closingTime,
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String logo;
  final double rating;
  final double distance;
  final List<String> categories;
  final bool isOpen;
  final double lat;
  final double lng;
  final String? closingTime;
  final bool isFavorite;
}
