import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_post_details_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_post_details_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_edit_post_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SocialPostDetailsScreen extends StatelessWidget {
  final String postTitle;
  final String postVideoID;
  final String postID;
  final String hasImages;
  final List<Object?>? postImages;

  SocialPostDetailsScreen(
      {Key? key,
      required this.postID,
      required this.postTitle,
      required this.postVideoID,
      required this.hasImages,
      required this.postImages})
      : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialPostDetailsCubit(),
      child: BlocConsumer<SocialPostDetailsCubit, SocialPostDetailsStates>(
        listener: (context, state) {
          if (state is SocialPostDetailsSuccessDeletePostState) {
            if (Navigator.of(context).canPop()) {
              SocialPostDetailsCubit.get(context).getPosts();
              Navigator.of(context).pop();
            } else {
              SystemNavigator.pop();
            }
          } else if (state is SocialPostDetailsErrorDeletePostState) {
            showToast(
              message: state.error,
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }
        },
        builder: (context, state) {
          var cubit = SocialPostDetailsCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: WillPopScope(
              onWillPop: () {
                if (cubit.bottomSheetController != null) {
                  cubit.closeModalBottomSheet();
                } else {
                  if (Navigator.of(context).canPop()) {
                    cubit.getPosts();
                    Navigator.of(context).pop();
                  } else {
                    SystemNavigator.pop();
                  }
                }

                return Future.value(false);
              },
              child: Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  backgroundColor: const Color(0xFF0500A0),
                  title: const Text("تفاصيل الخبر"),
                ),
                floatingActionButton:
                    Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  FloatingActionButton(
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    backgroundColor: Color(purpleColor),
                    onPressed: () {
                      cubit.navigateToEdit(
                        context,
                        SocialEditPostScreen(
                            postID: postID,
                            postTitle: postTitle,
                            postVideoID: postVideoID,
                            hasImages: hasImages,
                            postImages: postImages),
                      );
                    },
                    heroTag: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FloatingActionButton(
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.white,
                    ),
                    backgroundColor: Color(purpleColor),
                    onPressed: () {
                      cubit.deletePost(postID);
                    },
                    heroTag: null,
                  )
                ]),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.startFloat,
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Card(
                    margin: const EdgeInsets.all(16.0),
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)),
                    shadowColor: Colors.black,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        headerRow(),
                        postBody(context, cubit),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

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

  Widget postBody(BuildContext context, SocialPostDetailsCubit cubit) {
    cubit.initializeVideo(postVideoID);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            postTitle.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Visibility(
            visible: hasImages == "true" ? true : false,
            child: CarouselSlider(
              items: postImages!
                  .map((e) => ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0)),
                        child: FadeInImage(
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.fill,
                          image: NetworkImage(e!.toString()),
                          placeholder:
                              const AssetImage("assets/images/wait.jpg"),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/images/error.png',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.fill);
                          },
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Visibility(
            visible: postVideoID == "Empty" ? false : true,
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

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22),
      backgroundColor: const Color(0xFF801E48),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: const Icon(Icons.edit),
            backgroundColor: const Color(0xFF801E48),
            onTap: () {
              /* do anything */
            },
            label: 'تعديل الخبر',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0xFF801E48)),
        // FAB 2
        SpeedDialChild(
            child: const Icon(Icons.delete_forever_rounded),
            backgroundColor: const Color(0xFF801E48),
            onTap: () {},
            label: 'حذف الخبر',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0xFF801E48))
      ],
    );
  }
}
