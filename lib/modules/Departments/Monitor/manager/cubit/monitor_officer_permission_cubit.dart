import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool zeroPermissions = false;

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
    zeroPermissions = false;
    emit(MonitorOfficerPermissionLoadingGetPermissionsState());
    FirebaseFirestore.instance.collection('Departments').doc('Monitor').collection("Permissions").snapshots().listen((event) {
      if(event.docs.isEmpty){
        zeroPermissions = true;
      }
      grantedPermissionModelList = [];
      unGrantedPermissionModelList = [];
      for (var element in event.docs) {
        Map<String, dynamic> data = element.data();
          print("DATAAAAAAA : ${data["PermissionDescription"]}\n");

        FirebaseFirestore.instance.collection('Departments').doc('Monitor').collection("Permissions").doc(data["PermissionID"]).collection("Clerks").doc(clerkID).get().then((value){
          if(value.exists){
            print("DESC Data : ${data["PermissionDescription"]}\n");
            permissionModel = OfficerPermissionModel(data["ManagerID"], data["PermissionID"], data["PermissionDescription"]);
            grantedPermissionModelList.add(permissionModel!);
            emit(MonitorOfficerPermissionGetPermissionsState());
          }else{
            print("No Data\n");
            print("DESC No : ${data["PermissionDescription"]}\n");
            permissionModel = OfficerPermissionModel(data["ManagerID"], data["PermissionID"], data["PermissionDescription"]);
            unGrantedPermissionModelList.add(permissionModel!);
            emit(MonitorOfficerPermissionGetPermissionsState());
          }
        });
      }
      gotPermission = true;
      emit(MonitorOfficerPermissionGetPermissionsState());
    });

  }

  Future<void> deletePermissionFromClerk(
      String clerkID, String permissionID) async {
    FirebaseFirestore.instance.collection('Departments').doc('Monitor').collection("Permissions").doc(permissionID).collection("Clerks").doc(clerkID).delete().then((value){
      getPermissions(clerkID);
      emit(MonitorOfficerPermissionDeletePermissionsState());
    });
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
        data['ButtonID'] = "";

        CollectionReference departmentsCollection = FirebaseFirestore.instance.collection('Departments');
        departmentsCollection.doc("Monitor").collection("Permissions").doc(permission.permissionID).collection("Clerks").doc(clerkID).set(data).then((value){

        }).catchError((error){
          showToast(
              message: error.toString(),
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3);
          emit(MonitorOfficerPermissionAddPermissionsToClerkErrorState(error.toString()));
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
            type: ScaleTrasitionTypes.bottomRight)).then((value)async {
              await getPermissions(officerID);
              emit(MonitorOfficerPermissionSuccessNavigateState());
            });
  }
}
