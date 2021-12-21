import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/models/posts_model.dart';
import 'package:mostaqbal_masr/modules/Global/Login/login_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/cubit/global_display_posts_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/cubit/global_display_posts_states.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/screens/global_post_details_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GlobalDisplayPostsScreen extends StatefulWidget {
  @override
  State<GlobalDisplayPostsScreen> createState() =>
      _GlobalDisplayPostsScreenState();
}

class _GlobalDisplayPostsScreenState extends State<GlobalDisplayPostsScreen>
    with WidgetsBindingObserver {
  VideoPlayerController? videoPlayerController;
  bool videosInitialized = false;


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalDisplayPostsCubit()..getPosts(),
      child: BlocConsumer<GlobalDisplayPostsCubit, GlobalDisplayPostsStates>(
        listener: (context, state) {
          if (state is GlobalDisplayPostsInitializeVideoErrorState) {
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          } else if (state is GlobalDisplayPostsErrorState) {
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }
        },
        builder: (context, state) {
          var cubit = GlobalDisplayPostsCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.teal[700],
                title: const Text("اخبار المشروع"),
                actions: [
                  IconButton(
                    icon: const Icon(
                      IconlyBroken.login,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      cubit.goToLogin(context, LoginScreen());
                    },
                  )
                ],
              ),
              body: BuildCondition(
                condition: state is GlobalDisplayPostsLoadingState,
                builder: (context) => Center(
                    child: CircularProgressIndicator(
                  color: Colors.teal[700],
                )),
                fallback: (context) => BuildCondition(
                  condition: cubit.postsList.isEmpty,
                  fallback: (context) => ListView.separated(
                    addAutomaticKeepAlives: true,
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => cardBuilder(
                        context, cubit, state, cubit.postsList[index], index),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10.0),
                    itemCount: cubit.postsList.length,
                  ),
                  builder: (context) => noPosts(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget noPosts() => Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0)),
                  child: FadeInImage(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                    image: const AssetImage("assets/images/noresult.png"),
                    placeholder: const AssetImage("assets/images/wait.jpg"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/error.png',
                        fit: BoxFit.fill,
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  "لا يوجد اخبار لعرضها",
                  style: TextStyle(
                    color: Colors.teal[500],
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 12.0,
                ),
              ],
            ),
          ),
        ),
      );

  Widget cardBuilder(BuildContext context, GlobalDisplayPostsCubit cubit,
          GlobalDisplayPostsStates state, PostsModel postsModel, int index) =>
      InkWell(
        onTap: () {
          cubit.goToDetails(
              context,
              GlobalPostDetailsScreen(
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

  Widget postBody(BuildContext context, GlobalDisplayPostsCubit cubit,
      GlobalDisplayPostsStates state, PostsModel postsModel, int index) {
    cubit.initializeVideoWithoutPlay(
        cubit.postsList[index].PostVideoID.toString());

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
                height: 250,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
                image: NetworkImage(cubit.postsList[index].PostImages![0]
                    .toString()
                    .replaceAll("[", "")
                    .replaceAll("]", "")),
                placeholder: const AssetImage("assets/images/placeholder.jpg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/error.png',
                    fit: BoxFit.fill,
                    height: 250,
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
                progressIndicatorColor: Colors.teal[700],
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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);


    print("display screen initState\n");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print("display screen in resumed\n");
        break;
      case AppLifecycleState.inactive:
        print("display screen in active\n");
        break;
      case AppLifecycleState.paused:
        print("display screen paused\n");
        break;
      case AppLifecycleState.detached:
        //await GlobalHomeCubit.get(context).logOut(context);
        //await logOut();
        print("display screen detached\n");
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }
}
