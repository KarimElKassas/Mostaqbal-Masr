import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/selected_images_cubit.dart';
import '../cubit/selected_images_states.dart';

class SocialSelectedImagesScreen extends StatefulWidget {
  final List<XFile?>? chatImages;
  final String receiverID;
  //final String groupID;
  const SocialSelectedImagesScreen({Key? key, required this.chatImages, required this.receiverID}) : super(key: key);

  @override
  State<SocialSelectedImagesScreen> createState() => _SocialSelectedImagesScreenState();
}

class _SocialSelectedImagesScreenState extends State<SocialSelectedImagesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialSelectedImagesCubit(),
      child: BlocConsumer<SocialSelectedImagesCubit, SocialSelectedImagesStates>(
        listener: (context, state){},
        builder: (context, state){

          var cubit = SocialSelectedImagesCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.black,
                statusBarIconBrightness: Brightness.light,
                // For Android (dark icons)
                statusBarBrightness:
                Brightness.dark, // For iOS (dark icons)
              ),
              backgroundColor: Colors.black,
              elevation: 0.0,
              toolbarHeight: 0,
            ),
            backgroundColor: Colors.black,
            floatingActionButton: BuildCondition(
              condition: state is SocialSelectedImagesUploadingState,
              builder: (context) => CircularProgressIndicator(
                color: Colors.teal[700],
                strokeWidth: 0.8,
              ),
              fallback: (context) => FadeInUp(
                duration: const Duration(seconds: 1),
                child: FloatingActionButton(
                  onPressed: () async {
                    cubit.uploadMultipleImages(context, widget.receiverID);
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
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                   InteractiveViewer(
                        child: Scaffold(
                          backgroundColor: Colors.black,
                          appBar: AppBar(
                            systemOverlayStyle: const SystemUiOverlayStyle(
                              statusBarColor: Colors.black,
                              statusBarIconBrightness: Brightness.light,
                              // For Android (dark icons)
                              statusBarBrightness:
                              Brightness.dark, // For iOS (dark icons)
                            ),
                            backgroundColor: Colors.black,
                            elevation: 0.0,
                            toolbarHeight: 0,
                          ),
                          body: Center(
                            child: FadeInImage(
                              fit: BoxFit.fill,
                              image: FileImage(File(widget.chatImages![itemIndex]!.path)),
                              placeholder:
                              const AssetImage("assets/images/placeholder.jpg"),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/error.png',
                                    fit: BoxFit.fill);
                              },
                            ),
                          ),
                        ),
                        maxScale: 3.5,
                        panEnabled: true,
                        scaleEnabled: true,
                      ),
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height *0.50,
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
                        enlargeStrategy: CenterPageEnlargeStrategy.scale
                    ),
                ),
            ),
          );
        },
      ),
    );
  }
}
