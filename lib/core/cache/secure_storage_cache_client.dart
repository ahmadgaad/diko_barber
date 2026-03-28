import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'cache_client.dart';

class SecureStorageCacheClient implements CacheClient {
  SecureStorageCacheClient(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<String?> get(String key) => _storage.read(key: key);

  @override
  Future<void> set(String key, String value) => _storage.write(key: key, value: value);

  @override
  Future<void> remove(String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();

  @override
  Future<bool> containsKey(String key) => _storage.containsKey(key: key);
}
