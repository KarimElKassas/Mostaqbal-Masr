import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_home_cubit.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_home_states.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;


class CustomerHomeLayout extends StatefulWidget {
  const CustomerHomeLayout({Key? key}) : super(key: key);

  @override
  State<CustomerHomeLayout> createState() => _CustomerHomeLayoutState();
}

class _CustomerHomeLayoutState extends State<CustomerHomeLayout>
    with WidgetsBindingObserver {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerHomeCubit(),
      child: BlocConsumer<CustomerHomeCubit, CustomerHomeStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          var cubit = CustomerHomeCubit.get(context);

          return Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
              body: cubit.screens[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: cubit.bottomNavigationItems,
                currentIndex: cubit.currentIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Colors.teal[700],
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

    noInternet();

    print("app in initState\n");
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
        //await CustomerHomeCubit.get(context).logOut(context);
        //await logOut();
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
}
