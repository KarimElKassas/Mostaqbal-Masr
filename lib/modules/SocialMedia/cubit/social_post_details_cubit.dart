import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_post_details_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/model/posts_model.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SocialPostDetailsCubit extends Cubit<SocialPostDetailsStates> {
  SocialPostDetailsCubit() : super(SocialPostDetailsInitialState());

  static SocialPostDetailsCubit get(context) => BlocProvider.of(context);

  YoutubePlayerController? controller;

  Future initializeVideo(String videoID) async {
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: const YoutubePlayerFlags(
          autoPlay: false, mute: false, hideControls: false),
    );
  }

  void navigateToEdit(BuildContext context, route) {
    navigateAndFinish(context, route);
  }

  IconData fabIcon = Icons.edit;

  var titleController = TextEditingController();
  var videoIDController = TextEditingController();

  bool isOpen = false;

  var bottomSheetController;
  var formKey = GlobalKey<FormState>();

  void settingModalBottomSheet(context, scaffoldKey) {
    fabIcon = Icons.check;
    bottomSheetController =
        scaffoldKey.currentState!.showBottomSheet<void>((BuildContext context) {
      return GestureDetector(
        onVerticalDragDown: (_) {},
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(24.0), bottom: Radius.zero),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'برجاء ادخال نص الخبر';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "نص الخبر",
                    prefixIcon: Icon(
                      Icons.title,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: videoIDController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "رابط الفيديو",
                    prefixIcon: Icon(
                      Icons.video_call,
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
    emit(SocialPostDetailsOpenBottomSheetState());
  }

  void closeModalBottomSheet() {
    if (bottomSheetController != null) {
      bottomSheetController.close();
      bottomSheetController = null;
      fabIcon = Icons.edit;

      emit(SocialPostDetailsCloseBottomSheetState());
    }
  }

  PostsModel? postsModel;
  List<PostsModel> postsList = [];

  void getPosts() async {
    emit(SocialPostDetailsLoadingBackDataState());

    List<Object?>? postImages = [];

    FirebaseDatabase.instance
        .reference()
        .child('Posts')
        .once()
        .then((snapshot) async {
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {

        String postID = values["PostID"].toString();
        String postTitle = values["PostTitle"].toString();
        String postVideoID = values["PostVideoID"].toString();
        String postDate = values["PostDate"].toString();
        String hasImages = values["hasImages"].toString();

        if(values["hasImages"] == "true"){
          postImages = values["PostImages"];

        }

        postsModel = PostsModel(postID, postTitle, postVideoID, postDate,hasImages,postImages);
        postsList.add(postsModel!);

        print(values["PostTitle"]);
        print(values["PostImages"]);
        print("From Model ${postsModel!.PostTitle}");
        //print("From Model ${postsModel!.PostImages}");
      });
      emit(SocialPostDetailsSuccessBackDataState());
    }).catchError((error){
      emit(SocialPostDetailsErrorBackDataState(error.toString()));
    });
  }

  Future<void> deletePost(String postID)async {

    emit(SocialPostDetailsLoadingDeletePostState());

    DatabaseReference ref = FirebaseDatabase.instance.reference().child("Posts").child(postID);

    await ref.remove().then((value){

      emit(SocialPostDetailsSuccessDeletePostState());

    }).catchError((error){
      emit(SocialPostDetailsErrorDeletePostState(error.toString()));
    });

  }
}
