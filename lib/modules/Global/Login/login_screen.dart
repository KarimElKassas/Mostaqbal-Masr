import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Mechan/layout/mechan_home_layout.dart';
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
      child: BlocConsumer<LoginCubit, LoginStates>(listener: (context, state) {
        if (state is LoginErrorState) {
          showToast(
            message: state.error,
            length: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
        } else if (state is LoginSharedPrefErrorState) {
          showToast(
            message: state.error,
            length: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
        }

        if (state is LoginSuccessState) {
          showToast(
            message: 'تم تسجيل الدخول بنجاح',
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
          switch (state.sectionName) {
            case "إدارة التسويق":
              navigateAndFinish(context, SocialHomeLayout());
              break;
            case "الميكنة الزراعية":
              navigateAndFinish(context, MechanHomeLayout());
              break;
          }
        }
      }, builder: (context, state) {
        var cubit = LoginCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              floatingActionButton: FadeInUp(
                duration: const Duration(seconds: 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BuildCondition(
                      condition: state is! LoginLoadingSignIn,
                      fallback: (context) => CircularProgressIndicator(
                        color: Colors.teal[700],
                      ),
                      builder: (context) => FloatingActionButton(
                        child: const Icon(
                          IconlyBroken.login,
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
                              cubit.signInUser(nameController.text.toString(),
                                  passwordController.text.toString());
                            }
                          }
                        },
                        heroTag: null,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FloatingActionButton(
                      child: const Icon(
                        IconlyBroken.arrowLeftCircle,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.teal[700],
                      onPressed: () {
                        cubit.backToPosts(context);
                      },
                      heroTag: null,
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              body: Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, top: 86.0, bottom: 86.0),
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: FadeInDown(
                        duration: const Duration(seconds: 2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'مرحباً بك',
                              style: TextStyle(
                                color: Colors.teal[500],
                                fontSize: 30.0,
                                fontWeight: FontWeight.w700,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              'قم بتسجيل الدخول',
                              style: TextStyle(
                                color: Colors.teal[500],
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
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                floatingLabelStyle:
                                    TextStyle(color: Colors.teal[700]),
                                labelText: 'اسم المستخدم',
                                alignLabelWithHint: true,
                                hintTextDirection: TextDirection.rtl,
                                prefixIcon: Icon(
                                  IconlyBroken.profile,
                                  color: Colors.teal[700],
                                ),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
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
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                floatingLabelStyle:
                                    TextStyle(color: Colors.teal[700]),
                                labelText: 'كلمة السر',
                                alignLabelWithHint: true,
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
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
              ),
            ),
          ),
        );
      }),
    );
  }
}
