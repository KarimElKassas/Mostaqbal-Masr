import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mostaqbal_masr/shared/gallery_item_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


// to view image in full screen
class GalleryImageWrapper extends StatefulWidget {
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final int? initialIndex;
  final PageController pageController;
  final List<dynamic> galleryItems;
  final Axis scrollDirection;
  final String? titleGallery;

  GalleryImageWrapper({Key? key,
    this.loadingBuilder,
    this.titleGallery,
    this.backgroundDecoration,
    this.initialIndex,
    required this.galleryItems,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex ?? 0), super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GalleryImageWrapperState();
  }
}

class _GalleryImageWrapperState extends State<GalleryImageWrapper> {
  final minScale = PhotoViewComputedScale.contained * 0.8;
  final maxScale = PhotoViewComputedScale.covered * 8;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
      ),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: _buildImage,
          itemCount: widget.galleryItems.length,
          loadingBuilder: widget.loadingBuilder,
          backgroundDecoration: widget.backgroundDecoration,
          pageController: widget.pageController,
          scrollDirection: widget.scrollDirection,
        ),
      ),
    );
  }

// build image with zooming
  PhotoViewGalleryPageOptions _buildImage(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions.customChild(
      child: CachedNetworkImage(
        imageUrl: widget.galleryItems[index]!.toString(),
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,)),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
      initialScale: PhotoViewComputedScale.contained,
      minScale: minScale,
      maxScale: maxScale,
      heroAttributes: PhotoViewHeroAttributes(tag: widget.galleryItems[index]!.toString()),
    );
  }
}