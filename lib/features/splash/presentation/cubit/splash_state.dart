sealed class SplashState {
  const SplashState();
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class SplashAnimating extends SplashState {
  const SplashAnimating();
}

final class SplashComplete extends SplashState {
  const SplashComplete({
    required this.navigationTarget,
    this.imagesToPrecache = const [],
  });

  final String navigationTarget;
  final List<String> imagesToPrecache;
}
