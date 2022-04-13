import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/models/group_model.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'display_groups_states.dart';

class DisplayGroupsCubit extends Cubit<DisplayGroupsStates> {
  DisplayGroupsCubit() : super(DisplayGroupsInitialState());

  static DisplayGroupsCubit get(context) => BlocProvider.of(context);

  String? userID = "";
  String? receiverID = "Future Of Egypt";
  String? userName = "";
  String? userPhone = "";
  String? userNumber = "";
  String? userPassword = "";
  String? userManagementName = "";
  String? userCategoryName = "";
  String? userRankName = "";
  String? userTypeName = "";
  String? userCoreStrengthName = "";
  String? userPresenceName = "";
  String? userJobName = "";
  String? userToken = "";
  String? userImage = "";
  String? imageUrl = "";
  GroupModel? groupModel;
  List<GroupModel> groupList = [];
  List<GroupModel> groupListReversed = [];
  List<GroupModel> filteredGroupList = [];
  List<Object?> adminsList = [];
  List<Object?> membersList = [];

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString("ClerkID");
    userName = prefs.getString("ClerkName");
    userNumber = prefs.getString("ClerkNumber");
    userPassword = prefs.getString("ClerkPassword");
    userManagementName = prefs.getString("ClerkManagementName");
    userTypeName = prefs.getString("ClerkTypeName");
    userRankName = prefs.getString("ClerkRankName");
    userCategoryName = prefs.getString("ClerkCategoryName");
    userCoreStrengthName = prefs.getString("ClerkCoreStrengthName");
    userPresenceName = prefs.getString("ClerkPresenceName");
    userJobName = prefs.getString("ClerkJobName");
    userPhone =  prefs.getString("ClerkPhone");

    var token = await FirebaseMessaging.instance.getToken();
    await FirebaseDatabase.instance.reference().child("Clerks").child(prefs.getString("ClerkID")!).child("ClerkToken").set(token);
    await prefs.setString("ClerkToken", token!);

    userToken = prefs.getString("ClerkToken");
    userImage = prefs.getString("ClerkImage");

  }

  void getGroups() async {
    emit(DisplayGroupsLoadingGroupsState());

    await getUserData();

    FirebaseDatabase.instance
        .reference()
        .child('Groups')
        .onValue
        .listen((event) {
      adminsList = [];
      membersList = [];
      groupList.clear();
      groupListReversed.clear();
      filteredGroupList.clear();
      groupModel = null;

      if (event.snapshot.exists) {
        Map data = event.snapshot.value;
        if (data.isNotEmpty) {
          data.forEach((key, val) {

              print('Groups Data INSIDE : ${val["Info"]["GroupName"]}\n');

              adminsList = val["Info"]["Admins"];
              membersList = val["Info"]["Members"];

              groupModel = GroupModel(
                val["Info"]["GroupID"],
                val["Info"]["GroupName"],
                val["Info"]["GroupImageUrl"],
                val["Info"]["GroupLastMessageSenderName"],
                val["Info"]["GroupLastMessage"],
                val["Info"]["GroupLastMessageTime"],
                adminsList,
                membersList
              );
              print("USER  : $userID\n");

              if(membersList.contains(userID) || adminsList.contains(userID)){
                groupList.add(groupModel!);
                groupListReversed = groupList.reversed.toList();
                filteredGroupList = groupList;
                print("GROUPS : $groupList\n");
              }

              print("MEMBERS : $membersList\n");
              print("ADMINS : $adminsList\n");
          });
        }
      }

      emit(DisplayGroupsGetGroupsSuccessState());
    }).onError((error) {
      emit(DisplayGroupsGetGroupsErrorState(error.toString()));
    });
  }

  void searchGroup(String value){

    filteredGroupList = groupList
        .where(
            (user) => user.groupName.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredGroupList.length}\n");
    emit(DisplayGroupsFilterGroupState());

  }

  void goToConversation(BuildContext context, route){
    navigateTo(context, route);
  }
}
