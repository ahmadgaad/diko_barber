import '../locale_repository.dart';

class SaveLocaleUseCase {
  const SaveLocaleUseCase(this._repository);

  final LocaleRepository _repository;

  Future<void> call(String languageCode) => _repository.saveLocale(languageCode);
}
