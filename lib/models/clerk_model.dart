import 'dart:convert';

class ClerkModel{

  String? clerkID;
  String? clerkName;
  String? clerkImage;
  String? personNumber;
  String? personAddress;
  String? personPhone;
  String? personTypeID;
  String? personTypeName;
  String? categoryID;
  String? categoryName;
  String? categoryRank;
  String? rankID;
  String? rankName;
  String? managementID;
  String? managementName;
  String? jobID;
  String? jobName;
  String? coreStrengthID;
  String? coreStrengthName;
  String? presenceID;
  String? presenceName;
  String? userStatus;
  String? OnFirebase;
  String? token;

  ClerkModel(
      this.clerkID,
      this.clerkName,
      this.clerkImage,
      this.personNumber,
      this.personAddress,
      this.personPhone,
      this.personTypeID,
      this.personTypeName,
      this.categoryID,
      this.categoryName,
      this.categoryRank,
      this.rankID,
      this.rankName,
      this.managementID,
      this.managementName,
      this.jobID,
      this.jobName,
      this.coreStrengthID,
      this.coreStrengthName,
      this.presenceID,
      this.presenceName,
      this.userStatus,
      this.OnFirebase,
      this.token);


  factory ClerkModel.fromJson(Map<String, dynamic> jsonData) {
    return ClerkModel(
        jsonData['ClerkID'],
        jsonData['ClerkName'],
        jsonData['ClerkImage'],
        jsonData['PersonNumber'],
        jsonData['PersonAddress'],
        jsonData['PersonPhone'],
        jsonData['PersonTypeID'],
        jsonData['PersonTypeName'],
        jsonData['CategoryID'],
        jsonData['CategoryName'],
        jsonData['CategoryRank'],
        jsonData['RankID'],
        jsonData['RankName'],
        jsonData['ManagementID'],
        jsonData['ManagementName'],
        jsonData['JobID'],
        jsonData['JobName'],
        jsonData['CoreStrengthID'],
        jsonData['CoreStrengthName'],
        jsonData['PresenceID'],
        jsonData['PresenceName'],
        jsonData['TrueOrFalse'],
        jsonData['OnFirebase'],
        jsonData['ClerkToken']
    );
  }

  static Map<String, dynamic> toMap(ClerkModel clerkModel) => {
    'ClerkID': clerkModel.clerkID,
    'ClerkName': clerkModel.clerkName,
    'ClerkImage': clerkModel.clerkImage,
    'ClerkPhone': clerkModel.personPhone,
    'ClerkNumber': clerkModel.personNumber,
    'ClerkAddress': clerkModel.personAddress,
    'ClerkTypeID': clerkModel.personTypeID,
    'ClerkTypeName': clerkModel.personTypeName,
    'ClerkCategoryID': clerkModel.categoryID,
    'ClerkCategoryName': clerkModel.categoryName,
    'ClerkCategoryRank': clerkModel.categoryRank,
    'ClerkRankID': clerkModel.rankID,
    'ClerkRankName': clerkModel.rankName,
    'ClerkManagementID': clerkModel.managementID,
    'ClerkManagementName': clerkModel.managementName,
    'ClerkJobID': clerkModel.jobID,
    'ClerkJobName': clerkModel.jobName,
    'ClerkCoreStrengthID': clerkModel.coreStrengthID,
    'ClerkCoreStrengthName': clerkModel.coreStrengthName,
    'ClerkPresenceID': clerkModel.presenceID,
    'ClerkPresenceName': clerkModel.presenceName,
    'TrueOrFalse': clerkModel.userStatus,
    'OnFirebase': clerkModel.OnFirebase,
    'ClerkToken': clerkModel.token,
  };

  static String encode(List<ClerkModel> clerks) => json.encode(
    clerks
        .map<Map<String, dynamic>>((clerk) => ClerkModel.toMap(clerk))
        .toList(),
  );

  static List<ClerkModel> decode(String clerks) =>
      (json.decode(clerks) as List<dynamic>)
          .map<ClerkModel>((item) => ClerkModel.fromJson(item))
          .toList();

}