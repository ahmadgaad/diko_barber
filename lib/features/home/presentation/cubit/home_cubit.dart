import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/core/cache/cache_keys.dart';
import 'package:ronaq_barber/core/cache/secure_storage_cache_client.dart';

import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._secureStorage) : super(const HomeLoaded()) {
    _loadUserName();
  }

  final SecureStorageCacheClient _secureStorage;

  Future<void> _loadUserName() async {
    final name = await _secureStorage.get(CacheKeys.userName);
    emit(HomeLoaded(userName: name ?? ''));
  }
}
