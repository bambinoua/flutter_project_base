import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

enum InternetConnectivityState {
  /// None: Device not connected to any network
  none,

  /// WiFi: Device connected via Wi-Fi
  wifi,

  /// Mobile: Device connected to cellular network
  mobile,

  /// Ethernet: Device connected to ethernet network
  ethernet,
}

/// Discover network connectivity configurations.
///
/// Distinguish between WI-FI, cellular and Ethernet.
class InternetConnectivity extends ChangeNotifier {
  InternetConnectivity._() {
    _connectivity.onConnectivityChanged.listen(_connectivityListener);
    if (Platform.isIOS) {
      () async {
        _connectivityListener(await _connectivity.checkConnectivity());
      }();
    }
  }

  /// Creates a singleton of [InternetConnectivity].
  factory InternetConnectivity() => _this;
  static final _this = InternetConnectivity._();

  final _connectivity = Connectivity();

  ConnectivityResult _oldConnectivityResult = ConnectivityResult.none;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  /// Returns `true` if there is a connectivitiy is available.
  bool get isConnected => _connectivityResult != ConnectivityResult.none;

  /// Returns `true` if there is a connectivitiy is unavailable.
  bool get isDisconnected => !isConnected;

  /// Returns `true` if there is a connectivitiy to mobile network.
  bool get isMobileNetworkConnected =>
      _connectivityResult == ConnectivityResult.mobile;

  /// Returns `true` if there is a connectivitiy to WiFi network.
  bool get isWiFiNetworkConnected =>
      _connectivityResult == ConnectivityResult.wifi;

  /// Listens the connectivity changes and notifies other listeners.
  Future<void> _connectivityListener(ConnectivityResult result) async {
    try {
      _connectivityResult = result;
      final ipAddress = await InternetAddress.lookup('example.com');
      if (ipAddress.isEmpty || ipAddress.first.rawAddress.isEmpty) {
        throw SocketException;
      }
    } on SocketException {
      _connectivityResult = ConnectivityResult.none;
    }
    if (_oldConnectivityResult != _connectivityResult) {
      _oldConnectivityResult = _connectivityResult;
      notifyListeners();
    }
  }

  @override
  String toString() {
    final message = isConnected
        ? 'connected via ${_connectivityResult.name}'
        : 'disconnected';
    return 'Internet $message';
  }
}
