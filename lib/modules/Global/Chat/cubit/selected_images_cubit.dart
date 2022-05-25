import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  String userID = "";
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

  Future uploadMultipleImagesFireStore(BuildContext context, String receiverID, String chatID) async{
    emit(SocialSelectedImagesUploadingState());
    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String currentTime = DateFormat("hh:mm a").format(now);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID = prefs.getString("ClerkID")!;

    var storageRef = FirebaseStorage.instance.ref("Chats").child(chatID).child(currentFullTime);
    var ref = FirebaseFirestore.instance.collection("Chats").doc(chatID).collection("Messages").doc(currentFullTime);

    List<String> urlsList = [];

    Map<String, Object> dataMap = HashMap();

    dataMap['Message'] = "صورة";
    dataMap['ReceiverID'] = receiverID;
    dataMap['SenderID'] = userID;
    dataMap['fileName'] = "";
    dataMap["isSeen"] = false;
    dataMap["messageTime"] = currentTime;
    dataMap["messageFullTime"] = currentFullTime;
    dataMap["messageImages"] = ["emptyList"];
    dataMap["type"] = "Image";
    dataMap["hasImages"] = true;
    dataMap["createdAt"] = Timestamp.now();
    dataMap["imagesCount"] = messageImagesStaticList!.length;

    for (int i = 0; i < messageImagesStaticList!.length; i++) {
      ref.set(dataMap).then((value) async {
        String fileName = messageImagesStaticList![i].path.toString();
        uploadingImagesMessageID = currentFullTime;
        imagesUploaded = false;

        File imageFile = File(fileName);

        var uploadTask = storageRef.child(fileName).putFile(imageFile);
        await uploadTask.then((p0) {
          p0.ref.getDownloadURL().then((value) {
            urlsList.add(value.toString());

            dataMap["messageImages"] = urlsList;
            dataMap['fileName'] = urlsList[0].toString();

            ref.update(dataMap).then((value){
              messageImagesStaticList = [];
              uploadingImagesMessageID = "";
              imagesUploaded = true;
              emit(SocialSelectedImagesUploadSuccessState());
            }).catchError((error){
              uploadingImagesMessageID = "";
              imagesUploaded = true;
              emit(SocialSelectedImagesUploadErrorState(error.toString()));
            });
          }).catchError((error) {
            uploadingImagesMessageID = "";
            imagesUploaded = true;
            emit(SocialSelectedImagesUploadErrorState(error.toString()));
          });
        }).catchError((error) {
          uploadingImagesMessageID = "";
          imagesUploaded = true;
          emit(SocialSelectedImagesUploadErrorState(error.toString()));
        });
      }).catchError((error) {
        uploadingImagesMessageID = "";
        imagesUploaded = true;
        emit(SocialSelectedImagesUploadErrorState(error.toString()));
      });
    }
  }

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
