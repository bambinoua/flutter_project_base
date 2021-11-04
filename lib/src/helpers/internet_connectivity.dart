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
  /// Creates a singleton of [InternetConnectivity].
  factory InternetConnectivity() => _this;
  static final _this = InternetConnectivity._();

  InternetConnectivity._() {
    _connectivity.onConnectivityChanged.listen(_connectivityListener);
    if (Platform.isIOS) {
      () async {
        _connectivityListener(await _connectivity.checkConnectivity());
      }();
    }
  }

  final _connectivity = Connectivity();

  ConnectivityResult _oldConnectivityResult = ConnectivityResult.none;
  ConnectivityResult _connectivityResult = ConnectivityResult.none;

  /// Returns `true` if there is a connectivitiy is available.
  bool get isConnected => _connectivityResult != ConnectivityResult.none;

  /// Returns `true` if there is a connectivitiy is unavailable.
  bool get isDisonnected => !isConnected;

  /// Returns the current Internet connectivity state.
  InternetConnectivityState get state => _stateMap[_connectivityResult]!;

  /// Listens the connectivity changes and notifies other listeners.
  Future<void> _connectivityListener(
      ConnectivityResult connectivityResult) async {
    try {
      _connectivityResult = connectivityResult;
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

  /// This map is for convinience. It allows to map [ConnectivityResult] item
  /// to [InternetConnectivityState].
  ///
  /// [InternetConnectivityState] is used to avoid import of `connectivity_plus` package.
  static const _stateMap = {
    ConnectivityResult.none: InternetConnectivityState.none,
    ConnectivityResult.wifi: InternetConnectivityState.wifi,
    ConnectivityResult.mobile: InternetConnectivityState.mobile,
    ConnectivityResult.ethernet: InternetConnectivityState.ethernet,
  };

  @override
  String toString() =>
      'Internet ' +
      (isConnected ? 'connected via ${describeEnum(state)}' : 'disconnected');
}
