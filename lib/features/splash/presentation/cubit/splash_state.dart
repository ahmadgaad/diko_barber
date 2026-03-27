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
  const SplashComplete({required this.navigationTarget});

  final String navigationTarget;
}
