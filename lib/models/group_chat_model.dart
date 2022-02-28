import 'package:image_picker/image_picker.dart';
import 'package:mostaqbal_masr/shared/gallery_item_model.dart';

class GroupChatModel {
  String senderID = "";
  String senderName = "";
  String senderImage = "";
  String groupID = "";
  String message = "";
  String messageTime = "";
  String messageFullTime = "";
  String type = "";
  String fileName = "";
  bool isSeen = false;
  bool hasImages = false;
  List<XFile?>? messageImages;
  List<String>? galleryImages;
  List<GalleryModel?>? galleryModelList;

  GroupChatModel(this.senderID, this.senderName,this.senderImage,this.groupID, this.message,this.messageTime,this.messageFullTime,this.messageImages, this.type, this.isSeen, this.fileName, this.hasImages,this.galleryImages,this.galleryModelList);

}
