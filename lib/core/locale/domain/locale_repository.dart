abstract class LocaleRepository {
  Future<String?> getLocale();
  Future<void> saveLocale(String languageCode);
}
