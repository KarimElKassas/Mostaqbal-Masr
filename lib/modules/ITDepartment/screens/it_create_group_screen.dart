import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/models/clerk_model.dart';
import 'package:mostaqbal_masr/models/firebase_clerk_model.dart';
import 'package:mostaqbal_masr/models/user_model.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/cubit/home/home_cubit.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/cubit/home/home_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class ITCreateGroupScreen extends StatefulWidget {

  final List<ClerkFirebaseModel> selectedUsersList;

  const ITCreateGroupScreen({Key? key, required this.selectedUsersList}) : super(key: key);

  @override
  State<ITCreateGroupScreen> createState() => _ITCreateGroupScreenState();
}

class _ITCreateGroupScreenState extends State<ITCreateGroupScreen> {
  var groupNameController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ITHomeCubit()..getUsers(),
      child: BlocConsumer<ITHomeCubit, ITHomeStates>(
        listener: (context, state) {

          if(state is ITHomeCreateGroupSuccessState){
            showToast(message: "تم انشاء الجروب بنجاح", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
          }
          if(state is ITHomeCreateGroupErrorState){
            showToast(message: state.error, length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
          }
        },
        builder: (context, state) {
          var cubit = ITHomeCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 0.0,
              toolbarHeight: 0.0,
              backgroundColor: Colors.transparent,
            ),
            floatingActionButton: FadeInUp(
              duration: const Duration(seconds: 1),
              child: BuildCondition(
                condition: state is ITHomeLoadingCreateGroupState,
                builder: (context) => const CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,),
                fallback: (context) => FloatingActionButton(
                  onPressed: () {
                    if(formKey.currentState!.validate()){
                      if(!cubit.emptyImage){
                        cubit.createGroup(context,groupNameController.text.toString());
                      }else{
                        showToast(message: "يجب اختيار صورة الجروب", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
                      }
                    }
                  },
                  child: const Icon(
                    Icons.done_rounded,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.teal[700],
                  elevation: 15.0,
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            body: Form(
              key: formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, right: 12.0, left: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  textDirection: TextDirection.rtl,
                                  controller: groupNameController,
                                  keyboardType: TextInputType.text,
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'يجب ادخال اسم الجروب';
                                    }
                                  },
                                  autofocus: false,
                                  style: TextStyle(color: Colors.teal[700], fontSize: 14),
                                  decoration: InputDecoration(
                                    focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.teal, width: 2.0),
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                    floatingLabelStyle:
                                    TextStyle(color: Colors.teal[700], fontSize: 14),
                                    labelText: 'اسم الجروب',
                                    labelStyle: const TextStyle(fontSize: 14),
                                    alignLabelWithHint: true,
                                    hintTextDirection: TextDirection.rtl,
                                    prefixIcon: Icon(
                                      IconlyBroken.home,
                                      color: Colors.teal[700],
                                    ),
                                    border: const OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  clipBehavior: Clip.none ,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 60,
                                      child: CircleAvatar(
                                        radius: 20,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(32.0),
                                              topRight: Radius.circular(32.0),
                                              bottomLeft: Radius.circular(32.0),
                                              bottomRight: Radius.circular(32.0)),
                                          child: BuildCondition(
                                            condition: cubit.emptyImage == true,
                                            builder: (context) => const CircleAvatar(
                                              child: Icon(
                                                Icons.group,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              backgroundColor: Colors.grey,
                                              maxRadius: 60,
                                            ),
                                            fallback: (context) => SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: Image.file(
                                                File(cubit.imageUrl),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -10,
                                      child: InkWell(
                                        onTap: (){
                                          cubit.selectImage();
                                        },
                                        child: const SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircleAvatar(
                                            child: Icon(
                                              Icons.add_to_photos,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            backgroundColor: Colors.teal,
                                            maxRadius: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        BuildCondition(
                          condition: state is ITHomeLoadingUsersState,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(
                              color: Colors.teal[700],
                              strokeWidth: 0.8,
                            ),
                          ),
                          fallback: (context) => ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) =>
                                listItem(context, cubit, state, index),
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 10.0),
                            itemCount: widget.selectedUsersList.length,
                          ),
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

  Widget listItem(BuildContext context, ITHomeCubit cubit, state, int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        elevation: 2,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        shadowColor: Colors.black,
        child: InkWell(
          onTap: () {

          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                BuildCondition(
                  condition: state is ITHomeLoadingUsersState,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                      strokeWidth: 0.8,
                    ),
                  ),
                  fallback: (context) => InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return SlideInUp(
                                duration: const Duration(milliseconds: 500),
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) {
                                                return CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  imageUrl: widget.selectedUsersList[index]
                                                      .clerkImage!,
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                    color: Colors.teal,
                                                    strokeWidth: 0.8,
                                                  )),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: widget.selectedUsersList[index]
                                                .clerkImage!,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.55,
                                            width: double.infinity,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                              color: Colors.teal,
                                              strokeWidth: 0.8,
                                            )),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: ClipOval(
                      child: CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: widget.selectedUsersList[index].clerkImage!,
                        height: 50,
                        width: 50,
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                          color: Colors.teal,
                          strokeWidth: 0.8,
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      widget.selectedUsersList[index].clerkName!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
