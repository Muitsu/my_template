import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:developer' as dev;

class DeviceAuth {
  // Singleton instance
  static final DeviceAuth _instance = DeviceAuth._internal();

  late LocalAuthentication _auth;
  String debugKey = "LOCAL AUTH";
  List<BiometricType> availableBiometrics = [];
  bool canUseService = false;
  bool _isInitialized = false;
  // Private constructor
  DeviceAuth._internal();

  // Factory constructor to return the same instance
  factory DeviceAuth() => _instance;

  bool get canAuthenticate => availableBiometrics.isNotEmpty || canUseService;
  Future<bool> init() async {
    if (_isInitialized) {
      dev.log("Already initialized", name: debugKey);
      return canUseService;
    }
    _isInitialized = true;
    _auth = LocalAuthentication();
    // Check if biometric available on device
    final canUseBiometric = await checkBiometrics();
    dev.log("Local auth available $canUseBiometric", name: debugKey);
    if (!canUseBiometric) return canUseBiometric;
    // Check if biometric allow on device
    final isSupported = await _auth.isDeviceSupported();
    dev.log("Local auth supported $isSupported", name: debugKey);
    if (!isSupported) return canUseBiometric;
    canUseService = isSupported;
    await getAvailableBiometrics();
    return canUseService;
  }

  Future<bool> checkBiometrics() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      dev.log(e.toString(), name: debugKey);
    }
    return canCheckBiometrics;
  }

  Future<void> getAvailableBiometrics() async {
    try {
      availableBiometrics = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      dev.log(e.toString(), name: debugKey);
    } catch (e) {
      dev.log(e.toString(), name: debugKey);
    }
    dev.log("Available Biometrics: ${availableBiometrics.join(",")}",
        name: debugKey);
  }

  Future<bool> authenticate({bool enablePIN = false}) async {
    if (!canAuthenticate) {
      dev.log("Biometric Unavailable", name: debugKey);
      return false;
    }
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        options: AuthenticationOptions(
          stickyAuth: false,
          biometricOnly: (!enablePIN),
          useErrorDialogs: true,
        ),
      );
    } on PlatformException catch (e) {
      dev.log(e.toString(), name: debugKey);
    } catch (e) {
      dev.log(e.toString(), name: debugKey);
    }
    dev.log("Success Auth: $authenticated", name: debugKey);
    return authenticated;
  }

  Future<bool> cancelAuthentication() async {
    final result = await _auth.stopAuthentication();
    dev.log("Cancel Auth: $result", name: debugKey);
    return result;
  }
}
