import 'dart:io' as i;

import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/add_post_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/add_post_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class SocialAddPostScreen extends StatelessWidget {
  var postTextController = TextEditingController();
  var postVideoIDController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialAddPostCubit(),
      child: BlocConsumer<SocialAddPostCubit, SocialAddPostStates>(
        listener: (context, state) {
          if (state is SocialAddPostErrorState) {
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }else if(state is SocialAddPostSuccessState){

            postTextController.text = "";
            postVideoIDController.text = "";

            FocusScope.of(context).unfocus();

          }
        },
        builder: (context, state) {
          var cubit = SocialAddPostCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF0500A0),
                title: const Text("اضافة خبر"),
                elevation: 10.0,
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            cubit.selectImages();
                          },
                          child: const Text("رفع صور"),
                        ),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: cubit.imageFileList!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.file(
                                    i.File(cubit.imageFileList![index].path),
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    child: InkWell(
                                      onTap: () {},
                                      child: IconButton(
                                        onPressed: () {
                                          cubit.deleteImage(index);
                                        },
                                        icon: const Icon(
                                          Icons.delete_forever_rounded,
                                          color: Colors.red,
                                          size: 25,
                                        ),
                                        color: const Color.fromRGBO(
                                            255, 244, 244, 0.3),
                                      ),
                                    ),
                                    right: -4,
                                    top: 0,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SlideInRight(
                          animate: true,
                          from: 1000,
                          //delay: Duration(milliseconds: 800),
                          duration: Duration(seconds: 2),
                          child: TextFormField(
                            textDirection: TextDirection.rtl,
                            controller: postTextController,
                            keyboardType: TextInputType.text,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'يجب ادخال موضوع الخبر !';
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: 'نص الخبر',
                              alignLabelWithHint: true,
                              hintTextDirection: TextDirection.rtl,
                              prefixIcon: Icon(
                                Icons.subtitles_rounded,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        SlideInRight(
                          animate: true,
                          from: 1000,
                          delay: const Duration(milliseconds: 1000),
                          duration: const Duration(milliseconds: 2000),
                          child: TextFormField(
                            textDirection: TextDirection.rtl,
                            controller: postVideoIDController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: 'رابط الفيديو إن وجد',
                              alignLabelWithHint: true,
                              hintTextDirection: TextDirection.rtl,
                              prefixIcon: Icon(
                                Icons.video_call,
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        BuildCondition(
                          condition: state is! SocialAddPostLoadingState,
                          fallback: (context) => const Center(
                              child: CircularProgressIndicator(
                            color: Color(0xFF0500A0),
                          )),
                          builder: (context) => SlideInRight(
                            animate: true,
                            from: 1000,
                            delay: const Duration(milliseconds: 1500),
                            duration: const Duration(milliseconds: 2000),
                            child: defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.addPost(
                                      postTextController.text.toString(),
                                      postVideoIDController.text.toString());
                                }
                              },
                              text: 'اضافة الخبر',
                              background: const Color(0xFF0500A0),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
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
}
