import 'dart:collection';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/models/clerk_model.dart';
import 'package:mostaqbal_masr/models/clerk_model.dart';
import 'package:mostaqbal_masr/models/clerk_model.dart';
import 'package:mostaqbal_masr/models/firebase_clerk_model.dart';
import 'package:mostaqbal_masr/models/user_model.dart';
import 'package:mostaqbal_masr/modules/Global/registration/screens/clerk_registration_screen.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/cubit/home/home_states.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/screens/it_create_group_screen.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/screens/it_group_conversation_screen.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/screens/it_select_group_users_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ITHomeCubit extends Cubit<ITHomeStates>{
  ITHomeCubit() : super(ITHomeInitialState());

  static ITHomeCubit get(context) => BlocProvider.of(context);

  List<UserModel> userList = [];
  List<UserModel> filteredUserList = [];
  List<UserModel> selectedUsersList = [];
  List<String> selectedUsersIDList = [];
  List<String> groupAdminsList = [];
  UserModel? userModel;

  List<ClerkFirebaseModel> clerkList = [];
  List<ClerkFirebaseModel> filteredClerkList = [];
  List<ClerkFirebaseModel> selectedClerksList = [];
  List<String> selectedClerksIDList = [];
  ClerkFirebaseModel? clerkModel;
  
  bool isUserSelected = false;
  bool emptyImage = true;
  String imageUrl = "";
  final ImagePicker imagePicker = ImagePicker();

  void navigateToSelectUsers(BuildContext context){
    navigateTo(context, ITSelectGroupUsersScreen());
  }
  void navigateToCreateClerk(BuildContext context){
    navigateTo(context, ClerkRegistrationScreen());
  }
  void navigateToGroupConversation(BuildContext context, String groupID, String groupName, String groupImage){
    navigateTo(context, ITGroupConversationScreen(groupID: groupID, groupImage: groupImage, groupName: groupName));
  }
  /*void navigateToCreateGroup(BuildContext context)async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = UserModel.encode(selectedUsersList);
    prefs.setString("selectedUsersModelList", encodedData);

    final String userModelString = prefs.getString('selectedUsersModelList')!;
    final List<UserModel> userModelList = UserModel.decode(userModelString);

    navigateTo(context, ITCreateGroupScreen(selectedUsersList: selectedUsersList));
    print("Navigate Selected Users Model List ${selectedUsersList.length}\n");
    print("User Model List Decoded ${userModelList.length}\n");

  }*/
  
  void navigateToCreateClerksGroup(BuildContext context)async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = UserModel.encode(selectedUsersList);
    prefs.setString("selectedClerksModelList", encodedData);

    final String userModelString = prefs.getString('selectedClerksModelList')!;
    final List<UserModel> clerkModelList = UserModel.decode(userModelString);

    navigateTo(context, ITCreateGroupScreen(selectedUsersList: selectedClerksList));
    print("Navigate Selected Clerks Model List ${selectedClerksList.length}\n");
    print("Clerks Model List Decoded ${clerkModelList.length}\n");

  }
  void changeUserSelect(){
    isUserSelected = !isUserSelected;
    emit(ITHomeChangeUsersSelectState());
  }

  void addClerkToSelect(ClerkFirebaseModel clerkModel){

    selectedClerksList.add(clerkModel);

    emit(ITHomeAddUsersSelectState());
  }
  void removeUserFromSelect(ClerkFirebaseModel clerkModel){

    selectedClerksList.remove(clerkModel);

    emit(ITHomeRemoveUsersSelectState());
  }
  Future<void> getUsers() async {
    emit(ITHomeLoadingUsersState());

    FirebaseDatabase.instance
        .reference()
        .child('Clerks')
        .onValue
        .listen((event){

      clerkList.clear();
      filteredClerkList.clear();
      clerkModel = null;
      if(event.snapshot.value != null){
        Map<dynamic, dynamic> values = event.snapshot.value;
        values.forEach((key,user){
          clerkModel = ClerkFirebaseModel(
              user["ClerkID"], user["ClerkName"], user["ClerkImage"], user["ClerkNumber"],
              user["ClerkAddress"], user["ClerkPhone"], user["ClerkPassword"], user["ClerkState"], user["ClerkToken"], user["ClerkLastMessage"], user["ClerkLastMessageTime"]);

          clerkList.add(clerkModel!);
          filteredClerkList = clerkList.toList();
          print("Clerks List Length : ${filteredClerkList.length}\n");
        });
      }

      print("Clerks List Length Out : ${filteredClerkList.length}\n");

      emit(ITHomeGetUsersSuccessState());
    }).onError((handleError){
      emit(ITHomeGetUsersErrorState(handleError.toString()));
    });

  }

  void searchUser(String value){

    filteredClerkList = clerkList
        .where(
            (user) => user.clerkName!.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredClerkList.length}\n");
    emit(ITHomeFilterUsersState());

  }

  void selectImage() async {

    final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);

    imageUrl = image!.path;

    emptyImage = false;

    emit(ITHomeChangeGroupImageState());
  }

  Future<void> createGroup(BuildContext context,String groupName, String adminID)async {
    emit(ITHomeLoadingCreateGroupState());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String clerkModelString = prefs.getString('selectedClerksModelList')!;
    final List<ClerkFirebaseModel> clerkModelList = ClerkFirebaseModel.decode(clerkModelString);

    selectedClerksIDList.clear();
    groupAdminsList.clear();
    groupAdminsList.add(adminID);

    for (var clerkModel in clerkModelList) {
      selectedClerksIDList.add(clerkModel.clerkID!.toString());
    }

    print("Selected Clerks Model List Decoded ${clerkModelList.length}\n");
    print("Selected Clerks ID List Decoded ${selectedClerksIDList.length}\n");

    FirebaseDatabase database = FirebaseDatabase.instance;
    var groupRef = database.reference().child("Groups");
    var storageRef = FirebaseStorage.instance.ref("Groups");

    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd-HH-mm-ss").format(now);

    Map<String, dynamic> dataMap = HashMap();

    dataMap['GroupName'] = groupName;
    dataMap['GroupID'] = currentFullTime;
    dataMap['DateCreated'] = currentFullTime;
    dataMap['Admins'] = groupAdminsList;
    dataMap['Members'] = selectedClerksIDList;

    groupRef.child(currentFullTime).child("Info").set(dataMap).then((value) async {
      String fileName = imageUrl;

      File imageFile = File(fileName);

      var uploadTask = storageRef.child(currentFullTime).putFile(imageFile);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          dataMap['GroupImageUrl'] = value.toString();

          groupRef.child(currentFullTime).child("Info").update(dataMap).then((
              realtimeDbValue) async {

            navigateToGroupConversation(context, currentFullTime, groupName, value.toString());
            emit(ITHomeCreateGroupSuccessState());
          }).catchError((error) {
            emit(ITHomeCreateGroupErrorState(error.toString()));
          });
        });
      });
    });
  }
}