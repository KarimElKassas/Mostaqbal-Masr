import 'dart:collection';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_selected_images_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'group_selected_images_states.dart';

class GroupSelectedImagesCubit extends Cubit<GroupSelectedImagesStates>{
  GroupSelectedImagesCubit() : super(GroupSelectedImagesInitialState());

  static GroupSelectedImagesCubit get(context) => BlocProvider.of(context);

  String userID = "";
  String receiverID = "Future Of Egypt";
  String userName = "";
  String userPhone = "";
  String userNumber = "";
  String userPassword = "";
  String userManagementName = "";
  String userCategoryName = "";
  String userRankName = "";
  String userTypeName = "";
  String userCoreStrengthName = "";
  String userPresenceName = "";
  String userJobName = "";
  String userToken = "";
  String userImage = "";

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString("ClerkID")!;
    userName = prefs.getString("ClerkName")!;
    userPhone = prefs.getString("ClerkPhone")!;
    userNumber = prefs.getString("ClerkNumber")!;
    userPassword = prefs.getString("ClerkPassword")!;
    userManagementName = prefs.getString("ClerkManagementName")!;
    userTypeName = prefs.getString("ClerkTypeName")!;
    userRankName = prefs.getString("ClerkRankName")!;
    userCategoryName = prefs.getString("ClerkCategoryName")!;
    userCoreStrengthName = prefs.getString("ClerkCoreStrengthName")!;
    userPresenceName = prefs.getString("ClerkPresenceName")!;
    userJobName = prefs.getString("ClerkJobName")!;
    userToken = prefs.getString("ClerkToken")!;
    userImage = prefs.getString("ClerkImage")!;
  }

  Future uploadMultipleImages(BuildContext context, String groupID) async {
    emit(GroupSelectedImagesUploadingState());

    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String currentTime = DateFormat("hh:mm a").format(now);

    var storageRef = FirebaseStorage.instance.ref("Groups").child(groupID).child("Media");
    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Groups").child(groupID).child("Messages").child(currentFullTime);
    String currentFullTime1 =
    DateFormat("yyyy-MM-dd-HH-mm-ss").format(DateTime.now());
    List<String> urlsList = [];

    Map<String, Object> dataMap = HashMap();

    dataMap['Message'] = "صورة";
    dataMap['SenderID'] = userID;
    dataMap['SenderName'] = userName;
    dataMap['SenderImage'] = userImage;
    dataMap['groupID'] = groupID;
    dataMap['fileName'] = "";
    dataMap["isSeen"] = false;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["type"] = "Image";
    dataMap["hasImages"] = true;

    //for (int i = 0; i < messageImagesStaticList!.length; i++) {
      messagesRef.set(dataMap).then((value) async {
        String fileName = messageImagesStaticList![0].path.toString();
        File imageFile = File(fileName);

        var uploadTask = storageRef.child(fileName).putFile(imageFile);
        await uploadTask.then((p0) {
          p0.ref.getDownloadURL().then((value) {
            urlsList.add(value.toString());

            dataMap["fileName"] = value.toString();
            dataMap["messageImages"] = urlsList;

            messagesRef.update(dataMap).then((value) {
              if(Navigator.canPop(context)){
                Navigator.pop(context);
              }
              messageImagesStaticList = [];

              emit(GroupSelectedImagesUploadSuccessState());
            }).catchError((error) {
              emit(GroupSelectedImagesUploadErrorState(error.toString()));
            });
          }).catchError((error) {
            emit(GroupSelectedImagesUploadErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(GroupSelectedImagesUploadErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(GroupSelectedImagesUploadErrorState(error.toString()));
      });
    //}
  }


}
