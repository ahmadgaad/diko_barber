import '../locale_repository.dart';

class GetLocaleUseCase {
  const GetLocaleUseCase(this._repository);

  final LocaleRepository _repository;

  Future<String?> call() => _repository.getLocale();
}
