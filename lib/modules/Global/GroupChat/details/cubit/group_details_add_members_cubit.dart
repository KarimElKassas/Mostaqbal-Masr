import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/models/firebase_clerk_model.dart';
import 'package:mostaqbal_masr/models/group_model.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/details/screens/groupMediaScreen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'group_details_add_members_states.dart';


class GroupDetailsAddMembersCubit extends Cubit<GroupDetailsAddMembersStates> {
  GroupDetailsAddMembersCubit() : super(GroupDetailsAddMembersInitialState());

  static GroupDetailsAddMembersCubit get(context) => BlocProvider.of(context);

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
  List messagesHasImages = [];

  List<ClerkFirebaseModel> clerkList = [];
  List<ClerkFirebaseModel> filteredClerkList = [];
  List<ClerkFirebaseModel> selectedClerksList = [];
  List<ClerkFirebaseModel> difference = [];
  List<Object?> clerkSubscriptionsList = [];
  bool isClerkSelected = false;

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
    await FirebaseDatabase.instance
        .reference()
        .child("Clerks")
        .child(userPhone!)
        .child("ClerkToken")
        .set(token);
    await prefs.setString("ClerkToken", token!);

    userToken = prefs.getString("ClerkToken");
    userImage = prefs.getString("ClerkImage");
  }

  void searchUser(String value) {
    filteredClerkList = clerkList
        .where(
            (user) => user.clerkName!.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredClerkList.length}\n");
    emit(GroupDetailsAddMembersFilterClerkState());
  }

  void changeUserSelect() {
    isClerkSelected = !isClerkSelected;
    emit(GroupDetailsAddMembersChangeClerkSelectState());
  }

  void addClerkToSelect(ClerkFirebaseModel clerkModel) {
    selectedClerksList.add(clerkModel);

    emit(GroupDetailsAddMembersAddClerkToSelectState());
  }

  void removeUserFromSelect(ClerkFirebaseModel clerkModel) {
    selectedClerksList.remove(clerkModel);

    emit(GroupDetailsAddMembersRemoveClerkFromSelectState());
  }

  ClerkFirebaseModel? clerkModel;

  Future<void> getUsers(List<ClerkFirebaseModel> membersList) async {
    emit(GroupDetailsAddMembersLoadingClerksState());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseDatabase.instance
        .reference()
        .child('Clerks')
        .onValue
        .listen((event) {
      clerkList.clear();
      clerkSubscriptionsList = [];
      filteredClerkList.clear();
      clerkModel = null;
      if (event.snapshot.value != null) {
        Map values = event.snapshot.value;
        values.forEach((key, user) {
          user["ClerkSubscriptions"].forEach((group) {
            clerkSubscriptionsList.add(group);
          });

          clerkModel = ClerkFirebaseModel(
              user["ClerkID"],
              user["ClerkName"],
              user["ClerkImage"],
              user["ClerkManagementID"],
              user["ClerkNumber"],
              user["ClerkAddress"],
              user["ClerkPhone"],
              user["ClerkPassword"],
              user["ClerkState"],
              user["ClerkToken"],
              user["ClerkLastMessage"],
              user["ClerkLastMessageTime"],
              clerkSubscriptionsList);
          clerkList.add(clerkModel!);

          filteredClerkList = difference.toList();
          for (var value in membersList) {
            if (clerkList.contains(value)) {
              print("CONTAINS TRUE ${value.clerkID}\n");
              clerkList.remove(value);
            }
          }
          //filteredClerkList = clerkList.toList();
        });
      }
      filteredClerkList = clerkList.toSet().difference(membersList.toSet()).toList();
      print("Clerks List Length : ${filteredClerkList.length}\n");
      //print("Difference List Length : ${difference.length}\n");
      emit(GroupDetailsAddMembersGetClerksState());
    });
  }

  Future<void> getClerkInfo(List<Object?> membersIDList) async {
    emit(GroupDetailsAddMembersLoadingMembersInfoState());
    membersinfolist = [];
    print('testttttttttttttt : ${membersIDList}\n');
    for (var element in membersIDList) {
      await FirebaseDatabase.instance
          .reference()
          .child('Clerks')
          .child(element.toString())
          .get()
          .then((event) {
        clerkModel = ClerkFirebaseModel(
            event.value["ClerkID"],
            event.value["ClerkName"],
            event.value["ClerkImage"],
            event.value["ClerkManagementID"],
            event.value["PersonNumber"],
            event.value["PersonAddress"],
            event.value["PersonPhone"],
            event.value["PersonPassword"],
            event.value["PersonState"],
            event.value["PersonToken"],
            event.value["CategoryLastMessage"],
            event.value["CategoryLastMessageTime"],
            event.value["ClerkSubscriptions"]);
        print("DATA DETAILS : ${event.value["ClerkName"]}\n");
        print('tesssssssss : ${membersinfolist.length}\n');
        membersinfolist.add(clerkModel!);
      });
    }
    print('tesssssssss : ${membersinfolist.length}\n');
    print('tesssssssss : ${membersinfolist.length}\n');

    emit(GroupDetailsAddMembersMembersInfoState());
  }

  void getAdmins(String clerkID, String groupID) {
    FirebaseDatabase.instance
        .reference()
        .child("Groups")
        .child(groupID)
        .child("Admins")
        .get()
        .then((value) {
      List<Object?> data = value.value;

      data.forEach((element) {});
    });
  }

  Future<void> getGroupMedia(String groupId) async {
    emit(GroupDetailsAddMembersLoadingMediaState());
    messagesHasImages = [];
    await FirebaseDatabase.instance
        .reference()
        .child('Groups')
        .child(groupId)
        .child('Messages')
        .get()
        .then((event) {
      Map data = event.value;
      data.forEach((key, value) {
        if (value["hasImages"] == true) {
          print("Images : ${value["messageImages"][0]}\n");
          messagesHasImages.add(value["messageImages"][0]);
        }
      });
      print("LIST OF IMAGES LENGTH ### : ${messagesHasImages.length}\n");
      print("LIST OF IMAGES LENGTH ### : ${messagesHasImages[0]}\n");
    });
    emit(GroupDetailsAddMembersGetMediaState());
  }

  void goToMediaGroup(context, String groupName) {
    navigateTo(context,
        GroupMediaScreen(images: messagesHasImages, groupname: groupName));
  }
}
