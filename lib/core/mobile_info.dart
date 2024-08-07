import 'package:device_info_plus/device_info_plus.dart';
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
    deviceOS = await _getDeviceOS(platform: platform);
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

  static Future<String> _getDeviceOS({required TargetPlatform platform}) async {
    String result = "";
    final mobileInfo = {
      TargetPlatform.android: "Android",
      TargetPlatform.iOS: "iOS"
    };
    result = mobileInfo[platform] ?? "Unknown";

    if (result != "Unknown" && result == "Android") {
      DeviceInfoPlugin devInfo = DeviceInfoPlugin();
      final androidInfo = await devInfo.androidInfo;
      final manufacturer = androidInfo.manufacturer.toLowerCase();
      final brand = androidInfo.brand.toLowerCase();
      bool isHuawei =
          manufacturer.contains("huawei") || brand.contains("huawei");
      result = isHuawei ? "Huawei" : result;
    }

    return result;
  }
}
