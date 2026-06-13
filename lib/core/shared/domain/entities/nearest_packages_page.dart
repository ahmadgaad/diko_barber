import 'package:ronaq_barber/core/shared/domain/entities/nearest_package.dart';

class NearestPackagesPage {
  const NearestPackagesPage({required this.packages, required this.hasMore});

  final List<NearestPackage> packages;
  final bool hasMore;
}
