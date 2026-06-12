class Distance {
  const Distance({required this.value, required this.unit});

  final num value;
  final String unit;

  String get formatted => '$value $unit';
}
