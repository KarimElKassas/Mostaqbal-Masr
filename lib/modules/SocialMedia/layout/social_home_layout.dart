import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/layout/cubit/social_home_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/layout/cubit/social_home_states.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;


class SocialHomeLayout extends StatefulWidget {
  const SocialHomeLayout({Key? key}) : super(key: key);

  @override
  State<SocialHomeLayout> createState() => _SocialHomeLayoutState();
}

class _SocialHomeLayoutState extends State<SocialHomeLayout>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialHomeCubit(),
      child: BlocConsumer<SocialHomeCubit, SocialHomeStates>(
        listener: (context, state) {
          if (state is SocialHomeLogOutErrorState) {
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          } else if (state is SocialHomeLogOutSuccessState) {
            showToast(
              message: "تم تسجيل الخروج",
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }
        },
        builder: (context, state) {
          var cubit = SocialHomeCubit.get(context);

          return Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
              body: cubit.screens[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: cubit.bottomNavigationItems,
                currentIndex: cubit.currentIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Color(0xFF0500A0),
                onTap: (index) {
                  cubit.changeBottomNavBarIndex(index, context);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    print("app in initState\n");
  }

  @override
  void dispose() async {
    WidgetsBinding.instance!.removeObserver(this);
    print("app in dispose\n");

    await logOut().then((value){
      super.dispose();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed\n");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive\n");
        break;
      case AppLifecycleState.paused:
        print("app in paused\n");
        break;
      case AppLifecycleState.detached:
        //await SocialHomeCubit.get(context).logOut(context);
        await logOut();
        print("app in detached\n");
        break;
    }
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double? loginLogID = prefs.getDouble("Login_Log_ID");
    print("Login Log ID $loginLogID");

    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

    await DioHelper.updateData(url: 'loginlog/PutWithParams', query: {
      'Login_Log_ID': loginLogID!.toInt(),
      'Login_Log_TDate': formattedDate,
    }).then((value) {
      prefs.remove("Login_Log_ID");
      prefs.remove("User_ID");
    });
  }

  @override
  void deactivate() async {
    // TODO: implement deactivate
    await SocialHomeCubit.get(context).logOut(context);
    super.deactivate();
  }
}
