import 'package:animate_do/animate_do.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mostaqbal_masr/shared/widgets/bottom_navigation/bottom_nav.dart';
import 'package:pandabar/main.view.dart';
import 'package:pandabar/model.dart';
import 'dart:ui' as ui;
import '../cubit/manager_home_cubit.dart';
import '../cubit/manager_home_states.dart';

class ManagerHomeLayout extends StatefulWidget {
  const ManagerHomeLayout({Key? key}) : super(key: key);

  @override
  State<ManagerHomeLayout> createState() => _ManagerHomeLayoutState();
}

class _ManagerHomeLayoutState extends State<ManagerHomeLayout>
    with WidgetsBindingObserver {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManagerHomeCubit(),
      child: BlocConsumer<ManagerHomeCubit, ManagerHomeStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          var cubit = ManagerHomeCubit.get(context);

          return Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
              extendBody: true,
              body: cubit.screens[cubit.currentIndex],
              bottomNavigationBar: FadeInUp(
                duration: const Duration(milliseconds: 1000),
                child: MyNavBar(
                  buttonData: cubit.bottomNavigationItems,
                  buttonSelectedColor: const Color(0xFFE8E8A6),
                  buttonColor: Colors.grey[300],
                  onChange: (id) {
                    cubit.changeBottomNavBarIndex(id, context);
                  },
                  fabColors: const[
                    Colors.white,
                    Colors.white70,
                  ],
                  onFabButtonPressed: () {

                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}