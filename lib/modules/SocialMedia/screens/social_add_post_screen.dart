import 'dart:io' as i;
import 'dart:ui' as ui;

import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/add_post_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/add_post_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class SocialAddPostScreen extends StatelessWidget {
  var postTextController = TextEditingController();
  var postVideoIDController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

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
          } else if (state is SocialAddPostSuccessState) {
            postTextController.text = "";
            postVideoIDController.text = "";
            dateController.text = "";

            FocusScope.of(context).unfocus();
          }
        },
        builder: (context, state) {
          var cubit = SocialAddPostCubit.get(context);

          return Directionality(
            textDirection: ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.teal[700],
                title: const Text("اضافة خبر"),
                elevation: 10.0,
              ),
              floatingActionButton: FadeInUp(
                duration: const Duration(seconds: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      child: const Icon(
                        Icons.image_search,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.teal[700],
                      onPressed: () {
                        cubit.selectImages();
                      },
                      heroTag: null,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    BuildCondition(
                      condition: state is! SocialAddPostLoadingState,
                      fallback: (context) => CircularProgressIndicator(
                        color: Colors.teal[700],
                      ),
                      builder: (context) => FloatingActionButton(
                        child: const Icon(
                          IconlyBroken.plus,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.teal[700],
                        onPressed: () async {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.none) {
                            showToast(
                              message: 'تحقق من اتصالك بالانترنت اولاً',
                              length: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                            );
                          } else {
                            if (formKey.currentState!.validate()) {
                              cubit.addPost(
                                  postTextController.text.toString(),
                                  postVideoIDController.text.toString());
                            }
                          }
                        },
                        heroTag: null,
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              body: FadeInDown(
                duration: const Duration(seconds: 1),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Visibility(
                            visible:
                                cubit.imageFileList!.isNotEmpty ? true : false,
                            child: GridView.builder(
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
                                        i.File(
                                            cubit.imageFileList![index].path),
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
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            textDirection: ui.TextDirection.rtl,
                            controller: postTextController,
                            keyboardType: TextInputType.text,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'يجب ادخال موضوع الخبر !';
                              }
                            },
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 2.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.teal[700]),
                              labelText: 'نص الخبر',
                              alignLabelWithHint: true,
                              hintTextDirection: ui.TextDirection.rtl,
                              prefixIcon: Icon(
                                IconlyBroken.edit,
                                color: Colors.teal[700],
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                            ),
                          ),
                          const SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            textDirection: ui.TextDirection.rtl,
                            controller: postVideoIDController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.teal, width: 2.0),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.teal[700]),
                              labelText: 'رابط الفيديو إن وجد',
                              alignLabelWithHint: true,
                              hintTextDirection: ui.TextDirection.rtl,
                              prefixIcon: Icon(
                                IconlyBroken.video,
                                color: Colors.teal[700],
                              ),
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                            ),
                          ),
                          const SizedBox(
                            height: 24.0,
                          ),
                        ],
                      ),
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
