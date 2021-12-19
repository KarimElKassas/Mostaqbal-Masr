import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/Global/Login/login_screen.dart';
import 'package:mostaqbal_masr/modules/Global/blank_screen.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/layout/cubit/social_home_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_add_post_screen.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_display_posts_screen.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_settings_screen.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialHomeCubit extends Cubit<SocialHomeStates> {
  SocialHomeCubit() : super(SocialHomeInitialState());

  static SocialHomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomNavigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.add_task_rounded,
      ),
      label: 'اضافة خبر',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.visibility,
      ),
      label: 'عرض الاخبار',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.settings,
      ),
      label: 'الاعدادات',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.logout,
      ),
      label: 'تسجيل الخروج',
    ),
  ];

  List screens = [
    SocialAddPostScreen(),
    SocialDisplayPostsScreen(),
    SocialSettingsScreen(),
    const BlankScreen(),
  ];

  void changeBottomNavBarIndex(int index, BuildContext context) {
    currentIndex = index;

    if (index == 3) {
      logOut(context);
    }

    if (index != 3) {
      emit(SocialHomeChangeBottomNavState());
    }
  }

  double? loginLogID;

  Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    loginLogID = prefs.getDouble("Login_Log_ID");
    print("Login Log ID $loginLogID");

    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

    await DioHelper.updateData(url: 'loginlog/PutWithParams', query: {
      'Login_Log_ID': loginLogID!.toInt(),
      'Login_Log_TDate': formattedDate,
    }).then((value) {
      prefs.remove("Login_Log_ID");
      prefs.remove("User_ID");

      navigateAndFinish(context, LoginScreen());

      emit(SocialHomeLogOutSuccessState());
    }).catchError((error){
      emit(SocialHomeLogOutErrorState(error.toString()));
    });
  }
}
