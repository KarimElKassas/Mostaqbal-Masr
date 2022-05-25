import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/cubit/social_conversation_cubit.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../cubit/selected_images_cubit.dart';
import '../cubit/selected_images_states.dart';
import '../cubit/social_conversation_states.dart';

class SocialSelectedImagesScreen extends StatefulWidget {
  final List<dynamic>? chatImages;
  final String receiverID;
  final String chatID;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final int? initialIndex;
  final PageController pageController;
  final Axis scrollDirection;
  final String? titleGallery;
  //final String groupID;
  SocialSelectedImagesScreen({Key? key,
    required this.chatImages,
    required this.receiverID,
    required this.chatID,
    this.loadingBuilder,
    this.titleGallery,
    this.backgroundDecoration,
    this.initialIndex,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex ?? 0) ,super(key: key);

  @override
  State<SocialSelectedImagesScreen> createState() => _SocialSelectedImagesScreenState();
}

class _SocialSelectedImagesScreenState extends State<SocialSelectedImagesScreen> {
  final minScale = PhotoViewComputedScale.contained * 0.8;
  final maxScale = PhotoViewComputedScale.covered * 8;

  @override
  Widget build(BuildContext context) {
    print(widget.chatImages);
    print("${widget.chatImages!.length}\n");
    return BlocProvider(
      create: (context) => SocialConversationCubit(),
      child: BlocConsumer<SocialConversationCubit, SocialConversationStates>(
        listener: (context, state){},
        builder: (context, state){

          var cubit = SocialConversationCubit.get(context);

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
                    await cubit.uploadMultipleImagesFireStore(context, widget.receiverID, widget.chatID);
                    Navigator.pop(context);
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
                child: Container(
                  //decoration: widget.backgroundDecoration,
                  constraints: BoxConstraints.expand(
                    height: MediaQuery.of(context).size.height,
                  ),
                  child: PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: _buildImage,
                    itemCount: widget.chatImages!.length,
                    loadingBuilder: widget.loadingBuilder,
                    backgroundDecoration: widget.backgroundDecoration,
                    pageController: widget.pageController,
                    scrollDirection: widget.scrollDirection,
                  ),
                ),
            ),
          );
        },
      ),
    );

  }
  PhotoViewGalleryPageOptions _buildImage(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions.customChild(
      child: FadeInImage(
        fit: BoxFit.fitWidth,
        image: FileImage(File(widget.chatImages![index].toString())),
        placeholder:
        const AssetImage("assets/images/black_back.png"),
        imageErrorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/images/error.png',
              fit: BoxFit.fill);
        },
      ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: minScale,
      maxScale: maxScale,
      heroAttributes: PhotoViewHeroAttributes(tag: widget.chatImages![index].toString()),
    );
  }

}

