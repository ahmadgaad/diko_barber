import 'package:zain/core/cache/cache_keys.dart';
import 'package:zain/core/cache/secure_storage_cache_client.dart';

class UserSession {
  const UserSession(this._secureStorage);

  final SecureStorageCacheClient _secureStorage;

  Future<bool> get isAuthenticated async {
    final token = await _secureStorage.get(CacheKeys.userAccessToken);
    return token != null && token.isNotEmpty;
  }

  Future<void> continueAsGuest() =>
      _secureStorage.set(CacheKeys.guestMode, 'true');

  Future<void> clearGuestMode() =>
      _secureStorage.remove(CacheKeys.guestMode);

  Future<bool> get isGuestMode async {
    final isAuth = await isAuthenticated;
    if (isAuth) return false;
    final guest = await _secureStorage.get(CacheKeys.guestMode);
    return guest == 'true';
  }
}
