import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/components/modal/custom_draggable_sheet.dart';
import 'package:my_template/config/config_export.dart';
import 'package:my_template/core/date_format.dart';
import 'package:my_template/core/device_auth.dart';
import 'package:my_template/screens/home/behance_profile.dart';
import 'package:my_template/screens/shrink_appbar_screen.dart';

import '../../components/hour_countdown.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dateNow = FormatDate.formatTo(
      date: DateTime.now().toString(), format: "yyyy-MM-dd");
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
                DateTime.parse("$dateNow 05:00:00.000"),
                DateTime.parse("$dateNow 13:00:00.000"),
                DateTime.parse("$dateNow 15:00:00.000"),
                DateTime.parse("$dateNow 18:00:00.000"),
                DateTime.parse("$dateNow 23:00:00.000"),
                DateTime.parse("$dateNow 05:00:00.000"),
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
                onPressed: () {
                  CustomDraggableSheet.show(
                      context: context,
                      useCustomAnimation: true,
                      builder: (context, sc) {
                        return TemplateScreen(sc: sc);
                      });
                },
                child: const Text('Animated Bottom Sheet')),
            ElevatedButton(
                onPressed: () {
                  CustomDraggableSheet.show(
                      context: context,
                      builder: (context, sc) {
                        return TemplateScreen(sc: sc);
                      });
                },
                child: const Text('Modal Bottom Sheet')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ShrinkAppbarScreen()));
                },
                child: const Text("Shrink Appbar")),
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

class TemplateScreen extends StatefulWidget {
  final ScrollController? sc;
  const TemplateScreen({super.key, required this.sc});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(18),
            child: Align(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(50)),
              height: 5,
              width: 60,
            ))),
        body: ListView(
          controller: widget.sc,
          children:
              List.generate(15, (index) => ListTile(title: Text("data$index"))),
        ));
  }
}
