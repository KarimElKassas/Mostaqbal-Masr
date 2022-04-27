import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:pandabar/model.dart';

import '../../../../../shared/widgets/bottom_navigation/button_model.dart';
import '../../../../Global/GroupChat/display/screens/display_groups_screen.dart';
import '../../../../Global/Settings/home/screens/clerk_settings_screen.dart';
import '../../manager/screens/monitor_manager_home_two_screen.dart';
import 'manager_home_states.dart';

class ManagerHomeCubit extends Cubit<ManagerHomeStates>{

  ManagerHomeCubit() : super(ManagerHomeInitialState());

  static ManagerHomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<MyNavBarButtonData> bottomNavigationItems = [
    MyNavBarButtonData(
        id: 0,
        icon: IconlyBroken.home,
        title: 'الرئيسية',
        isLeading: true
    ),
    MyNavBarButtonData(
        id: 2,
        icon: IconlyBroken.setting,
        title: 'الإعدادات',
        isLeading: false
    ),
  ];
  List<IconData> icons = [
    EvaIcons.home,
    EvaIcons.settings,
  ];
  List<Widget> screens = [
    const MonitorManagerHomeTwoScreen(),
    const DisplayGroupsScreen(),
    const ClerkSettingsScreen(),
  ];

  void changeBottomNavBarIndex(int index, BuildContext context) async {
    currentIndex = index;

    emit(ManagerHomeChangeBottomNavState());
  }

}