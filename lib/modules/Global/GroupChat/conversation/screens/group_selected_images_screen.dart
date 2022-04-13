import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/conversation/cubit/group_conversation_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/conversation/cubit/group_conversation_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class GroupSelectedImagesScreen extends StatefulWidget {
  final List<XFile?>? chatImages;
  final String groupID;
  const GroupSelectedImagesScreen({Key? key, required this.chatImages, required this.groupID}) : super(key: key);

  @override
  State<GroupSelectedImagesScreen> createState() => _GroupSelectedImagesScreenState();
}

class _GroupSelectedImagesScreenState extends State<GroupSelectedImagesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupConversationCubit()..getUserData(),
      child: BlocConsumer<GroupConversationCubit, GroupConversationStates>(
        listener: (context, state){
          if(state is GroupConversationUploadingImageErrorState){
            showToast(message: state.error, length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
          }
        },
        builder: (context, state){

          var cubit = GroupConversationCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.black,
            floatingActionButton: BuildCondition(
              condition: state is GroupConversationUploadingImagesState,
              builder: (context) => CircularProgressIndicator(
                color: Colors.teal[700],
                strokeWidth: 0.8,
              ),
              fallback: (context) => FadeInUp(
                duration: const Duration(seconds: 1),
                child: FloatingActionButton(
                  onPressed: () async {
                    cubit.uploadMultipleImages(context, widget.groupID);
                  },
                  child: const Icon(
                    Icons.done,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.teal[700],
                  elevation: 15.0,
                ),
              ),
            ),
            body: Center(
                child: CarouselSlider.builder(
                  itemCount: widget.chatImages!.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => ClipRRect(
                    child: FadeInImage(
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        image: FileImage(File(widget.chatImages![itemIndex]!.path)),
                        placeholder:
                        const AssetImage("assets/images/placeholder.jpg"),
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/images/error.png',
                              width: double.infinity,
                              height: 250,
                              fit: BoxFit.fill);
                        },
                      ),
                  ),
                  options: CarouselOptions(
                    height: 250.0,
                    initialPage: 0,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    scrollPhysics: const BouncingScrollPhysics(),
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
            ),
          );
        },
      ),
    );
  }
}
