import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  InternetConnectionChecker internetConnectionChecker;
  Connectivity connectivity;

  NetworkInfoImpl({
    required this.connectivity,
    required this.internetConnectionChecker,
  });

  @override
  Future<bool> get isConnected async =>
      await connectivity.checkConnectivity() != ConnectivityResult.wifi ||
              await connectivity.checkConnectivity() !=
                  ConnectivityResult.mobile
          ? false
          : await internetConnectionChecker.hasConnection;
}
