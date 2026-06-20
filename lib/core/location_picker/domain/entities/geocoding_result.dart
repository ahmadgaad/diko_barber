class GeocodingResult {
  const GeocodingResult({
    required this.formattedAddress,
    required this.lat,
    required this.lng,
    this.placeId,
  });

  final String formattedAddress;
  final double lat;
  final double lng;
  final String? placeId;
}
