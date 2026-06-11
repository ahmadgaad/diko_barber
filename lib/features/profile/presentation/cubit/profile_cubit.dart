import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ronaq_barber/features/profile/presentation/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileLoading()) {
    _load();
  }

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
    emit(current.copyWith(
        notificationsEnabled: !current.notificationsEnabled));
  }
}
