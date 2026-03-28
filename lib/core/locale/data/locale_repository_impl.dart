import 'package:diko_barber/core/cache/cache_keys.dart';
import 'package:diko_barber/core/cache/shared_pref_cache_client.dart';
import '../domain/locale_repository.dart';

class LocaleRepositoryImpl implements LocaleRepository {
  const LocaleRepositoryImpl(this._cacheClient);

  final SharedPrefCacheClient _cacheClient;

  @override
  Future<String?> getLocale() => _cacheClient.get(CacheKeys.locale);

  @override
  Future<void> saveLocale(String languageCode) =>
      _cacheClient.set(CacheKeys.locale, languageCode);
}
