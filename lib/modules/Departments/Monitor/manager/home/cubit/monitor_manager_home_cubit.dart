import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mostaqbal_masr/models/firebase_clerk_model.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/home/cubit/monitor_manager_home_states.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/home/screens/monitor_manager_home_screen.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/display/screens/display_groups_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Settings/home/screens/clerk_settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../../../models/officer_permission_model.dart';
import '../../../../../Global/Login/clerk_login_screen.dart';
import '../../../complaints/screens/officer_display_client_complaints_screen.dart';
import '../../../complaints/screens/officer_display_complaints_screen.dart';

class MonitorManagerHomeCubit extends Cubit<MonitorManagerHomeStates>{
  MonitorManagerHomeCubit() : super(MonitorManagerHomeInitialState());

  static MonitorManagerHomeCubit get(context) => BlocProvider.of(context);

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
  bool gotPermission = false;
  int currentIndex = 0;

  ClerkFirebaseModel? clerkFirebaseModel;
  List<ClerkFirebaseModel> clerksModelList = [];
  List<ClerkFirebaseModel> filteredClerksModelList = [];
  OfficerPermissionModel? permissionModel;
  List<OfficerPermissionModel> permissionModelList = [];

  void getUserData() async {
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
    userImage = prefs.getString("ClerkImage")!;

    emit(MonitorManagerHomeGetUserDataState());
  }

  Future<void> getManagementClerks() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userManagementID = prefs.getString("ClerkManagementID")!;

    print("USER MANAGEMENT ID : $userManagementID\n");
    FirebaseDatabase.instance.reference().child("Clerks").get().then((value){
      value.value.forEach((key, value){
       clerkFirebaseModel = ClerkFirebaseModel(
           value["ClerkID"],
           value["ClerkName"],
           value["ClerkImage"],
           value["ClerkManagementID"].toString(),
           value["ClerkJobName"],
           value["ClerkNumber"],
           value["ClerkAddress"],
           value["ClerkPhone"],
           value["ClerkPassword"],
           value["ClerkState"],
           value["ClerkToken"],
           value["ClerkLastMessage"],
           value["ClerkLastMessageTime"],
           value["ClerkSubscriptions"]);
       clerksModelList.add(clerkFirebaseModel!);
      });
      clerksModelList.removeWhere((element) => element.clerkManagementID != userManagementID);
      filteredClerksModelList = clerksModelList;
      print("FILTERED ${filteredClerksModelList.length}\n");
      emit(MonitorManagerHomeGetManagementUsersState());
    });
  }

  Future<void> getPermissions() async {
    gotPermission = false;
    emit(MonitorManagementHomeLoadingPermissionsState());
    Future.delayed(const Duration(seconds: 1)).then((value){
      FirebaseFirestore.instance.collection('Departments').doc('Monitor').collection("Permissions").snapshots().listen((event) {
        permissionModelList = [];
        for (var element in event.docs) {
          Map<String, dynamic> data = element.data();
          print("DESC : ${data["PermissionDescription"]}\n");
          permissionModel = OfficerPermissionModel(data["ManagerID"] ,data["PermissionID"], data["PermissionDescription"]);
          permissionModelList.add(permissionModel!);
        }
        gotPermission = true;
        emit(MonitorManagementHomeGetPermissionsState());
      });
    });
  }

  void searchUser(String value) {
    clerksModelList.removeWhere((element) => element.clerkManagementID != userManagementID);
    filteredClerksModelList = clerksModelList
        .where(
            (user) => user.clerkName!.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredClerksModelList.length}\n");
    emit(MonitorManagerHomeFilterUsersState());
  }

  void navigateTo(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
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

    emit(MonitorManagerHomeLogOutUserState());
  }
}