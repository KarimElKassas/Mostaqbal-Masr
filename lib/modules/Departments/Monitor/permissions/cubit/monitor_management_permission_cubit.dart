import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/models/officer_permission_model.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/permissions/cubit/monitor_management_permission_states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';



class MonitorManagementPermissionCubit
    extends Cubit<MonitorManagementPermissionStates> {
  MonitorManagementPermissionCubit()
      : super(MonitorManagementPermissionInitialState());

  static MonitorManagementPermissionCubit get(context) => BlocProvider.of(context);

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
  List<OfficerPermissionModel> permissionModelList = [];
  List<OfficerPermissionModel> selectedUnGrantedPermissionModelList = [];

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

    emit(MonitorManagementPermissionGetUserDataState());
  }

  Future<void> addManagementPermission(String permissionDescription)async {
    emit(MonitorManagementPermissionLoadingAddPermissionsState());

    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userNumber = prefs.getString("ClerkNumber")!;

    CollectionReference departmentsCollection = FirebaseFirestore.instance.collection('Departments');

    Map<String, dynamic> data = HashMap();
    data['PermissionDescription'] = permissionDescription;
    data['PermissionID'] = currentFullTime;
    data['ManagerID'] = userNumber;

    departmentsCollection.doc("Monitor").collection("Permissions").doc(currentFullTime).set(data).then((value){
      emit(MonitorManagementPermissionAddPermissionsSuccessState());
    }).catchError((error){
      print("Error : ${error.toString()}\n");
      emit(MonitorManagementPermissionAddPermissionsErrorState(error.toString()));
    });
  }

  Future<void> getPermissions() async {
    gotPermission = false;
    emit(MonitorManagementPermissionLoadingGetPermissionsState());
    FirebaseFirestore.instance.collection('Departments').doc('Monitor').collection("Permissions").snapshots().listen((event) {
      permissionModelList = [];
      for (var element in event.docs) {
        Map<String, dynamic> data = element.data();
        print("DESC : ${data["PermissionDescription"]}\n");
        permissionModel = OfficerPermissionModel(data["ManagerID"] ,data["PermissionID"], data["PermissionDescription"]);
        permissionModelList.add(permissionModel!);
      }
      gotPermission = true;
      emit(MonitorManagementPermissionGetPermissionsState());
    });

  }
  Future<void> deletePermission(String permissionID) async {
    FirebaseFirestore.instance.collection('Departments').doc('Monitor').collection("Permissions").doc(permissionID).delete().then((value){
      emit(MonitorManagementPermissionDeletePermissionsState());
    });
    /*await FirebaseDatabase.instance
        .reference()
        .child("Departments")
        .child("Monitor")
        .child("Permissions")
        .child(permissionID)
        .child(clerkID)
        .remove()
        .then((value) async => await getPermissions())
        .catchError((error) {
      print(error.toString());
      showToast(
          message: error.toString(),
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
    });
    grantedPermissionModelList
        .removeWhere((element) => element.permissionID == permissionID);*/
  }

  void changePermissionSelect() {
    isPermissionSelected = !isPermissionSelected;
    emit(MonitorManagementPermissionChangePermissionsSelectState());
  }

  void addClerkToSelect(OfficerPermissionModel permissionModel) {
    selectedUnGrantedPermissionModelList.add(permissionModel);

    emit(MonitorManagementPermissionAddPermissionsToSelectState());
  }

  void removeUserFromSelect(OfficerPermissionModel permissionModel) {
    selectedUnGrantedPermissionModelList.remove(permissionModel);

    emit(MonitorManagementPermissionRemovePermissionsFromSelectState());
  }

  //============================================================

  void navigateTo(BuildContext context, route, String officerID) {
    Navigator.push(
        context,
        ScaleTransition1(
            page: route,
            startDuration: const Duration(milliseconds: 1500),
            closeDuration: const Duration(milliseconds: 800),
            type: ScaleTrasitionTypes.bottomRight)).then((value){getPermissions();});
  }

}
