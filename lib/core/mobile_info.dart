import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class MobileInfo {
  //Default value
  static String deviceModel = "Unknown";
  static String deviceManufacturer = "Unknown";
  static String deviceOS = 'Unknown';
  static String deviceOSVersion = 'Unknown';
  static String deviceName = "Unknown";

  MobileInfo._();

  static final MobileInfo _instance = MobileInfo._();

  static MobileInfo get instance => _instance;

  static Future<void> init(BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((e) async {
      TargetPlatform platform = Theme.of(context).platform;
      deviceModel = await _getDeviceModel(platform: platform);
      deviceOS = _getDeviceOS(platform: platform);
      deviceOSVersion = await _getDeviceOSVersion(platform: platform);
      deviceManufacturer = await _getDeviceManufacturer(platform: platform);
      deviceName = "$deviceManufacturer $deviceModel";
    });
  }

  static Future<String> _getDeviceModel(
      {required TargetPlatform platform}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return platform == TargetPlatform.android
        ? (await deviceInfo.androidInfo).model
        : platform == TargetPlatform.iOS
            ? (await deviceInfo.iosInfo).model
            : 'Unknown';
  }

  static String _getDeviceOS({required TargetPlatform platform}) {
    final mobileInfo = {
      TargetPlatform.android: "Android",
      TargetPlatform.iOS: "iOS"
    };
    return mobileInfo[platform] ?? "Unknown";
  }

  static Future<String> _getDeviceOSVersion(
      {required TargetPlatform platform}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return platform == TargetPlatform.android
        ? "Android ${(await deviceInfo.androidInfo).version.release}"
        : platform == TargetPlatform.iOS
            ? "iOS ${(await deviceInfo.iosInfo).systemVersion}"
            : 'Unknown';
  }

  static Future<String> _getDeviceManufacturer(
      {required TargetPlatform platform}) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return platform == TargetPlatform.android
        ? (await deviceInfo.androidInfo).manufacturer
        : platform == TargetPlatform.iOS
            ? (await deviceInfo.iosInfo).name
            : 'Unknown';
  }
}
