import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Position? _cachedPosition;
  DateTime? _cacheTime;
  Completer<Position?>? _inFlight;

  static const _cacheTtl = Duration(minutes: 1);

  /// Returns the current position, requesting permission if needed.
  ///
  /// - Returns a cached result if one is available and less than 1 minute old.
  /// - If a GPS request is already in progress, joins it instead of starting a
  ///   new one — prevents duplicate hardware requests from concurrent callers
  ///   (e.g. SalonsCubit and CouponsCubit initialising at the same time).
  /// - Returns null if permission is denied or location is unavailable.
  Future<Position?> getCurrentPosition() async {
    // Return fresh cache immediately.
    if (_cachedPosition != null && _cacheTime != null) {
      if (DateTime.now().difference(_cacheTime!) < _cacheTtl) {
        return _cachedPosition;
      }
    }

    // Join an in-flight request instead of firing a second GPS call.
    if (_inFlight != null) return _inFlight!.future;

    _inFlight = Completer<Position?>();
    try {
      final permission = await _ensurePermission();
      if (permission == null) {
        _inFlight!.complete(null);
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _cachedPosition = position;
      _cacheTime = DateTime.now();
      _inFlight!.complete(position);
      return position;
    } catch (_) {
      _inFlight!.complete(null);
      return null;
    } finally {
      _inFlight = null;
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
        p.country,
        p.locality,
        p.subLocality,
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
