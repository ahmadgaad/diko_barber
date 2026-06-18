import '../../domain/entities/available_slot.dart';

class AvailableSlotModel extends AvailableSlot {
  const AvailableSlotModel({
    required super.startTime,
    required super.endTime,
    super.staffId,
  });

  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotModel(
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      staffId: json['staff_id'] as int?,
    );
  }
}
