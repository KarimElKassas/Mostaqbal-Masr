import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/models/firebase_clerk_model.dart';
import 'package:mostaqbal_masr/models/officer_permission_model.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/cubit/monitor_manager_home_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../Global/Login/clerk_login_screen.dart';
import '../../complaints/screens/officer_display_client_complaints_screen.dart';
import '../../complaints/screens/officer_display_complaints_screen.dart';
import 'monitor_officer_permission_states.dart';

class MonitorOfficerPermissionCubit extends Cubit<MonitorOfficerPermissionStates>{
  MonitorOfficerPermissionCubit() : super(MonitorOfficerPermissionInitialState());

  static MonitorOfficerPermissionCubit get(context) => BlocProvider.of(context);

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

  OfficerPermissionModel? permissionModel;
  List<OfficerPermissionModel> permissionModelList = [];
  List<OfficerPermissionModel> allPermissionModelList = [];
  List<OfficerPermissionModel> differenceList = [];
  List<String> clerkPermissionList = [];

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

    emit(MonitorOfficerPermissionGetUserDataState());
  }

  Future<void> getPermissions(String clerkID)async {
    emit(MonitorOfficerPermissionLoadingGetPermissionsState());
    await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Permissions").get().then((value){
      print("Single Value : ${value.value}\n");

      value.value.forEach((key, value)async{
       // print("KEY : $key\n");
        //print("Value : ${value["PermissionDescription"]}\n");
      });
    }).then((value)async{
      await getClerksForClerksComplaintsPermission(clerkID);
      await getClerksForClientsComplaintsPermission(clerkID);
    });

  }
  Future<void> getClerksForClerksComplaintsPermission(String clerkID)async {

    await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Permissions").child("ClerksComplaints").child(clerkID).get().then((value) async{

      if(value.exists){
        print("value clerk new : ${value.value["ClerkID"]}\n");
        await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Permissions").child("ClerksComplaints").get().then((value){
          print("DESCRIPTION : ${value.value["PermissionDescription"]}\n");
          permissionModel = OfficerPermissionModel(value.value["PermissionID"], value.value["PermissionDescription"]);
          permissionModelList.add(permissionModel!);
          print("LIST LENGTH : ${permissionModelList.length}\n");
        });

      }else{
        print("NO Clerk VALUE \n");
      }

      /*value.value.forEach((key, value){
        print("KEY : $key\n");
        print("Value : ${value}\n");
        clerkPermissionList.add(key);
      });*/
    });
    emit(MonitorOfficerPermissionGetClerksForPermissionsState());
  }
  Future<void> getClerksForClientsComplaintsPermission(String clerkID)async {

    await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Permissions").child("ClientsComplaints").child(clerkID).get().then((value) async{

      if(value.exists){
        print("value new : ${value.value["ClerkID"]}\n");
        await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Permissions").child("ClientsComplaints").get().then((value){
          print("DESCRIPTION : ${value.value["PermissionDescription"]}\n");
          permissionModel = OfficerPermissionModel(value.value["PermissionID"], value.value["PermissionDescription"]);
          permissionModelList.add(permissionModel!);
          print("LIST LENGTH : ${permissionModelList.length}\n");
        });

      }else{
        print("NO VALUE \n");
      }

      /*value.value.forEach((key, value){
        print("KEY : $key\n");
        print("Value : ${value}\n");
        clerkPermissionList.add(key);
      });*/
    });
    emit(MonitorOfficerPermissionGetClerksForPermissionsState());
  }

  Future<void> deletePermissionFromClerk(String clerkID, String permissionID)async{
    await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Permissions").child(permissionID).child(clerkID).remove().catchError((error){
      print(error.toString());
      showToast(message: error.toString(), length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
    });
    permissionModelList.removeWhere((element) => element.permissionID == permissionID);
    emit(MonitorOfficerPermissionDeletePermissionsState());
  }

  Future<void> addPermissionToClerk()async{

    await FirebaseDatabase.instance.reference().child("Departments").child("Monitor").child("Permissions").get().then((value){

      value.value.forEach((key, value)async{
        permissionModel = OfficerPermissionModel(value["PermissionID"], value["PermissionDescription"]);
        allPermissionModelList.add(permissionModel!);
        //print("${value["PermissionID"]}\n ${value["PermissionDescription"]}\n");
      });

      differenceList = allPermissionModelList.toSet().difference(permissionModelList.toSet()).toList();
      print("Difference : ${differenceList.length}\n");
    });

  }

  void navigateTo(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
  }
}