import 'package:bloc/bloc.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_states.dart';
import 'package:mostaqbal_masr/models/posts_model.dart';
import 'package:mostaqbal_masr/shared/components.dart';
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
    emit(SocialDisplayPostsLoadingState());

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

          print(values["PostTitle"]);
          print(values["PostImages"]);
          print("From Model ${postsModel!.PostTitle}");
          //print("From Model ${postsModel!.PostImages}");
        });
      }

      emit(SocialDisplayPostsSuccessState());
    }).catchError((error) {
      emit(SocialDisplayPostsErrorState(error.toString()));
    });
  }

  void goToDetails(BuildContext context, route) {
    navigateTo(context, route);
  }

/*
  Future<void> getFireStorePosts() async {
    emit(SocialDisplayPostsLoadingState());

    List<String?>? postImages = [];

   await FirebaseFirestore.instance
        .collection('Posts')
        .get()
        .then((QuerySnapshot querySnapshot) {

          postImages = [];
          postsList.clear();

          querySnapshot.docs.forEach((doc) {
            String postID = doc.get("PostID").toString();
            String postTitle = doc.get("PostTitle").toString();
            String postVideoID = doc.get("PostVideoID").toString();
            String postDate = doc.get("PostDate").toString();
            String hasImages = doc.get("hasImages").toString();


            if(hasImages == "true"){
              postImages!.add(doc.get("PostImages").toString());
            }

            postsModel = PostsModel(postID, postTitle, postVideoID, postDate, hasImages, postImages);

            //postImages.clear();

            postsList.add(postsModel!);
            print(postsModel!.PostImages);
            print(postsModel!.PostTitle);
          });
      */
/*for (var doc in querySnapshot.docs) {

        //postImages.clear();
        //postsList.clear();

        String postID = doc.get("PostID").toString();
        String postTitle = doc.get("PostTitle").toString();
        String postVideoID = doc.get("PostVideoID").toString();
        String postDate = doc.get("PostDate").toString();
        String hasImages = doc.get("hasImages").toString();

        if(hasImages == "true"){
          postImages.add(doc.get("PostImages").toString());
        }

        postsModel = PostsModel(postID, postTitle, postVideoID, postDate, hasImages, postImages);

        //postImages.clear();

        postsList.add(postsModel!);
        print(postsModel!.PostImages);
        print(postsModel!.PostTitle);

      }*/ /*

      emit(SocialDisplayPostsSuccessState());
    }).catchError((error){
      emit(SocialDisplayPostsErrorState(error.toString()));
   });
    */
/* FirebaseFirestore.instance.collection('Posts').get().then((value) {

      // ignore: iterable_contains_unrelated_type
     */ /*
 */
/* if(value.docs.contains("PostImages")){


      }*/ /*
 */
/*

      for (var element in value.docs) {
        String postID = element["PostID"].toString();
        String postTitle = element["PostTitle"].toString();
        String postVideoID = element["PostVideoID"].toString();
        String postDate = element["PostDate"].toString();

        // ignore: iterable_contains_unrelated_type
        if(value.docs.contains("PostImages")){
          print("Print element ${element["PostImages"].toString()}");
          postImages.add(element["PostImages"].toString());
        }else{
          //postImages.add(null);
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
    });*/ /*

  }
*/
}
