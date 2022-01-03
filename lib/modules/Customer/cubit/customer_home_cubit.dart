import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_home_states.dart';
import 'package:mostaqbal_masr/modules/Customer/screens/customer_questions_screen.dart';
import 'package:mostaqbal_masr/modules/Customer/screens/customer_settings_screen.dart';
import 'package:mostaqbal_masr/modules/Customer/screens/customer_support_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/screens/global_display_posts_screen.dart';

class CustomerHomeCubit extends Cubit<CustomerHomeStates>{

  CustomerHomeCubit() : super(CustomerHomeInitialState());

  static CustomerHomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomNavigationItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        IconlyBroken.discovery,
      ),
      label: 'اخبار المشروع',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        FontAwesomeIcons.questionCircle,
      ),
      label: 'الاستفسارات',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        FontAwesomeIcons.teamspeak,
      ),
      label: 'الدعم',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        IconlyBroken.setting,
      ),
      label: 'الاعدادات',
    ),
  ];

  List<Widget> screens = [
    GlobalDisplayPostsScreen(),
    CustomerQuestionsScreen(),
    CustomerSupportScreen(),
    CustomerSettingsScreen(),
  ];

  void changeBottomNavBarIndex(int index, BuildContext context) async {
    currentIndex = index;

    emit(CustomerHomeChangeBottomNavState());
  }

}