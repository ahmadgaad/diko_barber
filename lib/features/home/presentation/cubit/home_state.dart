import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    this.userName = '',
    this.location,
    this.isUpdatingLocation = false,
    this.locationUpdated = false,
    this.locationError,
  });

  final String userName;
  final String? location;
  final bool isUpdatingLocation;
  final bool locationUpdated;
  final String? locationError;

  HomeLoaded copyWith({
    String? userName,
    String? location,
    bool? isUpdatingLocation,
    bool? locationUpdated,
    ValueGetter<String?>? locationError,
  }) =>
      HomeLoaded(
        userName: userName ?? this.userName,
        location: location ?? this.location,
        isUpdatingLocation: isUpdatingLocation ?? this.isUpdatingLocation,
        locationUpdated: locationUpdated ?? this.locationUpdated,
        locationError:
            locationError != null ? locationError() : this.locationError,
      );

  @override
  List<Object?> get props =>
      [userName, location, isUpdatingLocation, locationUpdated, locationError];
}
