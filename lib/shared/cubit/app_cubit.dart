import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/shared/cubit/app_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  void changeAppMode({bool? fromShared})async
  {
    if (fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else
    {
      isDark = !isDark;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isDark', isDark);
      emit(AppChangeModeState());

    }
  }

}