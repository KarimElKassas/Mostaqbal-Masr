import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_setting_cubit.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_setting_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class SocialSettingsScreen extends StatelessWidget {
  var currentPassController = TextEditingController();
  var newPassController = TextEditingController();
  var confirmNewPassController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialSettingCubit(),
      child: BlocConsumer<SocialSettingCubit, SocialSettingStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SocialSettingCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF0500A0),
                title: const Text("الاعدادات"),
              ),
              floatingActionButton: BuildCondition(
                condition: state is SocialSettingLoadingState,
                builder: (context) => const CircularProgressIndicator(
                  color: Color(0xFF0500A0),
                ),
                fallback: (context) => FloatingActionButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      cubit.changePassword(
                          context,
                          newPassController.text.toString(),
                          currentPassController.text.toString());
                    }
                  },
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  backgroundColor: Color(purpleColor),
                  elevation: 15.0,
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              body: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SlideInRight(
                              animate: true,
                              from: 1000,
                              //delay: Duration(milliseconds: 800),
                              duration: Duration(seconds: 2),
                              child: TextFormField(
                                textDirection: TextDirection.rtl,
                                controller: currentPassController,
                                keyboardType: TextInputType.text,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'يجب ادخال كلمة السر الحالية !';
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: 'كلمة السر الحالية',
                                  alignLabelWithHint: true,
                                  hintTextDirection: TextDirection.rtl,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            SlideInRight(
                              animate: true,
                              from: 1000,
                              delay: const Duration(milliseconds: 1000),
                              duration: const Duration(milliseconds: 2000),
                              child: TextFormField(
                                textDirection: TextDirection.rtl,
                                controller: newPassController,
                                keyboardType: TextInputType.text,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'يجب ادخال كلمة السر الجديدة !';
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: 'كلمة السر الجديدة',
                                  alignLabelWithHint: true,
                                  hintTextDirection: TextDirection.rtl,
                                  prefixIcon: Icon(
                                    Icons.password_rounded,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                            SlideInRight(
                              animate: true,
                              from: 1000,
                              delay: const Duration(milliseconds: 1500),
                              duration: const Duration(milliseconds: 2000),
                              child: TextFormField(
                                textDirection: TextDirection.rtl,
                                controller: confirmNewPassController,
                                keyboardType: TextInputType.text,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'يجب ادخال تأكيد كلمة السر الجديدة !';
                                  }
                                  if (value != newPassController.text) {
                                    return 'كلمتا السر غير متطابقتين !';
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: 'تأكيد كلمة السر الجديدة',
                                  alignLabelWithHint: true,
                                  hintTextDirection: TextDirection.rtl,
                                  prefixIcon: Icon(
                                    Icons.password_rounded,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16.0,
                            ),
                          ],
                        ),
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
