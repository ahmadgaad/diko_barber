import 'package:zain/features/book_appointment/domain/entities/time_slot.dart';

class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.id,
    required super.time,
    required super.isAvailable,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] as int,
      time: json['time'] as String,
      isAvailable: json['is_available'] as bool,
    );
  }
}
