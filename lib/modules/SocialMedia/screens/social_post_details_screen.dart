import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/display_posts_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_post_details_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_post_details_states.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/screens/social_edit_post_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class SocialPostDetailsScreen extends StatefulWidget {
  final String postTitle;
  final String postVideoID;
  final String postID;
  final String hasImages;
  final String realDate;
  final List<Object?>? postImages;

  SocialPostDetailsScreen({Key? key,
    required this.postID,
    required this.postTitle,
    required this.postVideoID,
    required this.hasImages,
    required this.realDate,
    required this.postImages})
      : super(key: key);

  @override
  State<SocialPostDetailsScreen> createState() =>
      _SocialPostDetailsScreenState();
}

class _SocialPostDetailsScreenState extends State<SocialPostDetailsScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    noInternet();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SocialPostDetailsCubit(),),
        BlocProvider(create: (context) => SocialDisplayPostsCubit())
      ],
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
                if (Navigator.of(context).canPop()) {
                  SocialDisplayPostsCubit.get(context).getPosts();
                  //cubit.getPosts();
                  Navigator.of(context).pop();
                } else {
                  SystemNavigator.pop();
                }

                return Future.value(false);
              },
              child: Scaffold(
                key: scaffoldKey,
                appBar: AppBar(
                  backgroundColor: Colors.teal[700],
                  title: const Text("تفاصيل الخبر"),
                ),
                floatingActionButton:
                FadeInUp(
                  duration: const Duration(seconds: 1),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end, children: [
                    FloatingActionButton(
                      child: const Icon(
                        IconlyBroken.edit,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.teal[700],
                      onPressed: () {
                        cubit.navigateToEdit(
                          context,
                          SocialEditPostScreen(
                              postID: widget.postID,
                              postTitle: widget.postTitle,
                              postVideoID: widget.postVideoID,
                              hasImages: widget.hasImages,
                              realDate: widget.realDate,
                              postImages: widget.postImages),
                        );
                      },
                      heroTag: null,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton(
                      child: const Icon(
                        IconlyBroken.delete,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.teal[700],
                      onPressed: () async {
                        var connectivityResult = await (Connectivity()
                            .checkConnectivity());
                        if (connectivityResult == ConnectivityResult.none) {
                          showToast(
                            message: 'تحقق من اتصالك بالانترنت اولاً',
                            length: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                          );
                        } else {
                          _showDialog(context, cubit);
                        }
                      },
                      heroTag: null,
                    )
                  ]),
                ),
                floatingActionButtonLocation:
                FloatingActionButtonLocation.endFloat,
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

  Widget headerRow() =>
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/logo.jpg"),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Column(
              children: const [
                Text(
                  "مشروع مستقبل مصر",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4.0,
                ),
              ],
            )

          ],
        ),
      );

  Widget postBody(BuildContext context, SocialPostDetailsCubit cubit) {
    cubit.initializeVideo(widget.postVideoID);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Linkify(
            onOpen: (link) async {
              if (await canLaunch(link.url)) {
                await launch(link.url);
              } else {
                throw 'Could not launch $link';
              }
            },
            text: widget.postTitle.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12.0,
              overflow: TextOverflow.ellipsis,
            ),
            linkStyle: const TextStyle(
              color: Colors.blue,
              fontSize: 12.0,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Visibility(
            visible: widget.hasImages == "true" ? true : false,
            child: CarouselSlider(
              items: widget.postImages!
                  .map((e) =>
                  ClipRRect(
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
                      const AssetImage("assets/images/placeholder.jpg"),
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
                enableInfiniteScroll: widget.postImages!.length != 1
                    ? true
                    : false,
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
            visible: widget.postVideoID == "Empty" ? false : true,
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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

  _showDialog(BuildContext context, SocialPostDetailsCubit cubit) {
    // ignore: prefer_function_declarations_over_variables
    VoidCallback continueCallBack = () =>
    {
      Navigator.of(context).pop(),
      // code on continue comes here
      cubit.deletePost(widget.postID)
    };
    BlurryDialog alert =
    BlurryDialog("تنبيه", "هل تريد حذف هذا الخبر ؟", continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
