import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
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
import 'package:mostaqbal_masr/modules/Global/Login/login_screen.dart';
import 'package:mostaqbal_masr/modules/Global/registration/screens/clerk_registration_screen.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/cubit/home/home_states.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/screens/it_create_group_screen.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/screens/it_group_conversation_screen.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/screens/it_select_group_users_screen.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
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
  List<Object?> clerkSubscriptionsList = [];
  List<ClerkFirebaseModel> filteredClerkList = [];
  List<ClerkFirebaseModel> selectedClerksList = [];
  List<String> selectedClerksIDList = [];
  ClerkFirebaseModel? clerkModel;
  
  bool isUserSelected = false;
  bool emptyImage = true;
  String imageUrl = "";
  final ImagePicker imagePicker = ImagePicker();
  double? loginLogID;

  void navigateToSelectUsers(BuildContext context){
    navigateTo(context, ITSelectGroupUsersScreen());
  }
  Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginLogID = prefs.getDouble("Login_Log_ID");
    print("Login Log ID $loginLogID");

    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

    await DioHelper.updateData(url: 'loginlog/PutWithParams', query: {
      'Login_Log_ID': loginLogID!.toInt(),
      'Login_Log_TDate': formattedDate,
    }).then((value)async {
      await prefs.remove("Login_Log_ID");
      await prefs.remove("LoginDate");
      await prefs.remove("Section_User_ID");
      await prefs.remove("Section_ID");
      await prefs.remove("Section_Name");
      await prefs.remove("Section_Forms_Name_List");
      await prefs.remove("User_ID");
      await prefs.remove("User_Name");
      await prefs.remove("User_Password");
      await prefs.remove("ClerkName");
      await prefs.remove("ClerkPhone");
      await prefs.remove(
          "ClerkNumber");
      await prefs.remove(
          "ClerkPassword");
      await prefs.remove(
          "ClerkImage");
      await prefs.remove(
          "ClerkManagementName");
      await prefs.remove(
          "ClerkTypeName");
      await prefs.remove(
          "ClerkRankName");
      await prefs.remove(
          "ClerkCategoryName");
      await prefs.remove("ClerkCoreStrengthName");
      await prefs.remove(
          "ClerkPresenceName");
      await prefs.remove(
          "ClerkJobName");
      await prefs.remove("ClerkToken");
      await prefs.remove("CustomerID");
      await prefs.remove("CustomerName");
      await prefs.remove("CustomerRegion");
      await prefs.remove("CustomerCity");
      await prefs.remove("CustomerPhone");
      await prefs.remove("CustomerPassword");
      await prefs.remove("CustomerToken");
      await prefs.remove("CustomerImage");
      await prefs.remove("CustomerDocType");
      await prefs.remove("CustomerDocNumber");
      await prefs.remove("UserType");

      showToast(message: "تم تسجيل الخروج بنجاح",
          length: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3);
      navigateAndFinish(context, LoginScreen());
      emit(ITHomeLogOutUserState());
    }).catchError((error) {

      if(error is DioError){
        emit(ITHomeLogOutErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      }else{
        emit(ITHomeLogOutErrorState(error.toString()));
      }

    });
  }

  void navigateToCreateClerk(BuildContext context){
    navigateTo(context, ClerkRegistrationScreen());
  }
  void navigateToGroupConversation(BuildContext context, String groupID, String groupName, String groupImage){
    navigateTo(context, ITGroupConversationScreen(groupID: groupID, groupImage: groupImage, groupName: groupName));
  }

  void navigateToCreateClerksGroup(BuildContext context)async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = ClerkFirebaseModel.encode(selectedClerksList);
    prefs.setString("selectedClerksModelList", encodedData);

    final String userModelString = prefs.getString('selectedClerksModelList')!;
    final List<ClerkFirebaseModel> clerkModelList = ClerkFirebaseModel.decode(userModelString);

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
      clerkSubscriptionsList = [];
      filteredClerkList.clear();
      clerkModel = null;
      if(event.snapshot.value != null){
        Map values = event.snapshot.value;
        values.forEach((key,user){

          user["ClerkSubscriptions"].forEach((group){
            clerkSubscriptionsList.add(group);
          });
          
          clerkModel = ClerkFirebaseModel(
              user["ClerkID"], user["ClerkName"], user["ClerkImage"], user["ClerkNumber"],
              user["ClerkAddress"], user["ClerkPhone"], user["ClerkPassword"], user["ClerkState"], user["ClerkToken"], user["ClerkLastMessage"], user["ClerkLastMessageTime"],clerkSubscriptionsList);
          
          

          clerkList.add(clerkModel!);
          filteredClerkList = clerkList.toList();
          print("Clerks List Length : ${filteredClerkList.length}\n");
        });
      }

      print("Clerks List Length Out : ${filteredClerkList.length}\n");

      emit(ITHomeGetUsersSuccessState());
    })/*.catchError((handleError){
      emit(ITHomeGetUsersErrorState(handleError.toString()));
    })*/;

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

  Future<void> createGroup(BuildContext context,String groupName)async {
    emit(ITHomeLoadingCreateGroupState());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String clerkPhone = prefs.getString("ClerkPhone")!;
    final String clerkModelString = prefs.getString('selectedClerksModelList')!;
    final List<ClerkFirebaseModel> clerkModelList = ClerkFirebaseModel.decode(clerkModelString);

    selectedClerksIDList.clear();
    groupAdminsList.clear();
    groupAdminsList.add(clerkPhone);

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
    dataMap['GroupLastMessageSenderName'] = "";
    dataMap['GroupLastMessage'] = "";
    dataMap['GroupLastMessageTime'] = "";

    groupRef.child(currentFullTime).child("Info").set(dataMap).then((value) async {
      String fileName = imageUrl;

      File imageFile = File(fileName);

      var uploadTask = storageRef.child(currentFullTime).putFile(imageFile);
      await uploadTask.then((p0) {
        p0.ref.getDownloadURL().then((value) {
          dataMap['GroupImageUrl'] = value.toString();

          groupRef.child(currentFullTime).child("Info").update(dataMap).then((
              realtimeDbValue) async {
            clerkSubscriptionsList = [];
            clerkSubscriptionsList.add(currentFullTime);
            for (var element in selectedClerksIDList) {
              Map<int, Object?> map = clerkSubscriptionsList.asMap();
              Map<String, Object?> stringMap = <String, Object?>{};

              map.forEach((key, value) {
                stringMap.putIfAbsent(key.toString(), () => value);
              });

             await FirebaseDatabase.instance.reference().child("Clerks").child(element).child("ClerkSubscriptions")
              .get().then((value){

                value.value.forEach((group){
                  print("GROUP : $group\n");
                  clerkSubscriptionsList.add(group);
                });

              });
              List<String> filtered = LinkedHashSet<String>.from(clerkSubscriptionsList).toList();
              clerkSubscriptionsList.toSet().toList();
              FirebaseDatabase.instance.reference().child("Clerks").child(element).child("ClerkSubscriptions")
              .set(filtered);

              for (var element in filtered) {

                await FirebaseMessaging.instance.subscribeToTopic(element);

              }
              print("Clerk List After Set : ${filtered.length}\n");
            }

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