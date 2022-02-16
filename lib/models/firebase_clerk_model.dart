import 'dart:convert';

class ClerkFirebaseModel{

  String? clerkID;
  String? clerkName;
  String? clerkImage;
  String? clerkLastMessage;
  String? clerkLastMessageTime;
  String? personNumber;
  String? personAddress;
  String? personPhone;
  String? personPassword;
  String? personState;
  String? personToken;

  ClerkFirebaseModel(
      this.clerkID,
      this.clerkName,
      this.clerkImage,
      this.personNumber,
      this.personAddress,
      this.personPhone,
      this.personPassword,
      this.personState,
      this.personToken,
      this.clerkLastMessage,
      this.clerkLastMessageTime);


  factory ClerkFirebaseModel.fromJson(Map<String, dynamic> jsonData) {
    return ClerkFirebaseModel(
        jsonData['ClerkID'],
        jsonData['ClerkName'],
        jsonData['ClerkImage'],
        jsonData['PersonNumber'],
        jsonData['PersonAddress'],
        jsonData['PersonPhone'],
        jsonData['PersonPassword'],
        jsonData['PersonState'],
        jsonData['PersonToken'],
        jsonData['CategoryLastMessage'],
        jsonData['CategoryLastMessageTime'],
    );
  }

  static Map<String, dynamic> toMap(ClerkFirebaseModel clerkModel) => {
    'ClerkID': clerkModel.clerkID,
    'ClerkName': clerkModel.clerkName,
    'ClerkImage': clerkModel.clerkImage,
    'ClerkPhone': clerkModel.personPhone,
    'ClerkNumber': clerkModel.personNumber,
    'ClerkAddress': clerkModel.personAddress,
    'ClerkPassword': clerkModel.personPassword,
    'ClerkState': clerkModel.personState,
    'ClerkToken': clerkModel.personToken,
    'ClerkLastMessage': clerkModel.clerkLastMessage,
    'ClerkLastMessageTime': clerkModel.clerkLastMessageTime,
  };

  static String encode(List<ClerkFirebaseModel> clerks) => json.encode(
    clerks
        .map<Map<String, dynamic>>((clerk) => ClerkFirebaseModel.toMap(clerk))
        .toList(),
  );

  static List<ClerkFirebaseModel> decode(String clerks) =>
      (json.decode(clerks) as List<dynamic>)
          .map<ClerkFirebaseModel>((item) => ClerkFirebaseModel.fromJson(item))
          .toList();

}