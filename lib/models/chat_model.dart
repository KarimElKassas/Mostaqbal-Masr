import 'package:image_picker/image_picker.dart';

class ChatModel {
  String senderID = "";
  String receiverID = "";
  String message = "";
  String messageTime = "";
  String messageFullTime = "";
  String type = "";
  String fileName = "";
  bool isSeen = false;
  bool hasImages = false;
  List<XFile?>? messageImages;
  List<String>? galleryImages;

  ChatModel(this.senderID, this.receiverID, this.message,this.messageTime,this.messageFullTime,this.messageImages, this.type, this.isSeen, this.fileName, this.hasImages,this.galleryImages);

}
