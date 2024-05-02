import 'package:flutter/material.dart';

class RoutesError {
  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('error'),
        ),
      ),
    );
  }
}
