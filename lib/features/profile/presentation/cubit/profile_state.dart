sealed class ProfileState {
  const ProfileState();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.loyaltyPoints,
    required this.walletBalance,
    required this.notificationsEnabled,
  });

  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final int loyaltyPoints;
  final double walletBalance;
  final bool notificationsEnabled;

  ProfileLoaded copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    int? loyaltyPoints,
    double? walletBalance,
    bool? notificationsEnabled,
  }) {
    return ProfileLoaded(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      walletBalance: walletBalance ?? this.walletBalance,
      notificationsEnabled:
          notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class ProfileError extends ProfileState {
  const ProfileError();
}
