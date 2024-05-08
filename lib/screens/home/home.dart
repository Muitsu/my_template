import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_template/components/custom_modal_sheet.dart';
import 'package:my_template/config/config_export.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
              onPressed: () {}, child: const Text('Animated Dialog')),
          ElevatedButton(
              onPressed: () {}, child: const Text('Animated Bottom Sheet')),
          ElevatedButton(
              onPressed: () {
                const CustomModalSheet().show(context);
              },
              child: const Text('Animated Bottom Sheet')),
        ],
      ),
    );
  }
}
