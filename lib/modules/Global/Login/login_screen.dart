import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/layout/home_layout.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/layout/social_home_layout.dart';
import 'package:mostaqbal_masr/shared/components.dart';

import 'cubit/login_cubit.dart';
import 'cubit/login_states.dart';

class LoginScreen extends StatelessWidget {

  var nameController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
        if (state is LoginErrorState) {
          showToast(
            message: state.error,
            length: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
        }

        if (state is LoginSuccessState) {
          navigateAndFinish(context, SocialHomeLayout());
        }
      }, builder: (context, state) {
        var cubit = LoginCubit.get(context);

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(
                left: 24.0, right: 24.0, top: 86.0, bottom: 16.0),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'مرحباً بك',
                          style: TextStyle(
                            color: Color(0xFF000043),
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        const Text(
                          'قم بتسجيل الدخول',
                          style: TextStyle(
                            color: Color(0xFF858484),
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(
                          height: 36.0,
                        ),
                        TextFormField(
                          textDirection: TextDirection.rtl,
                          controller: nameController,
                          keyboardType: TextInputType.text,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'يجب ادخال اسم المستخدم !';
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'اسم المستخدم',
                            alignLabelWithHint: true,
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: Icon(
                              Icons.supervised_user_circle_rounded,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 36.0,
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
                            labelText: 'كلمة السر',
                            alignLabelWithHint: true,
                            hintTextDirection: TextDirection.rtl,
                            prefixIcon: const Icon(
                              Icons.lock_rounded,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                cubit.changePasswordVisibility();
                              },
                              icon: Icon(cubit.isPassword
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded),
                            ),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 36.0,
                        ),
                        BuildCondition(
                          condition: state is! LoginLoadingSignIn,
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator(color: Color(0xFF000043),)),
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.signInUser(
                                    nameController.text.toString()+"",
                                    passwordController.text.toString()+"");
                              }
                            },
                            text: 'تسجيل الدخول',
                            background: const Color(0xFF000043),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/*Center(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "مرحباً بك",
                  style: TextStyle(
                    color: Color(0xFF000043),
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  "قم بتسجيل الدخول",
                  style: TextStyle(
                    color: Color(0xFF858484),
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),*/
