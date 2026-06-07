class SignUpParams {
  const SignUpParams({
    required this.name,
    this.phone,
    this.email,
    required this.password,
    required this.passwordConfirmation,
    this.cityId,
    this.neighborhoodId,
    this.gender,
    this.age,
    this.fcmToken,
    this.imagePath,
  });

  final String name;
  final String? phone;
  final String? email;
  final String password;
  final String passwordConfirmation;
  final int? cityId;
  final int? neighborhoodId;
  final int? gender;
  final int? age;
  final String? fcmToken;
  final String? imagePath;
}
