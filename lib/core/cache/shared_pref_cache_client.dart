import 'package:shared_preferences/shared_preferences.dart';

import 'cache_client.dart';

class SharedPrefCacheClient implements CacheClient {
  SharedPrefCacheClient(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<String?> get(String key) async => _prefs.getString(key);

  @override
  Future<void> set(String key, String value) async =>
      _prefs.setString(key, value);

  @override
  Future<void> remove(String key) async => _prefs.remove(key);

  @override
  Future<void> clear() async => _prefs.clear();

  @override
  Future<bool> containsKey(String key) async => _prefs.containsKey(key);
}
