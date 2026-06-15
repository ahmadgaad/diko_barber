import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zain/core/cache/cache_keys.dart';
import 'package:zain/core/cache/secure_storage_cache_client.dart';
import 'package:zain/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:zain/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required LogoutUseCase logoutUseCase,
    required SecureStorageCacheClient secureStorage,
  })  : _logoutUseCase = logoutUseCase,
        _secureStorage = secureStorage,
        super(const ProfileLoading()) {
    _load();
  }

  final LogoutUseCase _logoutUseCase;
  final SecureStorageCacheClient _secureStorage;

  void _load() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (isClosed) return;
      emit(const ProfileLoaded(
        name: 'أحمد محمد',
        email: 'ahmed@example.com',
        phone: '01012345678',
        avatarUrl: 'https://picsum.photos/seed/user_profile/200/200',
        loyaltyPoints: 1240,
        walletBalance: 350.0,
        notificationsEnabled: true,
      ));
    });
  }

  void toggleNotifications() {
    final current = state;
    if (current is! ProfileLoaded) return;
    emit(current.copyWith(notificationsEnabled: !current.notificationsEnabled));
  }

  Future<void> logout() async {
    // Fire the API call — result is intentionally ignored so the user is
    // always logged out locally even if the server is unreachable.
    await _logoutUseCase();
    await _secureStorage.remove(CacheKeys.userAccessToken);
    await _secureStorage.remove(CacheKeys.userIsVerified);
    await _secureStorage.remove(CacheKeys.userName);
    if (isClosed) return;
    emit(const ProfileLoggedOut());
  }
}
