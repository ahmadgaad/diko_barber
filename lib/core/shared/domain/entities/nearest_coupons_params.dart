class NearestCouponsParams {
  const NearestCouponsParams({
    this.lat,
    this.long,
    this.page = 1,
    this.perPage = 15,
  });

  final double? lat;
  final double? long;
  final int page;
  final int perPage;
}
