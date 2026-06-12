class AppointmentService {
  const AppointmentService({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.durationMinutes,
    required this.rating,
  });

  final int id;
  final String name;
  final String description;
  final String image;
  final num price;
  final int durationMinutes;
  final double rating;
}
