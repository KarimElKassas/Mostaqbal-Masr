import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/model/posts_model.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_post_details_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SocialDisplayPostsScreen extends StatelessWidget {
  VideoPlayerController? videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialDisplayPostsCubit()..getPosts(),
      child: BlocConsumer<SocialDisplayPostsCubit, SocialDisplayPostsStates>(
        listener: (context, state) {
          if (state is SocialDisplayPostsInitializeVideoErrorState) {
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          } else if (state is SocialDisplayPostsErrorState) {
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }
        },
        builder: (context, state) {
          showToast(
            message: "Build Method ",
            length: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );

          var cubit = SocialDisplayPostsCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF0500A0),
                title: const Text("اخبار المشروع"),
              ),
              body: ListView.separated(
                addAutomaticKeepAlives: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => cardBuilder(
                    context, cubit, state, cubit.postsList[index], index),
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 10.0),
                itemCount: cubit.postsList.length,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget cardBuilder(BuildContext context, SocialDisplayPostsCubit cubit,
          SocialDisplayPostsStates state, PostsModel postsModel, int index) =>
      InkWell(
        onTap: () {
          cubit.goToDetails(
              context,
              SocialPostDetailsScreen(
                  postID: cubit.postsList[index].PostID.toString(),
                  postTitle: cubit.postsList[index].PostTitle.toString(),
                  postVideoID: cubit.postsList[index].PostVideoID.toString(),
                  hasImages: cubit.postsList[index].hasImages.toString(),
                  postImages: cubit.postsList[index].PostImages));
        },
        child: Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 15,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          shadowColor: Colors.black,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              headerRow(),
              postBody(context, cubit, state, cubit.postsModel!, index),
            ],
          ),
        ),
      );

  Widget headerRow() => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/logo.jpg"),
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(
              "مشروع مستقبل مصر",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  Widget postBody(BuildContext context, SocialDisplayPostsCubit cubit,
      SocialDisplayPostsStates state, PostsModel postsModel, int index) {
    cubit.initializeVideo(cubit.postsList[index].PostVideoID.toString());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cubit.postsList[index].PostTitle!.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12.0,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 4,
          ),
          const SizedBox(
            height: 16.0,
          ),
          Visibility(
            visible: cubit.postsList[index].hasImages == "true" ? true : false,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0)),
              child: FadeInImage(
                height: 200,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                image: NetworkImage(cubit.postsList[index].PostImages![0]
                    .toString()
                    .replaceAll("[", "")
                    .replaceAll("]", "")),
                placeholder: const AssetImage("assets/images/wait.jpg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/error.png',
                    fit: BoxFit.fill,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
           Visibility(
              visible:
                  cubit.postsList[index].PostVideoID == "Empty" ? false : true,
              child: SizedBox(
                child: YoutubePlayer(
                  bottomActions: [
                    CurrentPosition(),
                    ProgressBar(isExpanded: true),
                  ],
                  controller: cubit.controller!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.amber,
                  onReady: () {
                    cubit.controller!;
                  },
                ),
                width: MediaQuery.of(context).size.width,
                height: 200,
              ),
            ),
          const SizedBox(
            height: 8.0,
          ),
        ],
      ),
    );
  }
}
