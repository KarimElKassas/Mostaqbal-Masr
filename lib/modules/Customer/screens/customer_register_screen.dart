import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_register_cubit.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_register_states.dart';
import 'package:mostaqbal_masr/modules/Customer/dropdown/select_drop_list.dart';
import 'package:mostaqbal_masr/modules/Customer/layout/customer_home_layout.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class CustomerRegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var nationalIDController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerRegisterCubit(),
      child: BlocConsumer<CustomerRegisterCubit, CustomerRegisterStates>(
          listener: (context, state) {
        if (state is CustomerRegisterErrorState) {
          showToast(
            message: state.error,
            length: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );
        }
        if (state is CustomerRegisterSuccessState) {
          navigateTo(context, const CustomerHomeLayout());
        }
      }, builder: (context, state) {
        var cubit = CustomerRegisterCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: Scaffold(
                floatingActionButton: BuildCondition(
                  condition: state is CustomerRegisterLoadingState,
                  builder: (context) => CircularProgressIndicator(
                    color: Colors.teal[700],
                  ),
                  fallback: (context) => FadeInUp(
                    duration: const Duration(seconds: 1),
                    child: FloatingActionButton(
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

                          if (cubit.idOptionItemSelected.title == "قم بأختيار نوع الوثيقة"){
                            showToast(
                              message: 'يجب اختيار نوع الوثيقة',
                              length: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                            );
                            return;
                          }
                          if (cubit.cityOptionItemSelected.title == "قم بأختيار المحافظة"){
                            showToast(
                              message: 'يجب اختيار المحافظة',
                              length: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                            );
                            return;
                          }

                          if (formKey.currentState!.validate()) {

                          }
                        }
                      },
                      child: const Icon(
                        IconlyBroken.addUser,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.teal[700],
                      elevation: 15.0,
                    ),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                body: Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, top: 36.0, bottom: 36.0),
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'مرحباً بك',
                                style: TextStyle(
                                  color: Colors.teal[500],
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                'قم بإنشاء حسابك الأن',
                                style: TextStyle(
                                  color: Colors.teal[500],
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(
                                height: 18.0,
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
                              ), // name
                              const SizedBox(
                                height: 18.0,
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
                                    IconlyBroken.call,
                                    color: Colors.teal[700],
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8.0))),
                                ),
                              ), // Phone
                              const SizedBox(
                                height: 18.0,
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
                                  if (value.length < 8) {
                                    return 'كلمة السر يجب ان تتكون من 8 حروف او ارقام على الاقل';
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
                              ), // password
                              const SizedBox(
                                height: 18.0,
                              ),
                              SelectDropList(
                                cubit.idOptionItemSelected,
                                cubit.idDropListModel,
                                    (optionItem) {
                                  cubit.changePaperIndex(optionItem);
                                },
                                  IconlyBroken.document
                              ),
                              const SizedBox(
                                height: 18.0,
                              ),
                              TextFormField(
                                textDirection: TextDirection.rtl,
                                controller: nationalIDController,
                                keyboardType: TextInputType.phone,
                                validator: (String? value) {

                                  switch(cubit.idOptionItemSelected.title){
                                    case "بطاقة شخصية" :
                                      if (value!.isEmpty) {
                                        return 'يجب ادخال الرقم القومى !';
                                      }
                                      if (value.length != 14) {
                                        return 'الرقم القومى يجب ان يكون 14 رقم فقط';
                                      }
                                      if (!value.startsWith('0')) {
                                        return 'الرقم القومى غير صالح';
                                      }
                                      break;
                                    case "جواز سفر" :
                                      if (value!.isEmpty) {
                                        return 'يجب ادخال رقم جواز السفر !';
                                      }
                                      if (value.length != 9) {
                                        return 'رقم جواز السفر غير صحيح';
                                      }
                                      if (!value.startsWith('A')) {
                                        return 'رقم جواز السفر غير صحيح';
                                      }
                                      break;
                                    case "سجل تجارى" :
                                      if (value!.isEmpty) {
                                        return 'يجب ادخال رقم السجل التجارى !';
                                      }
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
                                  labelText: "رقم ${cubit.idOptionItemSelected.title}",
                                  alignLabelWithHint: true,
                                  hintTextDirection: TextDirection.rtl,
                                  prefixIcon: Icon(
                                    IconlyBroken.paper,
                                    color: Colors.teal[700],
                                  ),
                                  border: const OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                                ),
                              ),
                              const SizedBox(
                                height: 18.0,
                              ),
                              SelectDropList(
                                cubit.cityOptionItemSelected,
                                cubit.cityDropListModel,
                                (optionItem) {
                                  cubit.changeLocationIndex(optionItem);
                                },
                                IconlyBroken.location,
                              ),
                              const SizedBox(
                                height: 18.0,
                              ),
                              TextFormField(
                                textDirection: TextDirection.rtl,
                                controller: nameController,
                                keyboardType: TextInputType.text,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'يجب ادخال العنوان !';
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
                                  labelText: 'العنوان',
                                  alignLabelWithHint: true,
                                  hintTextDirection: TextDirection.rtl,
                                  prefixIcon: Icon(
                                    IconlyBroken.location,
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        );
      }),
    );
  }
}
