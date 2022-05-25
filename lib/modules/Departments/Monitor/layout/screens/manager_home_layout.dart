import 'dart:ui' as ui;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/screens/social_display_chats_screen.dart';
import 'package:mostaqbal_masr/shared/widgets/bottom_navigation/bottom_nav.dart';

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
        listener: (context, state) {},
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
                  fabColors: const [
                    Colors.white,
                    Colors.white70,
                  ],
                  onFabButtonPressed: () {
                    cubit.navigate(context, SocialDisplayChats());
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
