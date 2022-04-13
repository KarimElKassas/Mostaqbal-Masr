import 'dart:collection';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../shared/constants.dart';
import 'selected_images_states.dart';

class SocialSelectedImagesCubit extends Cubit<SocialSelectedImagesStates>{
  SocialSelectedImagesCubit() : super(SocialSelectedImagesInitialState());

  static SocialSelectedImagesCubit get(context) => BlocProvider.of(context);

  String userID = "Future Of Egypt";
  String receiverID = "";
  String userName = "";
  String userPhone = "";
  String userPassword = "";
  String userDocType = "";
  String userDocNumber = "";
  String userCity = "";
  String userRegion = "";
  String userImageUrl = "";
  String userToken = "";


  Future uploadMultipleImages(BuildContext context, String receiverID) async {
    emit(SocialSelectedImagesUploadingState());

    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String currentTime = DateFormat("hh:mm a").format(now);

    var storageRef = FirebaseStorage.instance.ref("Messages").child(userID).child("Future Of Egypt").child(currentFullTime);
    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Messages");

    List<String> urlsList = [];

    Map<String, Object> dataMap = HashMap();

    dataMap['Message'] = "صورة";
    dataMap['ReceiverID'] = receiverID;
    dataMap['SenderID'] = userID;
    dataMap['fileName'] = "";
    dataMap["isSeen"] = false;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["type"] = "Image";
    dataMap["hasImages"] = true;

    for (int i = 0; i < messageImagesStaticList!.length; i++) {
      messagesRef.child(currentFullTime).set(dataMap).then((value) async {
        String fileName = messageImagesStaticList![i].path.toString();

        File imageFile = File(fileName);

        var uploadTask = storageRef.child(fileName).putFile(imageFile);
        await uploadTask.then((p0) {
          p0.ref.getDownloadURL().then((value) {
            urlsList.add(value.toString());

            dataMap["messageImages"] = urlsList;
            dataMap['fileName'] = urlsList[0].toString();

            messagesRef.child(currentFullTime).update(dataMap).then((value) {
              if(Navigator.canPop(context)){
                Navigator.pop(context);
              }
              messageImagesStaticList = [];

              emit(SocialSelectedImagesUploadSuccessState());
            }).catchError((error) {
              emit(SocialSelectedImagesUploadErrorState(error.toString()));
            });
          }).catchError((error) {
            emit(SocialSelectedImagesUploadErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(SocialSelectedImagesUploadErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(SocialSelectedImagesUploadErrorState(error.toString()));
      });
    }
  }
}
