import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Global/Login/cubit/clerk_login_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/registration/screens/clerk_registration_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';

import '../Complaints/clerk/screens/complaint_screen.dart';
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
      child: BlocConsumer<ClerkLoginCubit, ClerkLoginStates>(listener: (context, state) {
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
          child: SafeArea(
            child: Scaffold(
              floatingActionButton: FadeInUp(
                duration: const Duration(seconds: 1),
                child: BuildCondition(
                  condition: state is! ClerkLoginLoadingSignIn,
                  fallback: (context) => CircularProgressIndicator(
                    color: Colors.teal[700],
                    strokeWidth: 0.8,
                  ),
                  builder: (context) => FloatingActionButton(
                    child: const Icon(
                      IconlyBroken.login,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.teal[700],
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        cubit.signInUser(context, nameController.text.toString(),
                            passwordController.text.toString());
                      }
                    },
                    heroTag: null,
                  ),
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
                                fontWeight: FontWeight.normal,
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
                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'يجب ادخال الرقم القومى / العسكرى !';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 1.0),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                                floatingLabelStyle:
                                TextStyle(color: Colors.teal[700]),
                                labelText: 'الرقم القومى / العسكرى',
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
                                        color: Colors.teal, width: 1.0),
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
                            const SizedBox(height: 12.0,),
                            InkWell(
                              onTap: (){
                                navigateTo(context, ClerkRegistrationScreen());
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'انشاء حساب',
                                  style: TextStyle(
                                    color: Colors.teal[500],
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
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
