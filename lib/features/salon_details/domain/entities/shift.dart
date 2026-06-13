import 'package:equatable/equatable.dart';

class Shift extends Equatable {
  const Shift({
    required this.id,
    required this.dayWeek,
    required this.dayName,
    required this.from,
    required this.to,
    required this.isActive,
  });

  final int id;
  final int dayWeek;
  final String dayName;
  final String from;
  final String to;
  final bool isActive;

  @override
  List<Object?> get props => [id, dayWeek, dayName, from, to, isActive];
}
