import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/complaints/screens/officer_display_client_complaints_screen.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/complaints/screens/officer_display_complaints_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Complaints/clerk/cubit/complaint_states.dart';
import 'package:mostaqbal_masr/modules/Global/Complaints/clerk/screens/add_complaint_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Complaints/clerk/screens/display_complaints_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Login/clerk_login_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import 'officer_complaint_states.dart';


class OfficerComplaintCubit extends Cubit<OfficerComplaintStates>{
  OfficerComplaintCubit() : super(OfficerComplaintInitialState());

  static OfficerComplaintCubit get(context) => BlocProvider.of(context);

  String userID = "";
  String receiverID = "Future Of Egypt";
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

  List<String> buttonPermission = [];
  List<String> clerkPermissionList = [];
  List<String> clientPermissionList = [];
  List<String> departmentManagerList = [];

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

    emit(OfficerComplaintGetUserDataState());
  }

  Future<void> getAllPermissions()async {

    await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Permissions").get().then((value){
      print("Single Value : $value\n");

      value.value.forEach((key, value)async{
        print("Value : $key\n");
        buttonPermission.add(key);
      });
      emit(OfficerComplaintGetPermissionsState());
    }).then((value)async{
      await getClerksForClerksComplaintsPermission();
      await getClerksForClientComplaintsPermission();
    });
  }

  Future<void> getDepartmentManager()async {

    await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Manager").get().then((value){
      value.value.forEach((key, value){
        departmentManagerList.add(key);
      });
    });
    emit(OfficerComplaintGetDepartmentManagerState());
  }

  Future<void> getClerksForClerksComplaintsPermission()async {

    await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Permissions").child("ClerksComplaints").get().then((value){
      value.value.forEach((key, value){
        clerkPermissionList.add(key);
      });
    });
    emit(OfficerComplaintGetClerksForPermissionsState());
  }

  Future<void> getClerksForClientComplaintsPermission()async {

      await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Permissions").child("ClientsComplaints").get().then((value){
        value.value.forEach((key, value){
            clientPermissionList.add(key);
        });
      });
    emit(OfficerComplaintGetClerksForPermissionsState());
  }

  void navigateToClerkComplaint(BuildContext context){
    Navigator.push(context, ScaleTransition1(page: OfficerDisplayComplaintScreen(officerID: userID), startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
  }

  void navigateToDisplayClientComplaint(BuildContext context){
    Navigator.push(context, ScaleTransition1(page: OfficerDisplayClientComplaintsScreen(officerID: userID), startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
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

    emit(OfficerComplaintLogOutUserState());
  }
}