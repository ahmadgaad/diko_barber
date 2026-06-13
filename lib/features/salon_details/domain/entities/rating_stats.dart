import 'package:equatable/equatable.dart';

class RatingStats extends Equatable {
  const RatingStats({
    required this.one,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
  });

  final int one;
  final int two;
  final int three;
  final int four;
  final int five;

  int get total => one + two + three + four + five;

  @override
  List<Object?> get props => [one, two, three, four, five];
}
