import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/config_export.dart';
import 'data/data_export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await SharedPrefManager.init();
  await HiveBoxPreference.init();
  runApp(MultiBlocProvider(
    providers: AppBloc.listOfBloc,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<AppThemeCubit>().themeMode;
    return MaterialApp(
      title: 'My FLutter Teemplate',
      debugShowCheckedModeBanner: false,
      //THEME
      themeMode: themeMode,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      //ROUTES
      initialRoute: RoutesName.homePage,
      onGenerateRoute: RoutesGenerator.generateRoutes,
    );
  }
}
