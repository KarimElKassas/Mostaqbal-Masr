import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../../shared/widgets/bottom_navigation/button_model.dart';
import '../../../../Global/GroupChat/display/screens/display_groups_screen.dart';
import '../../../../Global/Settings/home/screens/clerk_settings_screen.dart';
import '../../manager/home/screens/monitor_manager_home_screen.dart';
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
    const MonitorManagerHomeScreen(),
    const DisplayGroupsScreen(),
    const ClerkSettingsScreen(),
  ];
  void navigate(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
    emit(ManagerHomeNavigateSuccessState());
  }
  void changeBottomNavBarIndex(int index, BuildContext context) async {
    currentIndex = index;

    emit(ManagerHomeChangeBottomNavState());
  }

}