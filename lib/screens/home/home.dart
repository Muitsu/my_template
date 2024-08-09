import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/components/custom_modal_sheet.dart';
import 'package:my_template/config/config_export.dart';
import 'package:my_template/core/device_auth.dart';
import 'package:my_template/screens/home/behance_profile.dart';

import '../../components/hour_countdown.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          Switch.adaptive(
            value: context.watch<AppThemeCubit>().themeMode == ThemeMode.light,
            onChanged: (isLightMode) {
              context.read<AppThemeCubit>().toggleTheme(isLightMode);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HourCountdown(
              times: [
                DateTime.parse("2024-08-09 05:00:00.000"),
                DateTime.parse("2024-08-09 13:00:00.000"),
                DateTime.parse("2024-08-09 15:00:00.000"),
                DateTime.parse("2024-08-09 18:00:00.000"),
                DateTime.parse("2024-08-09 23:00:00.000"),
                DateTime.parse("2024-08-10 05:00:00.000"),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const BehanceProfile()));
                },
                child: const Text('Behance Style Appbar')),
            ElevatedButton(
                onPressed: () {}, child: const Text('Animated Bottom Sheet')),
            ElevatedButton(
                onPressed: () {
                  const CustomModalSheet().show(context);
                },
                child: const Text('Animated Bottom Sheet')),
            ElevatedButton(
                onPressed: () {
                  DeviceAuth().authenticate(enablePIN: true);
                },
                child: const Text('Biometric Auth')),
          ],
        ),
      ),
    );
  }
}
