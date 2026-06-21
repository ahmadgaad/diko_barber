import 'package:easy_localization/easy_localization.dart';

/// Formats a 24-hour `HH:mm` time string into a localized 12-hour string with a
/// translated period, e.g. `14:30` → `2:30 PM` (en) / `2:30 م` (ar).
///
/// Returns the original string unchanged if it cannot be parsed.
String formatTimeOfDay(String time) {
  try {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = tr(hour >= 12 ? 'time.pm' : 'time.am');
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  } catch (_) {
    return time;
  }
}
