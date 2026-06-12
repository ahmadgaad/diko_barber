class NearestSalonsParams {
  const NearestSalonsParams({
    this.categoryIds,
    this.sortBy,
    this.search,
    this.isHome = false,
    this.lat,
    this.long,
  });

  final List<int>? categoryIds;
  final List<String>? sortBy;
  final String? search;
  final bool isHome;
  final double? lat;
  final double? long;
}
