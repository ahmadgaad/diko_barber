import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Returns the current position, requesting permission if needed.
  /// Returns null if permission is denied or location is unavailable.
  Future<Position?> getCurrentPosition() async {
    final permission = await _ensurePermission();
    if (permission == null) return null;

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// Returns a human-readable address for the given coordinates.
  /// Returns null if reverse geocoding fails so callers can apply their own fallback.
  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    try {
      await setLocaleIdentifier("ar_EG");
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final parts = [
        p.subLocality,
        p.locality,
        p.administrativeArea,
      ].where((s) => s != null && s.isNotEmpty).toSet().toList();
      return parts.isEmpty ? null : parts.join('، ');
    } catch (e) {
      assert(() {
        // ignore: avoid_print
        print('[LocationService] reverse geocoding failed: $e');
        return true;
      }());
      return null;
    }
  }

  /// Returns the permission status after requesting if not yet determined.
  /// Returns null if permission is denied or permanently denied.
  Future<LocationPermission?> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }
    return permission;
  }
}
