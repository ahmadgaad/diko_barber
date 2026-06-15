import 'package:zain/features/book_appointment/domain/entities/appointment_service.dart';

class AppointmentServiceModel extends AppointmentService {
  const AppointmentServiceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.image,
    required super.price,
    required super.durationMinutes,
    required super.rating,
  });

  factory AppointmentServiceModel.fromJson(Map<String, dynamic> json) {
    return AppointmentServiceModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      price: json['price'] as num,
      durationMinutes: json['duration_minutes'] as int,
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
