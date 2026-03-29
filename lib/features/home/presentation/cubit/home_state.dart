import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({this.userName = 'Ahmed'});

  final String userName;

  @override
  List<Object?> get props => [userName];
}
