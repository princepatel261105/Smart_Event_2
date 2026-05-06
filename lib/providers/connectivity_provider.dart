import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isConnected = true;
  final Connectivity _connectivity = Connectivity();

  bool get isConnected => _isConnected;

  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isConnected = result != ConnectivityResult.none;

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      final wasConnected = _isConnected;
      _isConnected = result != ConnectivityResult.none;

      if (wasConnected != _isConnected) {
        notifyListeners();
      }
    });
  }

  String get statusText => _isConnected ? 'Online' : 'Offline';
  String get statusIcon => _isConnected ? '🟢' : '🔴';
}
