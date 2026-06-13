class NearestPackagesParams {
  const NearestPackagesParams({
    this.lat,
    this.long,
    this.page = 1,
    this.perPage = 15,
    this.isHome = false,
    this.search,
    this.categoryIds = const [],
    this.sortBy = const [],
  });

  final double? lat;
  final double? long;
  final int page;
  final int perPage;
  final bool isHome;
  final String? search;
  final List<int> categoryIds;
  final List<String> sortBy;
}
