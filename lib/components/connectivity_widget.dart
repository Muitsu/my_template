import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as dev;

class ConnectivityWidget extends StatefulWidget {
  final Widget child;
  final Widget offlineScreen;
  const ConnectivityWidget(
      {super.key, required this.child, required this.offlineScreen});

  @override
  State<ConnectivityWidget> createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.mobile];

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  late final AppLifecycleListener _listener;
  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _listener = AppLifecycleListener(
      onResume: _connectivitySubscription.resume,
      onHide: _connectivitySubscription.pause,
      onPause: _connectivitySubscription.pause,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _listener.dispose();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      dev.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  bool hasStart = false;
  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    //Prevent multiple result at init
    if (!hasStart) {
      hasStart = true;
      return;
    }
    setState(() {
      _connectionStatus = result;
    });
    dev.log('Connectivity changed: $_connectionStatus',
        name: "ConnectivityWidget");
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus.first == ConnectivityResult.mobile ||
        _connectionStatus.first == ConnectivityResult.wifi) {
      return widget.child;
    }
    return widget.offlineScreen;
  }
}
