import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static final AppInfo _instance = AppInfo._internal();

  factory AppInfo() {
    return _instance;
  }

  AppInfo._internal();

  static PackageInfo? _packageInfo;

  static Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  String get appName => _packageInfo?.appName ?? '';
  String get packageName => _packageInfo?.packageName ?? '';
  String get version => _packageInfo?.version ?? '';
  String get buildNumber => _packageInfo?.buildNumber ?? '';
}

final appInfo = AppInfo();
