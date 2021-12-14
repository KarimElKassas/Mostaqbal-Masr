import 'dart:collection';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/add_post_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/model/posts_model.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SocialDisplayPostsCubit extends Cubit<SocialDisplayPostsStates> {
  SocialDisplayPostsCubit() : super(SocialDisplayPostsInitialState());

  static SocialDisplayPostsCubit get(context) => BlocProvider.of(context);

  YoutubePlayerController? controller;

  Future initializeVideo(String videoID) async {
    controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: const YoutubePlayerFlags(
          autoPlay: false, mute: false, hideControls: false),
    );
  }

  PostsModel? postsModel;
  List<PostsModel> postsList = [];

  void getPosts() async {
    emit(SocialDisplayPostsLoadingState());

    List<Object?>? postImages = [];

    FirebaseDatabase.instance
        .reference()
        .child('Posts')
        .onValue
        .listen((event) async {

      Map<dynamic, dynamic> values = event.snapshot.value;
      values.forEach((key,values) {

        String postID = values["PostID"].toString();
        String postTitle = values["PostTitle"].toString();
        String postVideoID = values["PostVideoID"].toString();
        String postDate = values["PostDate"].toString();
        /*if(values["PostImages"] !=null){
          postImages = values["PostImages"];

        }*/

        //postsModel = PostsModel(postID, postTitle, postVideoID, postDate);
        postsList.add(postsModel!);

        print(values["PostTitle"]);
        print(values["PostImages"]);
        print("From Model ${postsModel!.PostTitle}");
        //print("From Model ${postsModel!.PostImages}");

      });
      //emit(SocialDisplayPostsSuccessState());
    }).onDone(() {
     // emit(SocialDisplayPostsSuccessState());
    });

  }
  void getFireStorePosts() async {

    emit(SocialDisplayPostsLoadingState());

    List<Object?>? postImages = [];

    FirebaseFirestore.instance.collection('Posts').get().then((value) {

      // ignore: iterable_contains_unrelated_type
     /* if(value.docs.contains("PostImages")){


      }*/

      for (var element in value.docs) {
        String postID = element["PostID"].toString();
        String postTitle = element["PostTitle"].toString();
        String postVideoID = element["PostVideoID"].toString();
        String postDate = element["PostDate"].toString();

        // ignore: iterable_contains_unrelated_type
        if(value.docs.contains("PostImages")){
          postImages = element["PostImages"];
        }

        postsModel = PostsModel(postID, postTitle, postVideoID, postDate, postImages);
        //postsModel = PostsModel.fromJson(element.data());

        postsList.add(postsModel!);
        print(postsModel!.PostImages);
        print(postsModel!.PostTitle);

      }

      //emit(SocialDisplayPostsSuccessState());

    }).catchError((error) {
      emit(SocialDisplayPostsErrorState(error.toString()));
    });

  }
}
