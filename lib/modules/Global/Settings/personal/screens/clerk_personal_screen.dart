import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../cubit/clerk_personal_cubit.dart';
import '../cubit/clerk_personal_states.dart';
import 'clerk_personal_edit_screen.dart';


class ClerkPersonalScreen extends StatefulWidget {
  ClerkPersonalScreen({Key? key , required this.userID, required this.userName, required this.userPhone, required this.userPassword, required this.userImageUrl, required this.userDocNumber,}) : super(key: key);

  final String userID, userName, userPhone, userPassword, userImageUrl, userDocNumber;
  @override
  State<ClerkPersonalScreen> createState() => _ClerkPersonalScreenState();
}

class _ClerkPersonalScreenState extends State<ClerkPersonalScreen> {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var docNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var cityController = TextEditingController();
  var regionController = TextEditingController();

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
      create: (context) => ClerkPersonalCubit()..getUserData(),
        child: BlocConsumer<ClerkPersonalCubit, ClerkPersonalStates>(
          listener: (context, state){},
          builder: (context, state){

            var cubit = ClerkPersonalCubit.get(context);

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  title: Text("الملف الشخصى", style: TextStyle(color: Colors.teal[700], fontSize: 12),),
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
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: (){
                              //cubit.selectImage();
                            },
                            child: SizedBox(
                              width: 160,
                              height: 160,
                              child: CircleAvatar(
                                radius: 160,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(90),
                                  child: BuildCondition(
                                    condition: widget.userImageUrl == "NULL",
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
                                      child: CachedNetworkImage(
                                        imageUrl: widget.userImageUrl,
                                        imageBuilder: (context, imageProvider) =>
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(14.0),
                                              child: FadeInImage(
                                                fit: BoxFit.scaleDown,
                                                image: imageProvider,
                                                placeholder: const AssetImage(
                                                    "assets/images/placeholder.jpg"),
                                                imageErrorBuilder:
                                                    (context, error, stackTrace) {
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
                                          image:
                                          AssetImage("assets/images/error.png"),
                                          placeholder: AssetImage(
                                              "assets/images/placeholder.jpg"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.grey.shade50,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 36,),
                        TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'يجب ادخال اسم المستخدم !';
                            }
                          },
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            floatingLabelStyle:
                            TextStyle(color: Colors.teal[700], fontSize: 12),
                            labelText: 'اسم المستخدم',
                            labelStyle: TextStyle(color: Colors.teal[700], fontSize: 12),

                            alignLabelWithHint: true,
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(
                              IconlyBroken.profile,
                              color: Colors.teal[700],
                            ),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0)),
                              borderSide: BorderSide(
                                  color: Colors.teal, width: 1.0),),
                          ),
                          style: TextStyle(color: Colors.teal[700], fontSize: 12),
                          enabled: false,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: phoneController,
                          keyboardType: TextInputType.text,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'يجب ادخال رقم الهاتف !';
                            }
                            if (value.length != 11) {
                              return 'رقم الهاتف يجب ان يكون 11 رقم فقط';
                            }
                            if (!value.startsWith('011') &&
                                !value.startsWith('012') &&
                                !value.startsWith('010') &&
                                !value.startsWith('015')) {
                              return 'رقم الهاتف يجب ان يكون تابع لاحدى شركات المحمول المصرية';
                            }
                          },
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            floatingLabelStyle:
                            TextStyle(color: Colors.teal[700], fontSize: 12),
                            labelText: 'رقم الهاتف',
                            labelStyle: TextStyle(color: Colors.teal[700], fontSize: 12),
                            alignLabelWithHint: true,
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(
                              IconlyBroken.call,
                              color: Colors.teal[700],
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)),
                              borderSide: BorderSide(
                                  color: Colors.teal, width: 1.0),),
                          ),
                          style: TextStyle(color: Colors.teal[700], fontSize: 12, letterSpacing: 2.5),
                          enabled: false,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: passwordController,
                          keyboardType: TextInputType.text,
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
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            floatingLabelStyle:
                            TextStyle(color: Colors.teal[700], fontSize: 12),
                            labelText: 'كلمة السر',
                            labelStyle: TextStyle(color: Colors.teal[700], fontSize: 12),
                            alignLabelWithHint: true,
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(
                              IconlyBroken.lock,
                              color: Colors.teal[700],
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)),
                              borderSide: BorderSide(
                                  color: Colors.teal, width: 1.0),),
                          ),
                          style: TextStyle(color: Colors.teal[700], fontSize: 12),
                          enabled: false,
                        ),
                        const SizedBox(height: 16,),
                        TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: docNumberController,
                          keyboardType: TextInputType.number,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'يجب ادخال الرقم القومى !';
                            }
                            if (value.length != 14) {
                              return 'الرقم القومى يجب ان يكون 14 رقم فقط';
                            }
                            if (value.startsWith('0')) {
                              return 'الرقم القومى غير صالح';
                            }
                            },
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.teal, width: 1.0),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(4.0))),
                            floatingLabelStyle:
                            TextStyle(color: Colors.teal[700], fontSize: 12),
                            labelText: 'رقم البطاقة الشخصية',
                            labelStyle: TextStyle(color: Colors.teal[700], fontSize: 12),
                            alignLabelWithHint: true,
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(
                              IconlyBroken.lock,
                              color: Colors.teal[700],
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(4.0)),
                              borderSide: BorderSide(
                                  color: Colors.teal, width: 1.0),),
                          ),
                          style: TextStyle(color: Colors.teal[700], fontSize: 12, letterSpacing: 2.5),
                          enabled: false,
                        ),
                        const SizedBox(height: 16,),
                        InkWell(
                          onTap: (){
                            cubit.navigate(context, ClerkPersonalEditScreen(userID: widget.userID, userName: widget.userName, userPhone: widget.userPhone, userPassword: widget.userPassword, userImageUrl: widget.userImageUrl, userDocNumber: widget.userDocNumber,));
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
                                  "تعديل البيانات",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )
    );
  }
}
