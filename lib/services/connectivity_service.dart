import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._();

  static final instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();

  Stream<List<ConnectivityResult>> get onChanged =>
      _connectivity.onConnectivityChanged;

  Future<bool> isOnline() async {
    final states = await _connectivity.checkConnectivity();
    return !states.contains(ConnectivityResult.none);
  }
}
