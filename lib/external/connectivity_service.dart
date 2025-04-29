import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();

    return results.any((result) => result != ConnectivityResult.none);
  }
}
