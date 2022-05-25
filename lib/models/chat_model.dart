import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String senderID = "";
  String receiverID = "";
  String message = "";
  String messageTime = "";
  String messageFullTime = "";
  Timestamp? createdAt;
  String type = "";
  int imagesCount = 0;
  int recordDuration = 0;
  String fileSize = "0 KB";
  String fileName = "";
  bool isSeen = false;
  bool hasImages = false;
  List<dynamic> imagesList = ["emptyList"];
  ChatImagesModel? chatImagesModel;

  ChatModel.full(this.senderID, this.receiverID, this.message,this.messageTime,this.messageFullTime, this.createdAt, this.type, this.imagesCount, this.fileSize, this.recordDuration, this.isSeen, this.fileName, this.hasImages,this.imagesList,this.chatImagesModel);
  ChatModel(this.senderID, this.receiverID, this.message,this.messageTime,this.messageFullTime, this.createdAt, this.type, this.imagesCount, this.isSeen, this.fileName, this.hasImages);
}

class ChatImagesModel{
  String messageFullTime = "";
  List<dynamic> messageImagesList = [];

  ChatImagesModel(this.messageFullTime, this.messageImagesList);
}
