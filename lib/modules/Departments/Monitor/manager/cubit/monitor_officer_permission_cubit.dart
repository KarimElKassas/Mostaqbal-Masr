import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/models/officer_permission_model.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import 'monitor_officer_permission_states.dart';

class MonitorOfficerPermissionCubit
    extends Cubit<MonitorOfficerPermissionStates> {
  MonitorOfficerPermissionCubit()
      : super(MonitorOfficerPermissionInitialState());

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
  bool isPermissionSelected = false;
  bool gotPermission = false;

  OfficerPermissionModel? permissionModel;
  List<OfficerPermissionModel> grantedPermissionModelList = [];
  List<OfficerPermissionModel> unGrantedPermissionModelList = [];
  List<OfficerPermissionModel> selectedUnGrantedPermissionModelList = [];
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

  Future<void> getPermissions(String clerkID) async {
    gotPermission = false;
    grantedPermissionModelList = [];
    await getClerksForClerksComplaintsPermission(clerkID);
    await getClerksForClientsComplaintsPermission(clerkID);
    await getUnGrantedPermissions();
    gotPermission = true;
    emit(MonitorOfficerPermissionGetPermissionsState());
  }

  Future<void> getClerksForClerksComplaintsPermission(String clerkID) async {
    await FirebaseDatabase.instance
        .reference()
        .child("Departments")
        .child("Monitor")
        .child("Permissions")
        .child("ClerksComplaints")
        .child(clerkID)
        .get()
        .then((value) async {
      if (value.exists) {
        print("value clerk new : ${value.value["ClerkID"]}\n");
        await FirebaseDatabase.instance
            .reference()
            .child("Departments")
            .child("Monitor")
            .child("Permissions")
            .child("ClerksComplaints")
            .get()
            .then((value) {
          print("DESCRIPTION : ${value.value["PermissionDescription"]}\n");
          permissionModel = OfficerPermissionModel(value.value["PermissionID"],
              value.value["PermissionDescription"]);
          grantedPermissionModelList.add(permissionModel!);
          print("LIST LENGTH : ${grantedPermissionModelList.length}\n");
        });
      } else {
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

  Future<void> getClerksForClerksComplaintsPermission2(String clerkID) async {
    await FirebaseDatabase.instance
        .reference()
        .child("Departments")
        .child("Monitor")
        .child("Permissions")
        .child("ClerksComplaints")
        .child(clerkID)
        .get()
        .then((value) async {
      if (value.exists) {
        print("value clerk new : ${value.value["ClerkID"]}\n");
        await FirebaseDatabase.instance
            .reference()
            .child("Departments")
            .child("Monitor")
            .child("Permissions")
            .child("ClerksComplaints")
            .get()
            .then((value) {
          print("DESCRIPTION : ${value.value["PermissionDescription"]}\n");
          permissionModel = OfficerPermissionModel(value.value["PermissionID"],
              value.value["PermissionDescription"]);
          grantedPermissionModelList.add(permissionModel!);
          print("LIST LENGTH : ${grantedPermissionModelList.length}\n");
        });
      } else {
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

  Future<void> getClerksForClientsComplaintsPermission(String clerkID) async {
    await FirebaseDatabase.instance
        .reference()
        .child("Departments")
        .child("Monitor")
        .child("Permissions")
        .child("ClientsComplaints")
        .child(clerkID)
        .get()
        .then((value) async {
      if (value.exists) {
        print("value new : ${value.value["ClerkID"]}\n");
        await FirebaseDatabase.instance
            .reference()
            .child("Departments")
            .child("Monitor")
            .child("Permissions")
            .child("ClientsComplaints")
            .get()
            .then((value) {
          print("DESCRIPTION : ${value.value["PermissionDescription"]}\n");
          permissionModel = OfficerPermissionModel(value.value["PermissionID"],
              value.value["PermissionDescription"]);
          grantedPermissionModelList.add(permissionModel!);
          print("LIST LENGTH : ${grantedPermissionModelList.length}\n");
        });
      } else {
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

  Future<void> deletePermissionFromClerk(
      String clerkID, String permissionID) async {
    await FirebaseDatabase.instance
        .reference()
        .child("Departments")
        .child("Monitor")
        .child("Permissions")
        .child(permissionID)
        .child(clerkID)
        .remove()
        .then((value) async => await getPermissions(clerkID))
        .catchError((error) {
      print(error.toString());
      showToast(
          message: error.toString(),
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
    });
    grantedPermissionModelList
        .removeWhere((element) => element.permissionID == permissionID);
    emit(MonitorOfficerPermissionDeletePermissionsState());
  }

  //============== Add Permissions To Clerk ==============
  Future<void> addPermissionToClerk(String clerkID, String managerID) async {
    if (selectedUnGrantedPermissionModelList.isNotEmpty) {
      emit(MonitorOfficerPermissionLoadingAddPermissionsToClerkState());

      for (var permission in selectedUnGrantedPermissionModelList) {
        DateTime now = DateTime.now();
        String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

        Map<String, dynamic> data = HashMap();
        data['ClerkID'] = clerkID;
        data['ManagerID'] = managerID;
        data['givenDate'] = currentFullTime;

        await FirebaseDatabase.instance
            .reference()
            .child("Departments")
            .child("Monitor")
            .child("Permissions")
            .child(permission.permissionID)
            .child(clerkID)
            .set(data)
            .then((value) {})
            .catchError((error) {
          showToast(
              message: error.toString(),
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3);
          emit(MonitorOfficerPermissionAddPermissionsToClerkErrorState(
              error.toString()));
        });
      }
    } else {
      showToast(
          message: "يجب اختيار الصلاحيات اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
    }
  }

  Future<void> getUnGrantedPermissions() async {
    unGrantedPermissionModelList = [];
    emit(MonitorOfficerPermissionLoadingUnGrantedPermissionsState());
    FirebaseDatabase.instance
        .reference()
        .child("Departments")
        .child("Monitor")
        .child("Permissions")
        .once()
        .then((value) {
      value.value.forEach((key, value) async {
        permissionModel = OfficerPermissionModel(
            value["PermissionID"], value["PermissionDescription"]);
        unGrantedPermissionModelList.add(permissionModel!);
      });

      for (var permission in grantedPermissionModelList) {
        print("granted List : ${permission.permissionID}\n");
        unGrantedPermissionModelList.retainWhere(
            (element) => element.permissionID != permission.permissionID);
        print("denied Length : ${unGrantedPermissionModelList.length}\n");
      }
      emit(MonitorOfficerPermissionGetUnGrantedPermissionsState());
    });
  }

  void changePermissionSelect() {
    isPermissionSelected = !isPermissionSelected;
    emit(MonitorOfficerPermissionChangePermissionsSelectState());
  }

  void addClerkToSelect(OfficerPermissionModel permissionModel) {
    selectedUnGrantedPermissionModelList.add(permissionModel);

    emit(MonitorOfficerPermissionAddPermissionsToSelectState());
  }

  void removeUserFromSelect(OfficerPermissionModel permissionModel) {
    selectedUnGrantedPermissionModelList.remove(permissionModel);

    emit(MonitorOfficerPermissionRemovePermissionsFromSelectState());
  }

  //============================================================

  void navigateTo(BuildContext context, route, String officerID) {
    Navigator.push(
        context,
        ScaleTransition1(
            page: route,
            startDuration: const Duration(milliseconds: 1500),
            closeDuration: const Duration(milliseconds: 800),
            type: ScaleTrasitionTypes.bottomRight)).then((value){getPermissions(officerID);});
  }
}
