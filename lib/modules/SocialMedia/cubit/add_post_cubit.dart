import 'dart:collection';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/add_post_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class SocialAddPostCubit extends Cubit<SocialAddPostStates> {
  SocialAddPostCubit() : super(SocialAddPostInitialState());

  static SocialAddPostCubit get(context) => BlocProvider.of(context);

  final ImagePicker _imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await _imagePicker.pickMultiImage();

    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);

      print("Image List length : " + imageFileList!.length.toString());
      print("Image 0 path : " + imageFileList![0].path.toString());

      emit(SocialAddPostPickImagesSuccessState());
    }
  }

  void deleteImage(int index) {
    imageFileList!.removeAt(index);

    emit(SocialAddPostDeleteImageSuccessState());
  }

  String videoUrl = "Empty";

  void addPost(String postTitle, String? postVideoID) async {
    if (postVideoID!.isNotEmpty) {
      videoUrl = postVideoID;
    }

    if (imageFileList!.isEmpty) {
      uploadSinglePost(postTitle, videoUrl);
    } else {
      uploadImagePost(postTitle, videoUrl);
    }
  }

  void uploadSinglePost(String postTitle, String? postVideoID) async {
    emit(SocialAddPostLoadingState());

    FirebaseDatabase database = FirebaseDatabase.instance;

    DatabaseReference ref = database.reference().child("Posts");

    DateTime now = DateTime.now();
    String currentTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    ref.child(currentTime).set({
      'PostID': currentTime,
      'PostTitle': postTitle,
      'PostVideoID': postVideoID!,
      'PostDate': currentTime,
      'hasImages': "false",
    }).then((value) {
      showToast(
        message: "تم رفع الخبر بنجاح",
        length: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
      );

      emit(SocialAddPostSuccessState());
    }).catchError((error) {
      emit(SocialAddPostErrorState(error.toString()));
    });
  }

  Future uploadImagePost(String postTitle, String? postVideoID) async {
    emit(SocialAddPostLoadingState());

    DateTime now = DateTime.now();
    String currentTime = DateFormat("yyyy-MM-dd HH:mm:ss").format(now);

    var storageRef = FirebaseStorage.instance.ref("Posts/$currentTime");
    FirebaseDatabase database = FirebaseDatabase.instance;
    var postsRef = database.reference().child("Posts");


    List<String> urlsList = [];

    Map<String, Object> dataMap = HashMap();

    dataMap['PostID'] = currentTime;
    dataMap['PostTitle'] = postTitle;
    dataMap['PostVideoID'] = postVideoID!;
    dataMap['PostDate'] = currentTime;
    dataMap["hasImages"] = "true";

    for (int i = 0; i < imageFileList!.length; i++) {
      postsRef.child(currentTime).set(dataMap).then((value) async {
        String fileName = imageFileList![i].path.toString();

        File imageFile = File(fileName);

        var uploadTask = storageRef.child(fileName).putFile(imageFile);
        await uploadTask.then((p0) {
          p0.ref.getDownloadURL().then((value) {
            urlsList.add(value.toString());

            dataMap["PostImages"] = urlsList;

            postsRef.child(currentTime).update(dataMap).then((value) {
              showToast(
                message: "تم رفع الخبر بنجاح",
                length: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3,
              );

              imageFileList = [];

              emit(SocialAddPostSuccessState());
            }).catchError((error) {
              emit(SocialAddPostErrorState(error.toString()));
            });
          }).catchError((error) {
            emit(SocialAddPostErrorState(error.toString()));
          });
        }).catchError((error) {
          emit(SocialAddPostErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(SocialAddPostErrorState(error.toString()));
      });

      //uploadCount++;
    }
  }


}
