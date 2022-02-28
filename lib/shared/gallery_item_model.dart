import 'package:image_picker/image_picker.dart';

class GalleryModel {
  GalleryModel({required this.id, required this.imageUrl});
// id image (image url) to use in hero animation
  final String id;
  // image url
  final XFile imageUrl;
}