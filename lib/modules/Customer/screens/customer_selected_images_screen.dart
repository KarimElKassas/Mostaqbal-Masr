import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_selected_images_cubit.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_selected_images_states.dart';

class CustomerSelectedImagesScreen extends StatefulWidget {
  final List<XFile?>? chatImages;
  const CustomerSelectedImagesScreen({Key? key, required this.chatImages}) : super(key: key);

  @override
  State<CustomerSelectedImagesScreen> createState() => _CustomerSelectedImagesScreenState();
}

class _CustomerSelectedImagesScreenState extends State<CustomerSelectedImagesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerSelectedImagesCubit()..getUserData(),
      child: BlocConsumer<CustomerSelectedImagesCubit, CustomerSelectedImagesStates>(
        listener: (context, state){},
        builder: (context, state){

          var cubit = CustomerSelectedImagesCubit.get(context);

          return Scaffold(
            backgroundColor: Colors.black,
            floatingActionButton: BuildCondition(
              condition: state is CustomerSelectedImagesUploadingState,
              builder: (context) => CircularProgressIndicator(
                color: Colors.teal[700],
                strokeWidth: 0.8,
              ),
              fallback: (context) => FadeInUp(
                duration: const Duration(seconds: 1),
                child: FloatingActionButton(
                  onPressed: () async {
                    cubit.uploadMultipleImages(context);
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
