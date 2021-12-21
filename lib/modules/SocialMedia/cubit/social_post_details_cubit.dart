import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_post_details_states.dart';
import 'package:mostaqbal_masr/models/posts_model.dart';
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

  var titleController = TextEditingController();
  var videoIDController = TextEditingController();
  var formKey = GlobalKey<FormState>();


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
