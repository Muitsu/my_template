import 'package:flutter_bloc/flutter_bloc.dart';
import '../config_export.dart';

class AppBloc {
  static List<BlocProvider> listOfBloc = [
    BlocProvider<AppThemeCubit>(create: (context) => AppThemeCubit()),
  ];
}
