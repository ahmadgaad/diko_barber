import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  final int id;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        userName,
        userAvatar,
        rating,
        comment,
        createdAt,
      ];
}
