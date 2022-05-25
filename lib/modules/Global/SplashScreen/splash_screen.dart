import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/splash_states.dart';
import 'cubit/splash_cubit.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..createMediaFolder()..navigate(context),
      child: BlocConsumer<SplashCubit, SplashStates>(
        listener: (context, state) {},
        builder: (context, state){

          return Container(
              constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
          ),
            child: Image.asset("assets/images/splash.png",
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
            alignment: Alignment.center,)
          );
        },
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildImage(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions.customChild(
      child: Image.asset("assets/images/splash.png"),
      initialScale: PhotoViewComputedScale.contained,
      minScale: 1.0,

    );
  }

}
