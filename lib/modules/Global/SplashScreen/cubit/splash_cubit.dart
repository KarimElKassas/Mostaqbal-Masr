import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/Global/Login/login_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/screens/global_display_posts_screen.dart';
import 'package:mostaqbal_masr/modules/Global/SplashScreen/cubit/spash_states.dart';
import 'package:mostaqbal_masr/modules/Mechan/layout/mechan_home_layout.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/layout/social_home_layout.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitialState());

  static SplashCubit get(context) => BlocProvider.of(context);

  double? loginLogID;

  Future<void> navigate(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await Future.delayed(const Duration(milliseconds: 4000), () {});

    if (prefs.containsKey("LoginDate")) {
      DateTime currentDate = DateTime.now();

      String loginDate = prefs.getString("LoginDate").toString();
      String sectionName = prefs.getString("Section_Name").toString();

      double difference = currentDate.difference(DateTime.parse(loginDate)).inHours.toDouble();
      print("Difference : $difference");

      if (difference >= 24.0) {
        await logOut(context, prefs);
        navigateToLogin(context);
        emit(SplashSuccessNavigateState());
      }else{

        switch (sectionName){

          case "إدارة التسويق":
            navigateToSocialHome(context);
            break;
          case "الميكنة الزراعية":
            navigateToMechanHome(context);
            break;
        }
        emit(SplashSuccessNavigateState());
      }
    }else {
      navigateToDisplayPosts(context);
      emit(SplashSuccessNavigateState());
    }
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
  void navigateToDisplayPosts(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => GlobalDisplayPostsScreen()));
  }

  void navigateToSocialHome(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SocialHomeLayout()));
  }
  void navigateToMechanHome(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MechanHomeLayout()));
  }


  Future<void> logOut(BuildContext context, SharedPreferences prefs) async {

    loginLogID = prefs.getDouble("Login_Log_ID");
    print("Login Log ID $loginLogID");

    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

    await DioHelper.updateData(url: 'loginlog/PutWithParams', query: {
      'Login_Log_ID': loginLogID!.toInt(),
      'Login_Log_TDate': formattedDate,
    }).then((value) {
      prefs.remove("Login_Log_ID");
      prefs.remove("User_ID");
      prefs.remove("User_Name");
      prefs.remove("User_Password");
      prefs.remove("LoginDate");
    });
  }
}
