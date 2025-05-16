import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:developer' as dev;

class ConnectivityHelper {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> hasInternetConnection() async {
    final result = await _connectivity.checkConnectivity();
    return _isInternetActive(result);
  }

  static bool _isInternetActive(List<ConnectivityResult> result) =>
      (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.vpn));

  static Future<bool> checkingRealtimeConnection() async {
    String tag = "ConnectivityHelper";
    String testedUrl = "one.one.one.one";
    dev.log("Looking Up Realtime Connection: $testedUrl", name: tag);

    try {
      final lookup = await InternetAddress.lookup(testedUrl);
      bool isConnected =
          lookup.isNotEmpty && lookup.first.rawAddress.isNotEmpty;

      String message =
          (isConnected) ? "Connection success !" : "Connection failed ^x^";
      dev.log("$message : $testedUrl", name: tag);

      return isConnected;
    } catch (e) {
      dev.log("Connection failed ^x^ : $testedUrl", name: tag);
      return false;
    }
  }
}
