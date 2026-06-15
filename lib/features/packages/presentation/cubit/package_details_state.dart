import 'package:zain/features/packages/domain/entities/package_details.dart';

sealed class PackageDetailsState {
  const PackageDetailsState();
}

class PackageDetailsLoading extends PackageDetailsState {
  const PackageDetailsLoading();
}

class PackageDetailsLoaded extends PackageDetailsState {
  const PackageDetailsLoaded({required this.package});
  final PackageDetails package;

  PackageDetailsLoaded copyWith({PackageDetails? package}) =>
      PackageDetailsLoaded(package: package ?? this.package);
}

class PackageDetailsError extends PackageDetailsState {
  const PackageDetailsError({required this.message});
  final String message;
}
