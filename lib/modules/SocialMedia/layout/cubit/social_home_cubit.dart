import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List<String>? sectionFormsNameList = [];

  void handleUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sectionFormsNameList = prefs.getStringList("Section_Forms_Name_List");

    if (!sectionFormsNameList!.contains("BtnAddPost") &&
        !sectionFormsNameList!.contains("BtnViewPosts")) {
      for (var i = 0; i < 2; i++) {
        bottomNavigationItems.removeAt(0);
        screens.removeAt(0);
      }
    } else if (!sectionFormsNameList!.contains("BtnAddPost")) {
      bottomNavigationItems.removeAt(0);
      screens.removeAt(0);
    } else if (!sectionFormsNameList!.contains("BtnViewPosts")) {
      bottomNavigationItems.removeAt(1);
      screens.removeAt(1);
    }
    emit(SocialHomeHandleUserTypeState());
  }

  List<BottomNavigationBarItem> bottomNavigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        IconlyBroken.activity,
      ),
      label: 'اضافة خبر',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        IconlyBroken.discovery,
      ),
      label: 'عرض الاخبار',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        IconlyBroken.setting,
      ),
      label: 'الاعدادات',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        IconlyBroken.logout,
      ),
      label: 'تسجيل الخروج',
    ),
  ];

  List<Widget> screens = [
    SocialAddPostScreen(),
    SocialDisplayPostsScreen(),
    SocialSettingsScreen(),
    const BlankScreen(),
  ];

  void changeBottomNavBarIndex(int index, BuildContext context) async {
    currentIndex = index;

    switch (bottomNavigationItems.length) {
      case 4:
        if (index == 3) {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            showToast(
              message: 'تحقق من اتصالك بالانترنت اولاً',
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          } else {
            logOut(context);
          }
        }

        if (index != 3) {
          emit(SocialHomeChangeBottomNavState());
        }
        break;
      case 3:
        if (index == 2) {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            showToast(
              message: 'تحقق من اتصالك بالانترنت اولاً',
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          } else {
            logOut(context);
          }
        }
        if (index != 2) {
          emit(SocialHomeChangeBottomNavState());
        }
        break;
      case 2:
        if (index == 1) {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            showToast(
              message: 'تحقق من اتصالك بالانترنت اولاً',
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          } else {
            logOut(context);
          }
        }

        if (index != 1) {
          emit(SocialHomeChangeBottomNavState());
        }
        break;
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
      prefs.remove("User_Name");
      prefs.remove("User_Password");
      prefs.remove("LoginDate");

      navigateAndFinish(context, LoginScreen());

      emit(SocialHomeLogOutSuccessState());
    }).catchError((error) {
      emit(SocialHomeLogOutErrorState(error.toString()));
    });
  }
}
