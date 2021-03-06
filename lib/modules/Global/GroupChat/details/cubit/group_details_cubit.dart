import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/models/firebase_clerk_model.dart';
import 'package:mostaqbal_masr/models/group_model.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/details/screens/groupMediaScreen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/group_details_add_members_screen.dart';
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
  List<ClerkFirebaseModel> membersinfolist = [];
  List messagesHasImages =[];


  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString("ClerkID");
    userName = prefs.getString("ClerkName");
    userPhone = prefs.getString("ClerkPhone");
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
    await FirebaseDatabase.instance.reference().child("Clerks").child(
        userPhone!).child("ClerkToken").set(token);
    await prefs.setString("ClerkToken", token!);

    userToken = prefs.getString("ClerkToken");
    userImage = prefs.getString("ClerkImage");
  }

  ClerkFirebaseModel? clerkModel;

  Future<void> getClerkInfo(List<Object?> membersIDList) async{
    emit(GroupDetailsLoadingMembersInfoState());
    membersinfolist =[];
    print('testttttttttttttt : ${membersIDList}\n');
     for (var element in membersIDList) {
       await FirebaseDatabase.instance.reference().child('Clerks').child(element.toString()).get().then((event) {
         clerkModel = ClerkFirebaseModel(event.value["ClerkID"], event.value["ClerkName"], event.value["ClerkImage"], event.value["ClerkManagementID"],event.value["ClerkJobName"], event.value["PersonNumber"], event.value["PersonAddress"], event.value["PersonPhone"], event.value["PersonPassword"], event.value["PersonState"], event.value["PersonToken"], event.value["CategoryLastMessage"], event.value["CategoryLastMessageTime"], event.value["ClerkSubscriptions"]);
         print("DATA DETAILS : ${event.value["ClerkName"]}\n");
         print('tesssssssss : ${membersinfolist.length}\n');
         membersinfolist.add(clerkModel!);
      });
    }
    print('tesssssssss : ${membersinfolist.length}\n');
    print('tesssssssss : ${membersinfolist.length}\n');

    emit(GroupDetailsMembersInfoState());

  }

  void goToAddMembers(BuildContext context,String groupID){
    navigateTo(context, GroupDetailsAddMembersScreen(groupID: groupID,membersList: membersinfolist,));
  }

  Future<void> getGroupMedia(String groupId)async{
    emit(GroupDetailsLoadingMediaState());
    messagesHasImages =[];
   await FirebaseDatabase.instance.reference().child('Groups').child(groupId).child('Messages').get().then((event){
     Map data = event.value;
     data.forEach((key, value) {
       if(value["hasImages"] == true){
         print("Images : ${value["messageImages"][0]}\n");
         messagesHasImages.add(value["messageImages"][0]);
       }
     });
     print("LIST OF IMAGES LENGTH ### : ${messagesHasImages.length}\n");
     print("LIST OF IMAGES LENGTH ### : ${messagesHasImages[0]}\n");

   });
    emit(GroupDetailsGetMediaState());
  }

  void goToMediaGroup (context,String groupName){
    navigateTo(context, GroupMediaScreen(images: messagesHasImages,groupname: groupName));
  }
}