import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel{

  String userID = "";
  String userName = "";
  String userPhone = "";
  String userPassword = "";
  String userCity = "";
  String userRegion = "";
  String userDocType = "";
  String userDocNumber = "";
  String userImage = "";
  String userToken = "";
  String userState = "";
  String userLastMessage = "";
  String userLastMessageTime = "";

  UserModel(this.userID,this.userName,this.userPhone,this.userPassword,this.userCity,this.userRegion,this.userDocType,this.userDocNumber,this.userImage,this.userToken,this.userLastMessage,this.userState,this.userLastMessageTime);

  factory UserModel.fromJson(Map<String, dynamic> jsonData) {
    return UserModel(
        jsonData['UserID'],
        jsonData['UserName'],
        jsonData['UserPhone'],
        jsonData['UserPassword'],
        jsonData['UserCity'],
        jsonData['UserRegion'],
        jsonData['UserDocType'],
        jsonData['UserDocNumber'],
        jsonData['UserImage'],
        jsonData['UserToken'],
        jsonData['UserLastMessage'],
        jsonData['UserState'],
        jsonData['UserLastMessageTime']);
  }

  static Map<String, dynamic> toMap(UserModel userModel) => {
    'UserID': userModel.userID,
    'UserName': userModel.userName,
    'UserPhone': userModel.userPhone,
    'UserPassword': userModel.userPassword,
    'UserCity': userModel.userCity,
    'UserRegion': userModel.userRegion,
    'UserDocType': userModel.userDocType,
    'UserDocNumber': userModel.userDocNumber,
    'UserImage': userModel.userImage,
    'UserToken': userModel.userToken,
    'UserState': userModel.userState,
    'UserLastMessage': userModel.userLastMessage,
    'UserLastMessageTime': userModel.userLastMessageTime,
  };

  static String encode(List<UserModel> musics) => json.encode(
    musics
        .map<Map<String, dynamic>>((music) => UserModel.toMap(music))
        .toList(),
  );

  static List<UserModel> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<UserModel>((item) => UserModel.fromJson(item))
          .toList();

}