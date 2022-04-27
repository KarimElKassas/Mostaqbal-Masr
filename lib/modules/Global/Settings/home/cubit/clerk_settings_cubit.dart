import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../Login/clerk_login_screen.dart';
import 'clerk_settings_states.dart';


class ClerkSettingsCubit extends Cubit<ClerkSettingsStates> {
  ClerkSettingsCubit() : super(ClerkSettingsInitialState());

  static ClerkSettingsCubit get(context) => BlocProvider.of(context);

  String userID = "";
  String userName = "";
  String userPhone = "";
  String userNumber = "";
  String userPassword = "";
  String userManagementID = "";
  String userManagementName = "";
  String userCategoryName = "";
  String userRankName = "";
  String userTypeName = "";
  String userCoreStrengthName = "";
  String userPresenceName = "";
  String userJobName = "";
  String userToken = "";
  String userImage = "";

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString("ClerkID")!;
    userName = prefs.getString("ClerkName")!;
    userPhone = prefs.getString("ClerkPhone")!;
    userNumber = prefs.getString("ClerkNumber")!;
    userPassword = prefs.getString("ClerkPassword")!;
    userManagementID = prefs.getString("ClerkManagementID")!;
    userManagementName = prefs.getString("ClerkManagementName")!;
    userTypeName = prefs.getString("ClerkTypeName")!;
    userRankName = prefs.getString("ClerkRankName")!;
    userCategoryName = prefs.getString("ClerkCategoryName")!;
    userCoreStrengthName = prefs.getString("ClerkCoreStrengthName")!;
    userPresenceName = prefs.getString("ClerkPresenceName")!;
    userJobName = prefs.getString("ClerkJobName")!;
    userToken = prefs.getString("ClerkToken")!;
    await FirebaseDatabase.instance.reference().child("Clerks").child(userPhone).get().then((value)async{
      await prefs.setString("ClerkImage", value.value["ClerkImage"]!.toString());
    });
    userImage = prefs.getString("ClerkImage")!;
    print("User IMAGE : ${prefs.getString("ClerkImage")} \n");

    emit(ClerkSettingsGetDataState());
  }

  Future<void> logOut(BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove("ClerkID");
    await prefs.remove("ClerkName");
    await prefs.remove("ClerkPhone");
    await prefs.remove("ClerkNumber");
    await prefs.remove("ClerkPassword");
    await prefs.remove("ClerkManagementID");
    await prefs.remove("ClerkManagementName");
    await prefs.remove("ClerkTypeName");
    await prefs.remove("ClerkRankName");
    await prefs.remove("ClerkCategoryName");
    await prefs.remove("ClerkCoreStrengthName");
    await prefs.remove("ClerkPresenceName");
    await prefs.remove("ClerkJobName");
    await prefs.remove("ClerkToken");
    await prefs.remove("ClerkSubscriptions");

    Navigator.pushReplacement(context, ScaleTransition1(page: ClerkLoginScreen(), startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));

    emit(ClerkSettingsLogOutSuccessState());
  }

  void navigate(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
    emit(ClerkSettingsNavigateState());
  }
}
