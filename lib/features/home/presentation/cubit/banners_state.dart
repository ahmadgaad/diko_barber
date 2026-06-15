import 'package:zain/core/shared/domain/entities/banner.dart';

sealed class BannersState {
  const BannersState();
}

class BannersLoading extends BannersState {
  const BannersLoading();
}

class BannersLoaded extends BannersState {
  const BannersLoaded(this.banners);
  final List<Banner> banners;
}

class BannersError extends BannersState {
  const BannersError();
}
