import 'package:flutter/material.dart';
import '/../config/config_export.dart';
import '../../screens/screens_export.dart';

class RoutesGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    // final args = settings.arguments;
    switch (settings.name) {
      case RoutesName.homePage:
        return MaterialPageRoute(
            settings: const RouteSettings(name: RoutesName.homePage),
            builder: (context) =>
                const MyHomePage(title: 'Flutter Demo Home Page'));
      default:
        return RoutesError.errorRoute();
    }
  }
}
