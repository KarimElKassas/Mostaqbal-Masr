import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_edit_post_states.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SocialEditPostCubit extends Cubit<SocialEditPostStates> {
  SocialEditPostCubit() : super(SocialEditPostInitialState());

  static SocialEditPostCubit get(context) => BlocProvider.of(context);

  YoutubePlayerController? controller;

  Future initializeVideo(String videoID) async {
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: const YoutubePlayerFlags(
          autoPlay: false, mute: false, hideControls: false),
    );
  }

  Future<void> updatePost(
      String postID, String postTitle, String? postVideoID, String realDate) async {
    emit(SocialEditPostLoadingState());

    DatabaseReference ref =
        FirebaseDatabase.instance.reference().child("Posts").child(postID);

    if (postVideoID!.isEmpty) {
      postVideoID = "Empty";
    }

    // Only update the name, leave the age and address!
    await ref.update({
      "PostTitle": postTitle,
      "PostVideoID": postVideoID,
      "realDate": realDate,
    }).then((value) {
      emit(SocialEditPostSuccessState());
    }).catchError((error) {
      emit(SocialEditPostErrorState(error.toString()));
    });
  }
}
