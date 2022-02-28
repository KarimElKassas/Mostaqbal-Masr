import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart' as j;
import 'package:mostaqbal_masr/models/chat_model.dart';
import 'package:mostaqbal_masr/models/group_model.dart';
import 'package:mostaqbal_masr/modules/Customer/screens/customer_selected_images_screen.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/cubit/display_groups_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:mostaqbal_masr/shared/gallery_item_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'group_conversation_states.dart';
import 'group_details_states.dart';

class GroupDetailsCubit extends Cubit<GroupDetailsStates> {
  GroupDetailsCubit() : super(GroupDetailsInitialState());

  static GroupDetailsCubit get(context) => BlocProvider.of(context);

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
    userPhone =  prefs.getString("ClerkPhone");
    userNumber = prefs.getString("ClerkNumber");
    userPassword = prefs.getString("ClerkPassword");
    userManagementName = prefs.getString("ClerkManagementName");
    userTypeName = prefs.getString("ClerkTypeName");
    userRankName = prefs.getString("ClerkRankName");
    userCategoryName = prefs.getString("ClerkCategoryName");
    userCoreStrengthName = prefs.getString("ClerkCoreStrengthName");
    userPresenceName = prefs.getString("ClerkPresenceName");
    userJobName = prefs.getString("ClerkJobName");

    var token = await FirebaseMessaging.instance.getToken();
    await FirebaseDatabase.instance.reference().child("Clerks").child(userPhone!).child("ClerkToken").set(token);
    await prefs.setString("ClerkToken", token!);

    userToken = prefs.getString("ClerkToken");
    userImage = prefs.getString("ClerkImage");

  }

  void getGroups() async {
    emit(GroupDetailsLoadingGroupsState());

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

      emit(GroupDetailsGetGroupsSuccessState());
    }).onError((error) {
      emit(GroupDetailsGetGroupsErrorState(error.toString()));
    });
  }

  void searchGroup(String value){

    filteredGroupList = groupList
        .where(
            (user) => user.groupName.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredGroupList.length}\n");
    emit(GroupDetailsFilterGroupState());

  }

  void goToConversation(BuildContext context, route){

    navigateTo(context, route);

  }
}
