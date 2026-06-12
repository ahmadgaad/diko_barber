import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Interface for checking network connectivity status.
abstract class INetworkInfo {
  /// Returns `true` if the device is connected to the internet.
  Future<bool> get isConnected;
}

/// Implementation of [INetworkInfo] using internet_connection_checker_plus.
class NetworkInfo implements INetworkInfo {
  final InternetConnection internetConnection;

  NetworkInfo(this.internetConnection);

  @override
  Future<bool> get isConnected => internetConnection.hasInternetAccess;
}
