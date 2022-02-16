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

class CustomerSelectedImagesCubit extends Cubit<CustomerSelectedImagesStates>{
  CustomerSelectedImagesCubit() : super(CustomerSelectedImagesInitialState());

  static CustomerSelectedImagesCubit get(context) => BlocProvider.of(context);

  String userID = "";
  String receiverID = "Future Of Egypt";
  String userName = "";
  String userPhone = "";
  String userPassword = "";
  String userDocType = "";
  String userDocNumber = "";
  String userCity = "";
  String userRegion = "";
  String userImageUrl = "";
  String userToken = "";

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString("CustomerID")!;
    userName = prefs.getString("CustomerName")!;
    userPhone = prefs.getString("CustomerPhone")!;
    userPassword = prefs.getString("CustomerPassword")!;
    userDocType = prefs.getString("CustomerDocType")!;
    userDocNumber = prefs.getString("CustomerDocNumber")!;
    userCity = prefs.getString("CustomerCity")!;
    userRegion = prefs.getString("CustomerRegion")!;
    userImageUrl = prefs.getString("CustomerImage")!;
    userToken = prefs.getString("CustomerToken")!;
  }

  Future uploadMultipleImages(BuildContext context) async {
    emit(CustomerSelectedImagesUploadingState());

    DateTime now = DateTime.now();
    String currentFullTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);
    String currentTime = DateFormat("hh:mm a").format(now);

    var storageRef = FirebaseStorage.instance.ref("Messages").child(userID).child("Future Of Egypt").child(currentFullTime);
    FirebaseDatabase database = FirebaseDatabase.instance;
    var messagesRef = database.reference().child("Messages");

    List<String> urlsList = [];

    Map<String, Object> dataMap = HashMap();

    dataMap['Message'] = "صورة";
    dataMap['ReceiverID'] = "Future Of Egypt";
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

            messagesRef.child(currentFullTime).update(dataMap).then((value) {
              if(Navigator.canPop(context)){
                Navigator.pop(context);
              }
              messageImagesStaticList = [];

              emit(CustomerSelectedImagesUploadSuccessState());
            }).catchError((error) {
              emit(CustomerSelectedImagesUploadErrorState(error.toString()));
            });
          }).catchError((error) {
            emit(CustomerSelectedImagesUploadErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(CustomerSelectedImagesUploadErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(CustomerSelectedImagesUploadErrorState(error.toString()));
      });
    }
  }


}
