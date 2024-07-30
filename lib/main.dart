import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_template/core/app_info.dart';
import 'package:my_template/core/easyloading_config.dart';
import 'package:my_template/data/api-manager/api_client.dart';
import 'config/config_export.dart';
import 'data/data_export.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await EasyLoadingConfig.init();
  await SharedPrefManager.init();
  await HiveBoxPreference.init();
  await ApiClient.init("base_url");
  await AppInfo.init();
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
      builder: EasyLoading.init(),
    );
  }
}
