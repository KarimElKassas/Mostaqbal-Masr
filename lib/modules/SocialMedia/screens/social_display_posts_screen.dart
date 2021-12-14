import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/model/posts_model.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SocialDisplayPostsScreen extends StatelessWidget {
  VideoPlayerController? videoPlayerController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialDisplayPostsCubit(),
      child: BlocConsumer<SocialDisplayPostsCubit, SocialDisplayPostsStates>(
        listener: (context, state) {
          if (state is SocialDisplayPostsInitializeVideoErrorState) {
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }else if(state is SocialDisplayPostsErrorState){
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }
        },
        builder: (context, state) {
          var cubit = SocialDisplayPostsCubit.get(context)..getFireStorePosts();

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF0500A0),
                  title: const Text("اخبار المشروع"),
                ),
                body:ListView.separated(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => cardBuilder(context,cubit,state,cubit.postsList[index]),
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
      SocialDisplayPostsStates state, PostsModel postsModel) => Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 15,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)),
      shadowColor: Colors.black,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          headerRow(),
          postBody(context, cubit, state,cubit.postsModel!),
        ],
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
      SocialDisplayPostsStates state, PostsModel postsModel) {
    cubit.initializeVideo("d7EhaW_5VUY");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            postsModel.PostTitle!.toString(),
            style: const TextStyle(color: Colors.black, fontSize: 12.0),
          ),
          const SizedBox(
            height: 16.0,
          ),

          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0)),
            child: FadeInImage(
              height: 200,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/mostaqbal-masr.appspot.com/o/Posts%2F%D9%87%D8%A7%D8%AE%D8%A9%D9%85%D8%A9%2Fdata%2Fuser%2F0%2Fcom.example.mostaqbal_masr%2Fcache%2Fimage_picker3874726910048329154.jpg?alt=media"),
              placeholder: const AssetImage("assets/images/wait.jpg"),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/error.png', fit: BoxFit.fill,height: 200,width: MediaQuery.of(context).size.width,);
              },
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          BuildCondition(
            condition: state is! SocialDisplayPostsInitializeVideoLoadingState,
            fallback: (context) => const Center(
                child: CircularProgressIndicator(
              color: Color(0xFF0500A0),
            )),
            builder: (context) => SizedBox(
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
