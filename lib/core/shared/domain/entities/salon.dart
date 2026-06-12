class Salon {
  const Salon({
    required this.id,
    required this.name,
    required this.image,
    required this.averageRating,
    required this.ratingsCount,
    required this.categories,
    required this.isOpen,
    required this.isFavorite,
    required this.lat,
    required this.lng,
    this.location,
    this.distance,
  });

  final int id;
  final String name;
  final String image;
  final double averageRating;
  final int ratingsCount;
  final List<String> categories;
  final bool isOpen;
  final bool isFavorite;
  final double lat;
  final double lng;
  final String? location;

  /// Computed client-side or passed in — not returned by the API.
  final double? distance;

  Salon copyWith({double? distance}) {
    return Salon(
      id: id,
      name: name,
      image: image,
      averageRating: averageRating,
      ratingsCount: ratingsCount,
      categories: categories,
      isOpen: isOpen,
      isFavorite: isFavorite,
      lat: lat,
      lng: lng,
      location: location,
      distance: distance ?? this.distance,
    );
  }
}
