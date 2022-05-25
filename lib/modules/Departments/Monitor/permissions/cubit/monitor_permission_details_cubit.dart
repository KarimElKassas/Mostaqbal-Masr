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

import '../../../../../models/firebase_clerk_model.dart';
import 'monitor_permission_details_states.dart';

class MonitorPermissionDetailsCubit
    extends Cubit<MonitorPermissionDetailsStates> {
  MonitorPermissionDetailsCubit()
      : super(MonitorPermissionDetailsInitialState());

  static MonitorPermissionDetailsCubit get(context) => BlocProvider.of(context);

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
  bool gotClerks = false;
  bool gotUnGrantedClerks = false;
  bool zeroClerks = false;
  bool zeroUnGrantedClerks = false;
  bool isUserSelected = false;

  List<ClerkFirebaseModel> clerkList = [];
  List<Object?> clerkSubscriptionsList = [];
  List<ClerkFirebaseModel> filteredClerkList = [];
  List<ClerkFirebaseModel> selectedClerksList = [];
  List<String> selectedClerksIDList = [];
  ClerkFirebaseModel? clerkModel;

  OfficerPermissionModel? permissionModel;
  List<OfficerPermissionModel> grantedPermissionModelList = [];
  List<OfficerPermissionModel> unGrantedPermissionModelList = [];
  List<OfficerPermissionModel> selectedUnGrantedPermissionModelList = [];
  List<String> clerkPermissionList = [];
  ClerkFirebaseModel? clerkFirebaseModel;
  List<ClerkFirebaseModel> clerksModelList = [];
  List<ClerkFirebaseModel> filteredClerksModelList = [];
  List<String> filteredClerksIDList = [];

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

    emit(MonitorPermissionDetailsGetUserDataState());
  }

  Future<void> getPermissionClerks(String permissionID) async {
    gotClerks = false;

    emit(MonitorPermissionDetailsLoadingGetPermissionsState());
    //get clerks in this permission
    FirebaseFirestore.instance
        .collection('Departments')
        .doc('Monitor')
        .collection("Permissions")
        .doc(permissionID)
        .collection("Clerks")
        .snapshots()
        .listen((event) async {
      filteredClerksIDList = [];
      clerksModelList = [];
      filteredClerksModelList = [];
      if (event.docs.isEmpty) {
        zeroClerks = true;
        gotClerks = true;
        emit(MonitorPermissionDetailsGetPermissionsState());
      } else {
        zeroClerks = false;
        //get clerks data
        for (var element in event.docs) {
          Map<String, dynamic> data = element.data();
          FirebaseFirestore.instance
              .collection('Clerks')
              .doc(data["ClerkID"])
              .get()
              .then((value) {

            Map<String, dynamic>? clerkMap = value.data();
            if (clerkMap != null) {
              print("TEST MAP CLERK : ${clerkMap["ClerkName"]}\n");
              print("TEST MAP CLERK ID : ${clerkMap["ClerkID"].toString()}\n");
              clerkFirebaseModel = ClerkFirebaseModel(
                  clerkMap["ClerkID"].toString(),
                  clerkMap["ClerkName"].toString(),
                  clerkMap["ClerkImage"].toString(),
                  clerkMap["ClerkManagementID"].toString(),
                  clerkMap["ClerkJobName"].toString(),
                  clerkMap["ClerkID"].toString(),
                  clerkMap["ClerkAddress"].toString(),
                  clerkMap["ClerkPhone"].toString(),
                  clerkMap["ClerkPassword"].toString(),
                  clerkMap["ClerkState"].toString(),
                  clerkMap["ClerkToken"].toString(),
                  clerkMap["ClerkLastMessage"].toString(),
                  clerkMap["ClerkLastMessageTime"].toString(),
                  clerkMap["ClerkSubscriptions"]);
              clerksModelList.add(clerkFirebaseModel!);
              filteredClerksIDList.add(clerkMap["ClerkID"].toString());
              filteredClerksModelList = clerksModelList.toList();
              final ids = Set();
              filteredClerksModelList.retainWhere((x) => ids.add(x.clerkID));
              gotClerks = true;
              emit(MonitorPermissionDetailsGetPermissionsState());
            }
          });
        }
      }
    });
  }

  void getUnGrantedClerks(String permissionID) async {
    gotUnGrantedClerks = false;

    await getPermissionClerks(permissionID);
    emit(MonitorPermissionDetailsLoadingGetPermissionsState());
    Future.delayed(const Duration(milliseconds: 500)).then((value) async {
      if (filteredClerksIDList.isNotEmpty) {
        FirebaseFirestore.instance
            .collection("Clerks")
            .where("ClerkManagementID", isEqualTo: 1022)
            .where("ClerkID", whereNotIn: filteredClerksIDList)
            .snapshots()
            .listen((value) {
          if (value.size == 0) {
            print("ZERO \n");
            zeroUnGrantedClerks = true;
            emit(MonitorPermissionDetailsGetPermissionsState());
          }else{
            print("########## \n");
            clerksModelList = [];
            filteredClerkList = [];
            for (var element in value.docs) {
              Map<String, dynamic> clerkMap = element.data();
              clerkFirebaseModel = ClerkFirebaseModel(
                  clerkMap["ClerkID"],
                  clerkMap["ClerkName"],
                  clerkMap["ClerkImage"],
                  clerkMap["ClerkManagementID"].toString(),
                  clerkMap["ClerkJobName"],
                  clerkMap["ClerkID"],
                  clerkMap["ClerkAddress"],
                  clerkMap["ClerkPhone"],
                  clerkMap["ClerkPassword"],
                  clerkMap["ClerkState"],
                  clerkMap["ClerkToken"],
                  clerkMap["ClerkLastMessage"],
                  clerkMap["ClerkLastMessageTime"],
                  clerkMap["ClerkSubscriptions"]);

              clerksModelList.add(clerkFirebaseModel!);
              filteredClerkList = clerksModelList.toList();
              final ids = Set();
              filteredClerksModelList.retainWhere((x) => ids.add(x.clerkID));
              gotUnGrantedClerks = true;
              zeroUnGrantedClerks = false;

              emit(MonitorPermissionDetailsGetPermissionsState());
            }
          }

        });
      } else {
        print("************ \n");
        FirebaseFirestore.instance
            .collection("Clerks")
            .where("ClerkManagementID", isEqualTo: 1022)
            .snapshots()
            .listen((value) {
          if (value.size == 0) {
            print("ZERO \n");
            zeroUnGrantedClerks = true;
            emit(MonitorPermissionDetailsGetPermissionsState());
          }
          clerksModelList = [];
          filteredClerkList = [];
          for (var element in value.docs) {
            Map<String, dynamic> clerkMap = element.data();
            clerkFirebaseModel = ClerkFirebaseModel(
                clerkMap["ClerkID"],
                clerkMap["ClerkName"],
                clerkMap["ClerkImage"],
                clerkMap["ClerkManagementID"].toString(),
                clerkMap["ClerkJobName"],
                clerkMap["ClerkID"],
                clerkMap["ClerkAddress"],
                clerkMap["ClerkPhone"],
                clerkMap["ClerkPassword"],
                clerkMap["ClerkState"],
                clerkMap["ClerkToken"],
                clerkMap["ClerkLastMessage"],
                clerkMap["ClerkLastMessageTime"],
                clerkMap["ClerkSubscriptions"]);

            clerksModelList.add(clerkFirebaseModel!);
            filteredClerkList = clerksModelList.toList();
            gotUnGrantedClerks = true;
            zeroUnGrantedClerks = false;

            emit(MonitorPermissionDetailsGetPermissionsState());
          }
        });
      }
    });
  }

  Future<void> deletePermissionFromClerk(
      String clerkID, String permissionID) async {
    FirebaseFirestore.instance
        .collection('Departments')
        .doc('Monitor')
        .collection("Permissions")
        .doc(permissionID)
        .collection("Clerks")
        .doc(clerkID)
        .delete()
        .then((value)async {
      //await getPermissionClerks(permissionID);
      emit(MonitorPermissionDetailsDeletePermissionsState());
    });
  }

  //============== Add Permissions To Clerk ==============
  Future<void> addPermissionToClerk(String permissionID) async {
    if (selectedClerksList.isNotEmpty) {
      emit(MonitorPermissionDetailsLoadingAddPermissionsToClerkState());

      SharedPreferences prefs = await SharedPreferences.getInstance();
      userID = prefs.getString("ClerkID")!;
      for (var clerk in selectedClerksList) {
        DateTime now = DateTime.now();
        String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

        Map<String, dynamic> data = HashMap();
        data['ClerkID'] = clerk.clerkID;
        data['ManagerID'] = userID;
        data['givenDate'] = currentFullTime;
        data['ButtonID'] = "empty";

        CollectionReference departmentsCollection =
            FirebaseFirestore.instance.collection('Departments');
        departmentsCollection
            .doc("Monitor")
            .collection("Permissions")
            .doc(permissionID)
            .collection("Clerks")
            .doc(clerk.clerkID)
            .set(data)
            .then((value) {})
            .catchError((error) {
          showToast(
              message: error.toString(),
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3);
          emit(MonitorPermissionDetailsAddPermissionsToClerkErrorState(
              error.toString()));
        });
      }
    } else {
      showToast(
          message: "يجب اختيار الموظفين اولاً",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
    }
  }

  //============================================================
  void changeUserSelect() {
    isUserSelected = !isUserSelected;
    emit(MonitorPermissionDetailsChangePermissionsSelectState());
  }

  void addClerkToSelect(ClerkFirebaseModel clerkModel) {
    selectedClerksList.add(clerkModel);

    emit(MonitorPermissionDetailsAddPermissionsToSelectState());
  }

  void removeUserFromSelect(ClerkFirebaseModel clerkModel) {
    selectedClerksList.remove(clerkModel);

    emit(MonitorPermissionDetailsRemovePermissionsFromSelectState());
  }

  void searchUser(String value) {
    filteredClerkList = clerkList
        .where(
            (user) => user.clerkName.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredClerkList.length}\n");
    emit(MonitorPermissionDetailsFilterClerksState());
  }

  void navigateTo(BuildContext context, route, String officerID) {
    Navigator.push(
            context,
            ScaleTransition1(
                page: route,
                startDuration: const Duration(milliseconds: 1500),
                closeDuration: const Duration(milliseconds: 800),
                type: ScaleTrasitionTypes.bottomRight))
        .then((value) async {
      /*Future.delayed(const Duration(milliseconds: 500)).then((value) async {
        await getPermissionClerks(officerID);
        emit(MonitorPermissionDetailsSuccessNavigateState());
      });*/
    });
  }
}
