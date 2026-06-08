class SalonRegisterParams {
  const SalonRegisterParams({
    required this.ownerName,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.specialization,
    required this.categoryIds,
    required this.cityId,
    this.neighborhoodId,
    this.description,
    this.location,
    this.commercialRegistrationNumber,
    this.logoPath,
    this.commercialRegistrationImagePath,
  });

  final String ownerName;
  final String name;
  final String phone;
  final String email;
  final String password;
  final String passwordConfirmation;
  final int specialization;
  final List<int> categoryIds;
  final int cityId;
  final int? neighborhoodId;
  final String? description;
  final String? location;
  final String? commercialRegistrationNumber;
  final String? logoPath;
  final String? commercialRegistrationImagePath;
}
