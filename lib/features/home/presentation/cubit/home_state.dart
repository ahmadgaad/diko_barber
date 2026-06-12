import 'package:equatable/equatable.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({this.userName = '', this.location});

  final String userName;
  final String? location;

  HomeLoaded copyWith({String? userName, String? location}) => HomeLoaded(
        userName: userName ?? this.userName,
        location: location ?? this.location,
      );

  @override
  List<Object?> get props => [userName, location];
}
