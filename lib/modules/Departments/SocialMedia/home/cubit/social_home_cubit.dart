import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Departments/SocialMedia/posts/screens/social_display_posts_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/screens/social_display_chats_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Login/clerk_login_screen.dart';
import 'package:mostaqbal_masr/modules/Global/blank_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../posts/screens/social_add_post_screen.dart';
import '../../settings/screens/social_settings_screen.dart';
import 'social_home_states.dart';


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
    } else if (!sectionFormsNameList!.contains("BtnViewChats")) {
      bottomNavigationItems.removeAt(2);
      screens.removeAt(2);
    }
    emit(SocialHomeHandleUserTypeState());
  }

  void refreshToken() async {
    var token = await FirebaseMessaging.instance.getToken();

    FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child("Future Of Egypt")
        .child("UserToken")
        .set(token!);
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
        IconlyBroken.chat,
      ),
      label: 'المحادثات',
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
    SocialDisplayChats(),
    SocialSettingsScreen(),
    const BlankScreen(),
  ];

  void changeBottomNavBarIndex(int index, BuildContext context) async {
    currentIndex = index;

    if (index == bottomNavigationItems.length - 1) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if ((connectivityResult == ConnectivityResult.none) ||
          (connectivityResult == ConnectivityResult.mobile)) {
        showToast(
          message: 'برجاء الاتصال بشبكة المشروع اولاً',
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
        );
      } else if (connectivityResult == ConnectivityResult.wifi) {
        final info = NetworkInfo();

        info.getWifiIP().then((value) async {
          if (value!.contains("172.16.1.")) {
            print("Mobile Is in The Network \n");

            logOut(context);
          } else {
            showToast(
              message: "برجاءالاتصال بشبكة المشروع اولاً",
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }
        }).catchError((error) {
          showToast(
            message: "لقد حدث خطأ ما",
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
        });
      }
    }

    if (index != bottomNavigationItems.length - 1) {
      emit(SocialHomeChangeBottomNavState());
    }
  }

  Future<void> logOut(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove("ClerkID");
    await prefs.remove("ClerkName");
    await prefs.remove("ClerkPhone");
    await prefs.remove("ClerkNumber");
    await prefs.remove("ClerkPassword");
    await prefs.remove("ClerkManagementID");
    await prefs.remove("ClerkManagementName");
    await prefs.remove("ClerkTypeName");
    await prefs.remove("ClerkRankName");
    await prefs.remove("ClerkCategoryName");
    await prefs.remove("ClerkCoreStrengthName");
    await prefs.remove("ClerkPresenceName");
    await prefs.remove("ClerkJobName");
    await prefs.remove("ClerkToken");
    await prefs.remove("ClerkSubscriptions");

    Navigator.pushReplacement(context, ScaleTransition1(page: ClerkLoginScreen(), startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
    emit(SocialHomeLogOutSuccessState());
  }
}
