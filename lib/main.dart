import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mostaqbal_masr/modules/Customer/layout/customer_home_layout.dart';
import 'package:mostaqbal_masr/modules/Customer/menu/menu_list.dart';
import 'package:mostaqbal_masr/modules/Customer/screens/customer_register_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Drawer/big_layout.dart';
import 'package:mostaqbal_masr/modules/Global/Drawer/home_screen.dart';
import 'package:mostaqbal_masr/modules/Global/SplashScreen/splash_screen.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_states.dart';
import 'package:mostaqbal_masr/network/local/cache_helper.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();
  DioHelper.init();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialDisplayPostsCubit(),
      child: BlocConsumer<SocialDisplayPostsCubit,SocialDisplayPostsStates>(
        listener: (context, state){},
        builder: (context, state){

          return Directionality(
            textDirection: TextDirection.rtl,
            child: MaterialApp(
              title: 'مستقبل مصر',
              theme: ThemeData(
                fontFamily: "Tajwal",
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  selectedLabelStyle: TextStyle(fontFamily: "Roboto"),
                  unselectedLabelStyle: TextStyle(fontFamily: "Roboto"),
                ),
                primaryColor: Colors.teal[700],
              ),
              debugShowCheckedModeBanner: false,
              home: CustomerRegisterScreen(),
            ),
          );
        },
      ),
    );
  }
}
