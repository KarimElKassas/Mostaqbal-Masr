import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_support_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/SplashScreen/splash_screen.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_cubit.dart';
import 'package:mostaqbal_masr/network/local/cache_helper.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/bloc_observer.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/cubit/app_cubit.dart';
import 'package:mostaqbal_masr/shared/cubit/app_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  print('on background message');
  print(message.data.toString());

  showToast(message: "on background message", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'Future Of Egypt Channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    enableVibration: true,
    enableLights: true,
    ledColor: Colors.red,
    showBadge: true,
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();

  await CacheHelper.init();
  DioHelper.init();

  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();

  print("Token : $token\n");

  /*await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );*/

  // foreground fcm
  FirebaseMessaging.onMessage.listen((RemoteMessage message)async
  {
    print('on message');
    print(message.data.toString());

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
/*
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: android.smallIcon,
              // other properties...
            ),
          ));
    }
*/

    //showNotification(event.notification?.title, event.notification?.body);
    showToast(message: "on foreground message", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
  });
  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print('on message opened app');
    print(event.data.toString());

    showToast(message: "on message opened app", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
  });
  // background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isDark = prefs.getBool("isDark");

  runApp(MyApp(isDark??false));
}

class MyApp extends StatefulWidget {

  final bool isDark;

   const MyApp(this.isDark, {Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting('ar', null);
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
        BlocProvider(
          create: (context) =>
          AppCubit()
            ..changeAppMode(fromShared: widget.isDark),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state){},
        builder: (context, state){

          var cubit = AppCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: MaterialApp(
              title: 'مستقبل مصر',
              theme: ThemeData(
                appBarTheme: const AppBarTheme(
                    backgroundColor: Color(0xff232c38),
                    elevation: 0,
                    titleTextStyle: TextStyle(
                        fontFamily: "Tajwal",
                        color: Colors.white,
                        fontSize: 16
                    )
                ),
                primarySwatch: Colors.teal,
                scaffoldBackgroundColor: Colors.white,
                fontFamily: "Tajwal",
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                  selectedLabelStyle: TextStyle(fontFamily: "Roboto"),
                  unselectedLabelStyle: TextStyle(fontFamily: "Roboto"),
                ),
                primaryColor: Colors.teal[700],
              ),
              darkTheme: ThemeData(
                appBarTheme: const AppBarTheme(
                    backgroundColor: Color(0xff232c38),
                    elevation: 0,
                    titleTextStyle: TextStyle(
                        fontFamily: "Tajwal",
                        color: Colors.white,
                        fontSize: 16
                    )
                ),
                scaffoldBackgroundColor: const Color(0xff232c38),
                fontFamily: "Amiri",
                bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                    selectedLabelStyle: TextStyle(fontFamily: "Roboto"),
                    unselectedLabelStyle: TextStyle(fontFamily: "Roboto", color: Colors.white),
                    elevation: 0
                ),
              ),
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
