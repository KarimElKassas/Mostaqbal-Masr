import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatOpenedImageScreen extends StatelessWidget {

  final String imageUrl;
  const ChatOpenedImageScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
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
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (context, imageProvider) => ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: FadeInImage(
                fit: BoxFit.fill,
                image: imageProvider,
                placeholder: const AssetImage(
                    "assets/images/placeholder.jpg"),
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/error.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.teal,
                  strokeWidth: 0.8,
                )),
            errorWidget: (context, url, error) =>
            const FadeInImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/error.png"),
              placeholder:
              AssetImage("assets/images/placeholder.jpg"),
            ),
          ),
        ),
      ),
      maxScale: 3.5,
      panEnabled: true,
      scaleEnabled: true,
    );
  }
}
