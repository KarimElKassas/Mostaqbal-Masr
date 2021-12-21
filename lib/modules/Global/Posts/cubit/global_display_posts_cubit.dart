import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/cubit/global_display_posts_states.dart';
import 'package:mostaqbal_masr/models/posts_model.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GlobalDisplayPostsCubit extends Cubit<GlobalDisplayPostsStates> {
  GlobalDisplayPostsCubit() : super(GlobalDisplayPostsInitialState());

  static GlobalDisplayPostsCubit get(context) => BlocProvider.of(context);

  YoutubePlayerController? controller;

  Future initializeVideo(String videoID) async {
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: const YoutubePlayerFlags(
          autoPlay: false, mute: false, hideControls: false),
    );
  }

  Future initializeVideoWithoutPlay(String videoID) async {
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: const YoutubePlayerFlags(
          autoPlay: false, mute: false, hideControls: true),
    );
  }

  PostsModel? postsModel;
  List<PostsModel> postsList = [];

  void getPosts() async {
    emit(GlobalDisplayPostsLoadingState());

    List<Object?>? postImages = [];

    FirebaseDatabase.instance
        .reference()
        .child('Posts')
        .once()
        .then((snapshot) async {
      if (snapshot.exists) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          String postID = values["PostID"].toString();
          String postTitle = values["PostTitle"].toString();
          String postVideoID = values["PostVideoID"].toString();
          String postDate = values["PostDate"].toString();
          String hasImages = values["hasImages"].toString();

          if (values["hasImages"] == "true") {
            postImages = values["PostImages"];
          }

          postsModel = PostsModel(
              postID, postTitle, postVideoID, postDate, hasImages, postImages);
          postsList.add(postsModel!);
        });
      }

      emit(GlobalDisplayPostsSuccessState());
    }).catchError((error) {
      emit(GlobalDisplayPostsErrorState(error.toString()));
    });
  }

  void goToDetails(BuildContext context, route) {
    navigateTo(context, route);
  }
  void goToLogin(BuildContext context, route) {
    navigateAndFinish(context, route);
  }
}
