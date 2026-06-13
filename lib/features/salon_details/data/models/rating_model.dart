import 'package:ronaq_barber/features/salon_details/domain/entities/review.dart';

class RatingModel extends Review {
  const RatingModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userAvatar,
    required super.rating,
    required super.comment,
    required super.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return RatingModel(
      id: json['id'] as int,
      userId: json['user_id'] as int? ?? 0,
      userName: user['name'] as String? ?? '',
      userAvatar: user['image'] as String? ?? '',
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
