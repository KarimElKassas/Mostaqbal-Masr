import 'dart:collection';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/models/chat_model.dart';
import 'package:mostaqbal_masr/models/display_chat_model.dart';
import 'package:mostaqbal_masr/models/firebase_clerk_model.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/cubit/social_display_chats_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

class SocialDisplayChatsCubit extends Cubit<SocialDisplayChatsStates> {

  SocialDisplayChatsCubit() : super(SocialDisplayChatsInitialState());

  static SocialDisplayChatsCubit get(context) => BlocProvider.of(context);

  DisplayChatModel? displayChatModel;
  ClerkFirebaseModel? clerkModel;
  ChatModel? chatModel;

  List<ClerkFirebaseModel> clerkList = [];
  List<ClerkFirebaseModel> filteredClerkList = [];
  List<DisplayChatModel> chatList = [];
  List<ChatModel> messagesList = [];

  String lastMessage = "";
  String lastMessageTime = "";
  String lastMessageText = "";
  String lastMessageTimeText = "";
  String chatID = "";

  Future<void> createChatList(BuildContext context, String receiverID)async {
    emit(SocialDisplayChatsLoadingCreateChatState());
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
    emit(SocialDisplayChatsCreateChatSuccessState());
  }
  void goToConversation(BuildContext context, route, String receiverID)async {
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
  }

  Future<void> getChats() async {
    emit(SocialDisplayChatsLoadingChatsState());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseFirestore.instance.collection("ChatList").doc(prefs.getString("ClerkID")).collection("Chats").snapshots().listen((event)async {
      chatList.clear();
      clerkList.clear();
      filteredClerkList.clear();
      for (var element in event.docs) {
        if(element.exists){

          Map data = element.data();
          print("DATA ::: $data\n");
          displayChatModel = DisplayChatModel(data["ReceiverID"].toString(),data["ChatID"].toString(),data["LastMessage"].toString(),data["LastMessageTime"].toString(),data["LastMessageType"].toString(),data["LastMessageSender"].toString(),data["UnReadMessagesCount"].toString(),data["PartnerState"].toString());
          await FirebaseFirestore.instance.collection("Clerks").doc(data["ReceiverID"]).get().then((value){
            if(value.exists){
              Map clerk = value.data()!;
              print("Clerk DATA : $clerk\n");
              print("Clerk State : ${data["PartnerState"].toString()}\n");
              clerkModel = ClerkFirebaseModel(clerk["ClerkID"], clerk["ClerkName"], clerk["ClerkImage"], clerk["ClerkManagementID"].toString(), clerk["ClerkJobName"], clerk["ClerkNumber"], clerk["ClerkAddress"], clerk["ClerkPhone"], clerk["ClerkPassword"], clerk["ClerkState"], clerk["ClerkToken"], clerk["ClerkLastMessage"], clerk["ClerkLastMessageTime"], clerk["clerkSubscriptions"]);
              clerkList.add(clerkModel!);
              filteredClerkList = clerkList.toList();
            }
          });
          chatList.add(displayChatModel!);
        }
      }
      print("Chat List Length : ${chatList.length}\n");
      print("User List Length : ${clerkList.length}\n");
      emit(SocialDisplayChatsGetChatsState());
    });
  }

  void searchChat(String value){
    filteredClerkList = clerkList
        .where(
            (user) => user.clerkName.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredClerkList.length}\n");
    emit(SocialDisplayChatsFilterChatsState());

  }
}