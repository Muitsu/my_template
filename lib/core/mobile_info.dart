import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

class MobileInfo {
  //Default value
  static String deviceModel = "Unknown";
  static String deviceOS = 'Unknown';

  MobileInfo._();

  static final MobileInfo _instance = MobileInfo._();

  static MobileInfo get instance => _instance;

  static Future<void> init(BuildContext context) async {
    TargetPlatform platform = Theme.of(context).platform;
    deviceModel = await _getDeviceModel(platform: platform);
    deviceOS = _getDeviceOS(platform: platform);
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
}
