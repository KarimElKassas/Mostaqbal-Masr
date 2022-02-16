import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_login_cubit.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_login_states.dart';
import 'package:mostaqbal_masr/modules/Mechan/layout/mechan_home_layout.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/layout/social_home_layout.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class CustomerLoginScreen extends StatelessWidget {
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerLoginCubit(),
      child: BlocConsumer<CustomerLoginCubit, CustomerLoginStates>(
       listener: (context, state) {
        if (state is CustomerLoginErrorState) {
          showToast(
            message: state.error,
            length: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
        }else if(state is CustomerLoginGetDataErrorState){
          showToast(
            message: state.error,
            length: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
        }
      }, builder: (context, state) {
        var cubit = CustomerLoginCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
              floatingActionButton: FadeInUp(
                duration: const Duration(seconds: 1),
                child: BuildCondition(
                  condition: state is! CustomerLoginLoadingState,
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
                      if (formKey.currentState!.validate()) {
                        cubit.signInUser(phoneController.text.toString(),
                            passwordController.text.toString(), context);
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
                                fontSize: 24,
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
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(
                              height: 36.0,
                            ),
                            TextFormField(
                              textDirection: TextDirection.rtl,
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
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
                                        color: Colors.teal, width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                floatingLabelStyle:
                                    TextStyle(color: Colors.teal[700]),
                                labelText: 'رقم الهاتف',
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
                                if (value.length < 6) {
                                  return 'كلمة السر غير صحيحة';
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
