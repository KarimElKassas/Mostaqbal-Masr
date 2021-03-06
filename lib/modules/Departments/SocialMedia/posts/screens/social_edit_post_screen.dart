import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Departments/SocialMedia/posts/screens/social_post_details_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../cubit/social_edit_post_cubit.dart';
import '../cubit/social_edit_post_states.dart';

class SocialEditPostScreen extends StatefulWidget {
  final String postTitle;
  final String postVideoID;
  final String postID;
  final String hasImages;
  final String realDate;
  final List<Object?>? postImages;

  SocialEditPostScreen({Key? key,
    required this.postID,
    required this.postTitle,
    required this.postVideoID,
    required this.hasImages,
    required this.realDate,
    required this.postImages})
      : super(key: key);

  @override
  State<SocialEditPostScreen> createState() => _SocialEditPostScreenState();
}

class _SocialEditPostScreenState extends State<SocialEditPostScreen> {
  var postTextController = TextEditingController();
  var postVideoIDController = TextEditingController();
  var dateController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    postTextController.text = widget.postTitle;
    postVideoIDController.text = widget.postVideoID;
    dateController.text = widget.realDate;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialEditPostCubit()..initializeVideo(widget.postVideoID),
      child: BlocConsumer<SocialEditPostCubit, SocialEditPostStates>(
        listener: (context, state) {
          if (state is SocialEditPostSuccessState) {
            FocusScope.of(context).unfocus();

            navigateAndFinish(
              context,
              SocialPostDetailsScreen(
                  postID: widget.postID,
                  postTitle: postTextController.text,
                  postVideoID: postVideoIDController.text,
                  hasImages: widget.hasImages,
                  realDate: widget.realDate,
                  postImages: widget.postImages),
            );
          } else if (state is SocialEditPostErrorState) {
            showToast(
              message: state.error,
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }
        },
        builder: (context, state) {
          var cubit = SocialEditPostCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.teal[700],
                title: const Text("?????????? ??????????"),
              ),
              floatingActionButton: BuildCondition(
                condition: state is SocialEditPostLoadingState,
                builder: (context) =>
                    CircularProgressIndicator(
                      color: Colors.teal[700],
                    ),
                fallback: (context) =>
                    SlideInUp(
                      duration: const Duration(seconds: 2),
                      child: FloatingActionButton(
                        onPressed: () async {
                          var connectivityResult =
                          await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.none) {
                            showToast(
                              message: '???????? ???? ???????????? ?????????????????? ??????????',
                              length: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                            );
                          } else {
                            if (formKey.currentState!.validate()) {
                              _showDialog(context, cubit);
                            }
                          }
                        },
                        elevation: 15.0,
                        child: const Icon(
                          IconlyBroken.edit,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.teal[700],
                      ),
                    ),
              ),
              floatingActionButtonLocation:
              FloatingActionButtonLocation.endFloat,
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
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
          children:  [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/logo.jpg"),
            ),
            const SizedBox(
              width: 12.0,
            ),
            Column(
              children: [
                const Text(
                  "?????????? ???????????? ??????",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  widget.realDate,
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      );

  Widget postBody(BuildContext context, SocialEditPostCubit cubit) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.fill,
                      image: NetworkImage(e!.toString()),
                      placeholder:
                      const AssetImage("assets/images/placeholder.jpg"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/images/error.png',
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.fill);
                      },
                    ),
                  ))
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll:
                widget.postImages!.length != 1 ? true : false,
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
            height: 16.0,
          ),
          TextFormField(
            textDirection: TextDirection.rtl,
            controller: postTextController,
            keyboardType: TextInputType.text,
            validator: (String? value) {
              if (value!.isEmpty) {
                return '?????? ?????????? ?????????? ?????????? !';
              }
            },
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              floatingLabelStyle: TextStyle(color: Colors.teal[700]),
              labelText: '???? ??????????',
              alignLabelWithHint: true,
              hintTextDirection: TextDirection.rtl,
              prefixIcon: Icon(
                IconlyBroken.edit,
                color: Colors.teal[700],
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          TextFormField(
            textDirection: TextDirection.rtl,
            controller: postVideoIDController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              floatingLabelStyle: TextStyle(color: Colors.teal[700]),
              labelText: '???????? ?????????????? ???? ??????',
              alignLabelWithHint: true,
              hintTextDirection: TextDirection.rtl,
              prefixIcon: Icon(
                IconlyBroken.video,
                color: Colors.teal[700],
              ),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
            ),
          ),
          const SizedBox(
            height: 24.0,
          )
        ],
      ),
    );
  }

  _showDialog(BuildContext context, SocialEditPostCubit cubit) {
    // ignore: prefer_function_declarations_over_variables
    VoidCallback continueCallBack = () =>
    {
      Navigator.of(context).pop(),
      // code on continue comes here
      cubit.updatePost(widget.postID, postTextController.text,
          postVideoIDController.text)
    };
    BlurryDialog alert =
    BlurryDialog("??????????", "???? ???????? ?????????? ?????? ?????????? ??", continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
