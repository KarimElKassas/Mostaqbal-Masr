import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/models/chat_model.dart';
import 'package:mostaqbal_masr/models/display_chat_model.dart';
import 'package:mostaqbal_masr/models/user_model.dart';
import 'package:mostaqbal_masr/modules/Departments/SocialMedia/chat/cubit/social_display_chats_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class SocialDisplayChatsCubit extends Cubit<SocialDisplayChatsStates> {

  SocialDisplayChatsCubit() : super(SocialDisplayChatsInitialState());

  static SocialDisplayChatsCubit get(context) => BlocProvider.of(context);

  DisplayChatModel? displayChatModel;
  UserModel? userModel;
  ChatModel? chatModel;

  List<UserModel> userList = [];
  List<UserModel> filteredUserList = [];
  List<DisplayChatModel> chatList = [];
  List<ChatModel> messagesList = [];

  String lastMessage = "";
  String lastMessageTime = "";
  String lastMessageText = "";
  String lastMessageTimeText = "";

  void goToConversation(BuildContext context, route) {
    navigateTo(context, route);
  }

  Future<void> getChats() async {
    emit(SocialDisplayChatsLoadingChatsState());

    await FirebaseDatabase.instance
        .reference()
        .child('ChatList')
        .child("Future Of Egypt")
        .once()
        .then((snapshot){
      Map<dynamic, dynamic> values = snapshot.value;

      chatList.clear();
      values.forEach((key,user){

        displayChatModel = DisplayChatModel(user["ReceiverID"]);
        chatList.add(displayChatModel!);
      });

    });

    FirebaseDatabase.instance
        .reference()
        .child('Clients')
        .onValue
        .listen((event){
        Map<dynamic, dynamic> values = event.snapshot.value;

          userList.clear();
          filteredUserList.clear();
          userModel = null;
          values.forEach((key,user){

            userModel = UserModel(user["ClientID"],user["ClientName"],user["ClientPhone"],user["ClientPassword"],user["ClientCity"],user["ClientRegion"],user["ClientDocType"],user["ClientDocNumber"],user["ClientImage"],user["ClientToken"],user["ClientLastMessage"],user["ClientState"],user["ClientLastMessageTime"]);

            for (var list in chatList) {
              //Toast.makeText(context,users.getUser_ID() + "\n" + chatList.getUser_ID(),Toast.LENGTH_SHORT).show();
              print("Chat List Length For Loop : ${chatList.length}\n");

              if (userModel!.userID == list.userID) {
                userList.add(userModel!);
                filteredUserList = userList.toList();
              }
            }

          });
        print("Chat List Length : ${chatList.length}\n");
        print("User List Length : ${userList.length}\n");
        emit(SocialDisplayChatsGetChatsState());
    });
  }

  void searchChat(String value){

    filteredUserList = userList
        .where(
            (user) => user.userName.toLowerCase().contains(value.toString()))
        .toList();
    print("${filteredUserList.length}\n");
    emit(SocialDisplayChatsFilterChatsState());

  }
}