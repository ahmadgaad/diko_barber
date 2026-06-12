class NearestSalonsParams {
  const NearestSalonsParams({
    this.categoryIds,
    this.sortBy,
    this.search,
    this.isHome = false,
    this.lat,
    this.long,
    this.page = 1,
    this.perPage = 15,
  });

  final List<int>? categoryIds;
  final List<String>? sortBy;
  final String? search;
  final bool isHome;
  final double? lat;
  final double? long;
  final int page;

  /// Items per page (default 15, max 50). Ignored by backend when is_home=1 (forced to 10).
  final int perPage;
}
