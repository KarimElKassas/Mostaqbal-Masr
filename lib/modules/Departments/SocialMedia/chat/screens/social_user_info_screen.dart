import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialUserInfoScreen extends StatelessWidget {

  final String userImage;
  final String userName;
  final String userID;

  const SocialUserInfoScreen({Key? key, required this.userImage, required this.userName, required this.userID}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 48.0,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 90,
                width: 90,
                child: CachedNetworkImage(
                  imageUrl: userImage,
                  imageBuilder: (context, imageProvider) => ClipOval(
                    child: FadeInImage(
                      height: 90,
                      width: 90,
                      fit: BoxFit.fill,
                      image: imageProvider,
                      placeholder: const AssetImage("assets/images/placeholder.jpg"),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/error.png',
                          fit: BoxFit.fill,
                          height: 90,
                          width: 90,
                        );
                      },
                    ),
                  ),
                  placeholder: (context, url) => const FadeInImage(
                    height: 90,
                    width: 90,
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/placeholder.jpg"),
                    placeholder: AssetImage("assets/images/placeholder.jpg"),
                  ),
                  errorWidget: (context, url, error) => const FadeInImage(
                    height: 90,
                    width: 90,
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/error.png"),
                    placeholder: AssetImage("assets/images/placeholder.jpg"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
