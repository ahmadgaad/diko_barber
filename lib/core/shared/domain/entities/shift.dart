class Shift {
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
}
