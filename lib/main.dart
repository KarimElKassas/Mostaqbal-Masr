import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_support_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/registration/screens/clerk_registration_screen.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/layout/it_home_layout.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_cubit.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          SocialDisplayPostsCubit()
            ..getPosts(),
        ),
        BlocProvider(
          create: (context) =>
          CustomerSupportCubit()
            ..getUserData(),
        ),
      ],
      child: Directionality(
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
          home: ITHomeScreen(),
        ),
      ),
    );
  }
}
