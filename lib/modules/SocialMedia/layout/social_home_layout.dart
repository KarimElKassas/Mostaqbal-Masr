import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/layout/cubit/social_home_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/layout/cubit/social_home_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class SocialHomeLayout extends StatelessWidget {
  const SocialHomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialHomeCubit(),
      child: BlocConsumer<SocialHomeCubit, SocialHomeStates>(
        listener: (context, state) {
          if(state is SocialHomeLogOutErrorState){
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }
        },
        builder: (context, state) {
          var cubit = SocialHomeCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body:  cubit.screens[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: cubit.bottomNavigationItems,
                currentIndex: cubit.currentIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Color(0xFF0500A0),
                onTap: (index) {
                  cubit.changeBottomNavBarIndex(index,context);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
