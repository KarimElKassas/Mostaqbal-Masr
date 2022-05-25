import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Global/Login/cubit/clerk_login_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/registration/screens/clerk_registration_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';

import 'cubit/clerk_login_states.dart';

// ignore: must_be_immutable
class ClerkLoginScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  ClerkLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClerkLoginCubit(),
      child: BlocConsumer<ClerkLoginCubit, ClerkLoginStates>(
          listener: (context, state) {
        if (state is ClerkLoginErrorState) {
          showToast(
            message: state.error,
            length: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
        } else if (state is ClerkLoginSharedPrefErrorState) {
          showToast(
            message: state.error,
            length: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
        }

        if (state is ClerkLoginSuccessState) {
          showToast(
            message: 'تم تسجيل الدخول بنجاح',
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
        }
      }, builder: (context, state) {
        var cubit = ClerkLoginCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                  systemOverlayStyle: const SystemUiOverlayStyle(
                    statusBarColor: Color(0xff013d17),
                    statusBarIconBrightness: Brightness.light,
                    // For Android (dark icons)
                    statusBarBrightness: Brightness.dark, // For iOS (dark icons)
                  ),
                  toolbarHeight: 0,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  ),
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/login_back.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 24.0, top: 86.0, bottom: 64.0),
                  child: Stack(
                    children: [
                      Center(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Form(
                            key: formKey,
                            child: FadeIn(
                              duration: const Duration(seconds: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    textDirection: TextDirection.rtl,
                                    controller: nameController,
                                    keyboardType: TextInputType.number,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'يجب ادخال الرقم القومى / العسكرى !';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 16),
                                      filled: true,
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32)),
                                      ),
                                      disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32)),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32)),
                                      ),
                                      floatingLabelStyle:
                                          TextStyle(color: Colors.teal[700]),
                                      hintText: 'الرقم القومى / العسكرى',
                                      hintStyle: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.teal,
                                          fontFamily: "Hamed",
                                          fontWeight: FontWeight.w500),
                                      fillColor: Colors.white,
                                      //alignLabelWithHint: true,
                                      errorStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xffBF9A35),
                                          fontFamily: "Hamed",
                                          fontWeight: FontWeight.w500),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      hintTextDirection: TextDirection.rtl,
                                      prefixIcon: Icon(
                                        IconlyBroken.profile,
                                        color: Colors.teal[700],
                                      ),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32))),
                                    ),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.teal,
                                        fontFamily: "Hamed",
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 22.0,
                                  ),
                                  TextFormField(
                                    textDirection: TextDirection.rtl,
                                    controller: passwordController,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: cubit.isPassword,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'يجب ادخال كلمة السر !';
                                      }
                                    },
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 16),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32)),
                                      ),
                                      disabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32)),
                                      ),
                                      errorBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 0.5),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32)),
                                      ),
                                      floatingLabelStyle:
                                          TextStyle(color: Colors.teal[700]),
                                      errorStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xffBF9A35),
                                          fontFamily: "Hamed",
                                          fontWeight: FontWeight.w500),
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'كلمة السر',
                                      hintStyle: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.teal,
                                          fontFamily: "Hamed",
                                          fontWeight: FontWeight.w500),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      hintTextDirection: TextDirection.rtl,
                                      prefixIcon: Icon(
                                        IconlyBroken.password,
                                        color: Colors.teal[700],
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          cubit.changePasswordVisibility();
                                        },
                                        icon: Icon(
                                          cubit.isPassword
                                              ? Icons.visibility_rounded
                                              : Icons.visibility_off_rounded,
                                          color: Colors.teal[700],
                                        ),
                                      ),
                                      border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32))),
                                    ),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        color: Colors.teal,
                                        fontFamily: "Hamed",
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'هل نسيت كلمة السر؟',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Hamed",
                                          decoration:
                                              TextDecoration.underline),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 64.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 2000),
                          child: BuildCondition(
                            condition: state is ClerkLoginLoadingSignIn,
                            builder: (context) => const CircularProgressIndicator(color: Color(0xffBF9A35), strokeWidth: 2,),
                            fallback: (context) => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultButton(
                                    function: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.signInUser(
                                            context,
                                            nameController.text.toString(),
                                            passwordController.text.toString());
                                      }
                                    },
                                    width: MediaQuery.of(context).size.width * 0.40,
                                    text: 'تسجيل الدخول',
                                    radius: 32,
                                    background: Colors.white,
                                    textColor: Colors.teal,
                                    textStyle: const TextStyle(
                                        color: Colors.teal,
                                        fontFamily: "Hamed",
                                        fontSize: 18)),
                                const SizedBox(
                                  height: 12,
                                ),
                                InkWell(
                                  onTap: (){
                                    navigateTo(
                                        context, const ClerkRegistrationScreen());
                                  },
                                  child: RichText(
                                    text: const TextSpan(
                                      text: "مستخدم جديد؟ ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16, fontFamily: "Hamed"),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'تسجيل',
                                            style: TextStyle(color: Color(0xffBF9A35), fontSize: 16, fontFamily: "Hamed")),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                    alignment: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
        );
      }),
    );

  }
}
