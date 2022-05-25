import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/deparment_core/cubit/core_clerk_details_states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CoreClerkDetailsCubit extends Cubit<CoreClerkDetailsStates> {
  CoreClerkDetailsCubit() : super(CoreClerkDetailsInitialState());

  static CoreClerkDetailsCubit get(context) => BlocProvider.of(context);

  String chatID = "";

  void callPerson(String phoneNumber){
    launch("tel://$phoneNumber");
  }

  Future<void> createChatList(BuildContext context, String receiverID)async {
    emit(CoreClerkDetailsLoadingCreateChatState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance.collection("ChatList").doc(prefs.getString("ClerkID")).collection("Chats").doc(receiverID).get().then((value){
      if(value.exists){
        Map data = value.data()!;
        chatID = data["ChatID"];
      }else{
        chatID = Random().nextInt(10000).toString();
        Map<String, dynamic> chatListMap = HashMap();
        chatListMap['ReceiverID'] = receiverID;
        chatListMap['ChatID'] = chatID;
        chatListMap['LastMessage'] = "";
        chatListMap['LastMessageType'] = "";
        chatListMap['LastMessageTime'] = "";
        chatListMap['LastMessageSender'] = "";
        FirebaseFirestore.instance.collection("ChatList").doc(prefs.getString("ClerkID")).collection("Chats").doc(receiverID).set(chatListMap).then((value){
          FirebaseFirestore.instance.collection("ChatList").doc(receiverID).collection("Chats").doc(prefs.getString("ClerkID")).set(chatListMap).then((value){
            print("CHAT ID IN CORE CLERK DETAILS CUBIT : $chatID\n");
          });
        });
      }
    });
    emit(CoreClerkDetailsCreateChatSuccessState());
  }
  void navigate(BuildContext context, route, chatID){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
    emit(CoreClerkDetailsNavigateSuccessState());
  }
}
