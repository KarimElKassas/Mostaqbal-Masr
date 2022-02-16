import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/models/display_chat_model.dart';
import 'package:mostaqbal_masr/models/user_model.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/cusomer_display_chats_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDisplayChatsCubit extends Cubit<CustomerDisplayChatsStates> {

  CustomerDisplayChatsCubit() : super(CustomerDisplayChatsInitialState());

  static CustomerDisplayChatsCubit get(context) => BlocProvider.of(context);

  DisplayChatModel? displayChatModel;
  UserModel? userModel;

  List<UserModel> userList = [];
  List<DisplayChatModel> chatList = [];


  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("UserType") == null) {
      customerLogged = false;
      emit(CustomerDisplayChatsGetUserTypeState());
    } else {
      if (prefs.getString("UserType") == "Customer") {

        customerLogged = true;
        emit(CustomerDisplayChatsGetUserTypeState());
      }else{
        customerLogged = false;
        emit(CustomerDisplayChatsGetUserTypeState());
      }
    }
  }

  void goToConversation(BuildContext context, route) {
    navigateTo(context, route);
  }

  Future<void> getChats() async {
    emit(CustomerDisplayChatsLoadingChatsState());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(customerLogged){
      await FirebaseDatabase.instance
          .reference()
          .child('ChatList')
          .child(prefs.getString("CustomerID")!)
          .once()
          .then((snapshot){
        Map<dynamic, dynamic> values = snapshot.value;

        chatList.clear();
        values.forEach((key,user){

          displayChatModel = DisplayChatModel(user["ReceiverID"]);
          chatList.add(displayChatModel!);

        });

      });


      await FirebaseDatabase.instance
          .reference()
          .child('Users')
          .once()
          .then((snapshot){
        Map<dynamic, dynamic> values = snapshot.value;

        userList.clear();
        values.forEach((key,user){

          userModel = UserModel(user["UserID"],user["UserName"],user["UserPhone"],user["UserPassword"],user["UserCity"],user["UserRegion"],user["UserDocType"],user["UserDocNumber"],user["UserImage"],user["UserToken"],user["UserLastMessage"],user["UserState"],user["UserLastMessageTime"]);


          for (var list in chatList) {
            //Toast.makeText(context,users.getUser_ID() + "\n" + chatList.getUser_ID(),Toast.LENGTH_SHORT).show();
            print("Chat List Length For Loop : ${chatList.length}\n");

            if (userModel!.userID == list.userID) {
              userList.add(userModel!);
            }
          }
        });
        print("Chat List Length : ${chatList.length}\n");
        print("Chat List Length : ${userList.length}\n");
        emit(CustomerDisplayChatsGetChatsState());
      });
    }else{



    }



  }
}