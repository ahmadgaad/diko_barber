abstract class CacheClient {
  Future<String?> get(String key);
  Future<void> set(String key, String value);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}
