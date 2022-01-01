import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/cubit/global_display_posts_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/cubit/global_post_details_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/cubit/global_post_details_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GlobalPostDetailsScreen extends StatefulWidget {
  final String postTitle;
  final String postVideoID;
  final String postID;
  final String hasImages;
  final List<Object?>? postImages;

  GlobalPostDetailsScreen(
      {Key? key,
      required this.postID,
      required this.postTitle,
      required this.postVideoID,
      required this.hasImages,
      required this.postImages})
      : super(key: key);

  @override
  State<GlobalPostDetailsScreen> createState() => _GlobalPostDetailsScreenState();
}

class _GlobalPostDetailsScreenState extends State<GlobalPostDetailsScreen> {
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
        BlocProvider(create: (context) => GlobalPostDetailsCubit(),),
        BlocProvider(create: (context) => GlobalDisplayPostsCubit())
      ],
      child: BlocConsumer<GlobalPostDetailsCubit, GlobalPostDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = GlobalPostDetailsCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: WillPopScope(
              onWillPop: () {
                  if (Navigator.of(context).canPop()) {
                    GlobalDisplayPostsCubit.get(context).getPosts();
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

  Widget postBody(BuildContext context, GlobalPostDetailsCubit cubit) {
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
                enableInfiniteScroll: widget.postImages!.length != 1 ? true : false,
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
