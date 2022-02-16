import 'dart:async';
import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/models/clerk_model.dart';
import 'package:mostaqbal_masr/modules/Global/registration/cubit/clerk_register_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/registration/cubit/clerk_register_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

class ClerkConfirmRegistrationScreen extends StatefulWidget {

  final ClerkModel clerkModel;

  const ClerkConfirmRegistrationScreen({Key? key, required this.clerkModel}) : super(key: key);

  @override
  State<ClerkConfirmRegistrationScreen> createState() =>
      _ClerkConfirmRegistrationScreenState();
}

class _ClerkConfirmRegistrationScreenState extends State<ClerkConfirmRegistrationScreen> {
  var clerkPasswordController = TextEditingController();
  var clerkConfirmPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClerkRegisterCubit(),
      child: BlocConsumer<ClerkRegisterCubit, ClerkRegisterStates>(
        listener: (context, state) {
          if (state is ClerkRegisterGetClerksErrorState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if(state is ClerkRegisterNoClerkFoundState){
            showToast(
                message: "لا يوجد موظف مسجل بهذا الرقم\n برجاء التوجه الى شئون العاملين اولاً",
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
        },
        builder: (context, state) {
          var cubit = ClerkRegisterCubit.get(context);

          return Scaffold(
              floatingActionButton: BuildCondition(
                condition: state is ClerkRegisterLoadingUploadClerksState,
                builder: (context) => const CircularProgressIndicator(color: Colors.teal,strokeWidth: 0.8,),
                fallback: (context) => FadeInUp(
                    duration: const Duration(seconds: 1),
                    child: FloatingActionButton(
                      onPressed: () async {
                        if(formKey.currentState!.validate()){
                          if(clerkPasswordController.text.toString() != clerkConfirmPasswordController.text.toString()){
                            showToast(message: "كلمتا السر يجب ان تكونا متطابقتين", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
                            return;
                          }
                          if(cubit.emptyImage){
                            showToast(message: "يجب اختيار صورة المستخدم", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
                            return;
                          }
                          cubit.insertPersonName(
                              widget.clerkModel.clerkID??"", widget.clerkModel.clerkName??"",widget.clerkModel.personNumber??"", widget.clerkModel.personPhone??"", clerkPasswordController.text.toString(), widget.clerkModel.personAddress??"",
                              widget.clerkModel.managementName??"", widget.clerkModel.personTypeName??"", widget.clerkModel.rankName??"", widget.clerkModel.categoryName??"",
                              widget.clerkModel.personTypeName??"", widget.clerkModel.presenceName??"", widget.clerkModel.coreStrengthName??"");
                        }
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
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: clerkView(cubit),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget clerkView(ClerkRegisterCubit cubit){

    return Padding(
      padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0, bottom: 64.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18.0,),
              Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none ,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircleAvatar(
                        radius: 90,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(48.0),
                              topRight: Radius.circular(48.0),
                              bottomLeft: Radius.circular(48.0),
                              bottomRight: Radius.circular(48.0)),
                          child: BuildCondition(
                            condition: cubit.emptyImage == true,
                            builder: (context) => CircleAvatar(
                              child: const Icon(
                                IconlyBold.user2,
                                color: Colors.white,
                                size: 50,
                              ),
                              backgroundColor: Colors.grey.shade600,
                              maxRadius: 90,
                            ),
                            fallback: (context) => SizedBox(
                              width: 90,
                              height: 90,
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
                      bottom: -18,
                      child: InkWell(
                        onTap: (){
                          cubit.selectImage();
                        },
                        child: SizedBox(
                          width: 45,
                          height: 45,
                          child: CircleAvatar(
                            child: const Icon(
                              Icons.add_to_photos,
                              color: Colors.white,
                              size: 22,
                            ),
                            backgroundColor: Colors.teal[700],
                            maxRadius: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                child: Text(
                    "اسم الموظف :",
                  style: TextStyle(
                    color: Colors.teal[700],
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal
                  ),
                ),
              ),
              const SizedBox(height: 8.0,),
              TextFormField(
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.text,
                cursorColor: Colors.teal,
                readOnly: true,
                style: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.teal, width: 1.0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0))),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: widget.clerkModel.clerkName,
                  hintStyle: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                  hintTextDirection: TextDirection.rtl,
                  prefixIcon: Icon(
                    IconlyBold.profile,
                    color: Colors.teal[700],
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 18.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "رقم الهاتف :",
                  style: TextStyle(
                      color: Colors.teal[700],
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
              const SizedBox(height: 8.0,),
              TextFormField(
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.text,
                cursorColor: Colors.teal,
                readOnly: true,
                style: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.teal, width: 1.0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0))),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: widget.clerkModel.personPhone,
                  hintStyle: TextStyle(color: Colors.teal[700], fontSize: 16.0,letterSpacing: 1.5, fontWeight: FontWeight.bold),
                  hintTextDirection: TextDirection.rtl,
                  prefixIcon: Icon(
                    IconlyBold.call,
                    color: Colors.teal[700],
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 18.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "كلمة المرور :",
                  style: TextStyle(
                      color: Colors.teal[700],
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
              const SizedBox(height: 8.0,),
              TextFormField(
                controller: clerkPasswordController,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.visiblePassword,
                obscureText: cubit.isPassword,
                cursorColor: Colors.teal,
                  textInputAction: TextInputAction.next,
                style: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                validator: (String? value){
                  if(value!.isEmpty){
                    return "يجب ادخال كلمة المرور";
                  }else if(value.length < 6){
                    return "كلمة المرور يجب ان تكون اكبر من 6 حروف او ارقام";
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.teal, width: 1.0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0))),
                  labelStyle: TextStyle(color: Colors.teal[700], fontSize: 14.0, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: "كلمة المرور",
                  hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14.0, fontWeight: FontWeight.bold),
                  hintTextDirection: TextDirection.rtl,
                  prefixIcon: Icon(
                    IconlyBold.password,
                    color: Colors.teal[700],
                  ),
                  suffixIcon: IconButton(
                    onPressed: (){
                      cubit.changePasswordVisibility();
                    },
                    icon: Icon(
                      cubit.isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                      color: Colors.teal[700],
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 18.0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "تأكيد كلمة المرور :",
                  style: TextStyle(
                      color: Colors.teal[700],
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
              const SizedBox(height: 8.0,),
              TextFormField(
                controller: clerkConfirmPasswordController,
                textDirection: TextDirection.rtl,
                keyboardType: TextInputType.text,
                cursorColor: Colors.teal,
                obscureText: cubit.isConfirmPassword,
                textInputAction: TextInputAction.done,
                style: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                validator: (String? value){
                  if(value!.isEmpty){
                    return "يجب ادخال تأكيد كلمة المرور";
                  }else if(value.length < 6){
                    return "تأكيد كلمة المرور يجب ان تكون اكبر من 6 حروف او ارقام";
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.teal, width: 1.0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0))),
                  labelStyle: TextStyle(color: Colors.teal[700], fontSize: 14.0, letterSpacing: 1.5, fontWeight: FontWeight.bold),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  hintText: "تأكيد كلمة المرور",
                  hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 14.0, fontWeight: FontWeight.bold),
                  hintTextDirection: TextDirection.rtl,
                  prefixIcon: Icon(
                    IconlyBold.password,
                    color: Colors.teal[700],
                  ),
                  suffixIcon: IconButton(
                    onPressed: (){
                      cubit.changeConfirmPasswordVisibility();
                    },
                    icon: Icon(
                      cubit.isConfirmPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                      color: Colors.teal[700],
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  disabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
              const SizedBox(height: 12.0,),
            ],
          ),
        ),
      ),
    );
  }
}
