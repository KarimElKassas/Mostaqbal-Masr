import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class GroupModel{

  String groupID = "";
  String groupName = "";
  String groupImage = "";
  String groupLastMessageSenderName = "";
  String groupLastMessage = "";
  String groupLastMessageTime = "";
  List<Object?> adminsList = [];
  List<Object?> membersList = [];

  GroupModel(this.groupID,this.groupName,this.groupImage,this.groupLastMessageSenderName,this.groupLastMessage,this.groupLastMessageTime,this.adminsList,this.membersList);

  factory GroupModel.fromJson(Map<String, dynamic> jsonData) {
    return GroupModel(
        jsonData['GroupID'],
        jsonData['GroupName'],
        jsonData['GroupImage'],
        jsonData['GroupLastMessageSenderName'],
        jsonData['GroupLastMessage'],
        jsonData['GroupLastMessageTime'],
        jsonData['Admins'],
        jsonData['Members']);
  }

  static Map<String, dynamic> toMap(GroupModel groupModel) => {
    'GroupID': groupModel.groupID,
    'GroupName': groupModel.groupName,
    'GroupImage': groupModel.groupImage,
    'GroupLastMessageSenderName': groupModel.groupLastMessageSenderName,
    'GroupLastMessage': groupModel.groupLastMessage,
    'GroupLastMessageTime': groupModel.groupLastMessageTime,
    'Admins': groupModel.adminsList,
    'Members': groupModel.membersList,
  };

  static String encode(List<GroupModel> musics) => json.encode(
    musics
        .map<Map<String, dynamic>>((music) => GroupModel.toMap(music))
        .toList(),
  );

  static List<GroupModel> decode(String users) =>
      (json.decode(users) as List<dynamic>)
          .map<GroupModel>((item) => GroupModel.fromJson(item))
          .toList();

}