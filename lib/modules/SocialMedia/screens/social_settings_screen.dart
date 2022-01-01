import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        listener: (context, state) {
          if(state is SocialSettingLogOutErrorState){
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }else if(state is SocialSettingErrorState){
            showToast(
              message: state.error,
              length: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
            );
          }
        },
        builder: (context, state) {
          var cubit = SocialSettingCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.teal[700],
                title: const Text("الاعدادات"),
              ),
              floatingActionButton: BuildCondition(
                condition: state is SocialSettingLoadingState,
                builder: (context) => CircularProgressIndicator(
                  color: Colors.teal[700],
                ),
                fallback: (context) => FadeInUp(
                  duration: const Duration(seconds: 2),
                  child: FloatingActionButton(
                    onPressed: ()async {

                      var connectivityResult = await (Connectivity().checkConnectivity());
                      if(connectivityResult == ConnectivityResult.none){
                        showToast(
                          message: 'تحقق من اتصالك بالانترنت اولاً',
                          length: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                        );
                      }else{
                        if (formKey.currentState!.validate()) {
                          cubit.changePassword(
                              context,
                              newPassController.text.toString(),
                              currentPassController.text.toString());
                        }
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
                        child: FadeInDown(
                          duration: const Duration(seconds: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                textDirection: TextDirection.rtl,
                                controller: currentPassController,
                                keyboardType: TextInputType.text,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'يجب ادخال كلمة السر الحالية !';
                                  }
                                },
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.teal, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.teal[700]),
                                  labelText: 'كلمة السر الحالية',
                                  alignLabelWithHint: true,
                                  hintTextDirection: TextDirection.rtl,
                                  prefixIcon: Icon(
                                    IconlyBroken.password,
                                    color: Colors.teal[700],
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
                                textDirection: TextDirection.rtl,
                                controller: newPassController,
                                keyboardType: TextInputType.text,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'يجب ادخال كلمة السر الجديدة !';
                                  }
                                },
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.teal, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.teal[700]),
                                  labelText: 'كلمة السر الجديدة',
                                  alignLabelWithHint: true,
                                  hintTextDirection: TextDirection.rtl,
                                  prefixIcon: Icon(
                                    IconlyBold.password,
                                    color: Colors.teal[700],
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              TextFormField(
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
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.teal, width: 2.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.teal[700]),
                                  labelText: 'تأكيد كلمة السر الجديدة',
                                  alignLabelWithHint: true,
                                  hintTextDirection: TextDirection.rtl,
                                  prefixIcon: Icon(
                                    IconlyBold.password,
                                    color: Colors.teal[700],
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
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
            ),
          );
        },
      ),
    );
  }
}
