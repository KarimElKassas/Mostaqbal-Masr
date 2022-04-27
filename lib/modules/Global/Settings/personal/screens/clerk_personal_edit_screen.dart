import 'dart:io';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../shared/components.dart';
import '../../../../../shared/constants.dart';
import '../cubit/clerk_personal_cubit.dart';
import '../cubit/clerk_personal_states.dart';

class ClerkPersonalEditScreen extends StatefulWidget {
  ClerkPersonalEditScreen(
      {Key? key,
      required this.userID,
      required this.userName,
      required this.userPhone,
      required this.userPassword,
      required this.userImageUrl,
      required this.userDocNumber})
      : super(key: key);

  final String userID,
      userName,
      userPhone,
      userPassword,
      userImageUrl,
      userDocNumber;
  @override
  State<ClerkPersonalEditScreen> createState() =>
      _ClerkPersonalEditScreenState();
}

class _ClerkPersonalEditScreenState
    extends State<ClerkPersonalEditScreen> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var docNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.userName;
    phoneController.text = widget.userPhone;
    passwordController.text = widget.userPassword;
    docNumberController.text = widget.userDocNumber;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => ClerkPersonalCubit()
          ..getUserData()
          ..getCities(),
        child: BlocConsumer<ClerkPersonalCubit, ClerkPersonalStates>(
          listener: (context, state) {
            if (state is ClerkPersonalEditSuccessState) {
              for (int i = 0; i < 3; i++) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              }
            }
            if (state is ClerkPersonalEditLoadingState) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => const BlurryProgressDialog(title: "جارى تعديل البيانات ...",));
            }
          },
          builder: (context, state) {
            var cubit = ClerkPersonalCubit.get(context);

            return WillPopScope(
              onWillPop: () {
                if (cubit.cityBottomSheetController != null) {
                  cubit.closeCityBottomSheet();
                } else if (cubit.regionBottomSheetController != null) {
                  cubit.closeRegionBottomSheet();
                } else {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).pop();
                  } else {
                    SystemNavigator.pop();
                  }
                }
                return Future.value(false);
              },
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  key: cubit.scaffoldKey,
                  appBar: AppBar(
                    automaticallyImplyLeading: true,
                    title: Text(
                      "تعديل الملف الشخصى",
                      style: TextStyle(color: Colors.teal[700], fontSize: 12),
                    ),
                    backgroundColor: Colors.white,
                    actionsIconTheme: IconThemeData(color: Colors.teal[700]),
                    iconTheme: IconThemeData(color: Colors.teal[700]),
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      statusBarIconBrightness: Brightness.dark,
                      // For Android (dark icons)
                      statusBarBrightness:
                          Brightness.light, // For iOS (dark icons)
                    ),
                  ),
                  body: Form(
                    key: key,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  cubit.selectImage();
                                },
                                child: SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: CircleAvatar(
                                    radius: 160,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(90),
                                      child: BuildCondition(
                                        condition:
                                            widget.userImageUrl == "NULL",
                                        builder: (context) => CircleAvatar(
                                          child: const Icon(
                                            Icons.add_photo_alternate,
                                            color: Colors.white,
                                            size: 76,
                                          ),
                                          backgroundColor: Colors.teal.shade700,
                                          maxRadius: 160,
                                        ),
                                        fallback: (context) => SizedBox(
                                          width: 160,
                                          height: 160,
                                          child: cubit.oldImage
                                              ? CachedNetworkImage(
                                                  imageUrl: widget.userImageUrl,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14.0),
                                                    child: FadeInImage(
                                                      fit: BoxFit.scaleDown,
                                                      image: imageProvider,
                                                      placeholder: const AssetImage(
                                                          "assets/images/placeholder.jpg"),
                                                      imageErrorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        return Image.asset(
                                                          'assets/images/error.png',
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                    color: Colors.teal,
                                                    strokeWidth: 0.8,
                                                  )),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const FadeInImage(
                                                    fit: BoxFit.cover,
                                                    image: AssetImage(
                                                        "assets/images/error.png"),
                                                    placeholder: AssetImage(
                                                        "assets/images/placeholder.jpg"),
                                                  ),
                                                )
                                              : Image.file(
                                                  File(cubit.imageUrl)),
                                        ),
                                      ),
                                    ),
                                    backgroundColor: Colors.grey.shade50,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 48,
                            ),
                            TextFormField(
                              textDirection: TextDirection.rtl,
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              autofocus: false,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'يجب ادخال اسم المستخدم !';
                                }
                              },
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                floatingLabelStyle: TextStyle(
                                    color: Colors.teal[700], fontSize: 12),
                                labelText: 'اسم المستخدم',
                                labelStyle: TextStyle(
                                    color: Colors.teal[700], fontSize: 12),
                                alignLabelWithHint: true,
                                hintTextDirection: TextDirection.rtl,
                                prefixIcon: Icon(
                                  IconlyBroken.profile,
                                  color: Colors.teal[700],
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 1.0),
                                ),
                              ),
                              style: TextStyle(
                                  color: Colors.teal[700], fontSize: 12),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              textDirection: TextDirection.rtl,
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              autofocus: false,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'يجب ادخال كلمة السر !';
                                }
                                if (value.length < 6) {
                                  return 'كلمة السر يجب ان تتكون من 6 حروف او ارقام على الاقل';
                                }
                              },
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                disabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0))),
                                floatingLabelStyle: TextStyle(
                                    color: Colors.teal[700], fontSize: 12),
                                labelText: 'كلمة السر',
                                labelStyle: TextStyle(
                                    color: Colors.teal[700], fontSize: 12),
                                alignLabelWithHint: true,
                                hintTextDirection: TextDirection.rtl,
                                prefixIcon: Icon(
                                  IconlyBroken.lock,
                                  color: Colors.teal[700],
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 1.0),
                                ),
                              ),
                              style: TextStyle(
                                  color: Colors.teal[700], fontSize: 12),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            InkWell(
                              onTap: () {

                                if (key.currentState!.validate()) {
                                  cubit.updateUserData(
                                      widget.userID,
                                      nameController.text.toString(),
                                      passwordController.text.toString());
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.teal.shade700,
                                      spreadRadius: 0.16,
                                      blurRadius: 0,
                                      offset: const Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.teal.shade500,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 45,
                                child: const Center(
                                    child: Text(
                                  "حفظ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
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
