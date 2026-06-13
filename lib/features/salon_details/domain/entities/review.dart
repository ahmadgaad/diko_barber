import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  final int id;
  final int userId;
  final String userName;
  final String userAvatar;
  final int rating;
  final String comment;
  final String createdAt;

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        rating,
        comment,
        createdAt,
      ];
}
