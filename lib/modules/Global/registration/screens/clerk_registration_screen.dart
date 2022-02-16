import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Global/registration/cubit/clerk_register_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/registration/cubit/clerk_register_states.dart';
import 'package:mostaqbal_masr/modules/Global/registration/screens/clerk_confirm_registration_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

class ClerkRegistrationScreen extends StatefulWidget {
  const ClerkRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<ClerkRegistrationScreen> createState() =>
      _ClerkRegistrationScreenState();
}

class _ClerkRegistrationScreenState extends State<ClerkRegistrationScreen> {
  var clerkNumberController = TextEditingController();
  String searchText = "";

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
              floatingActionButton: FadeInUp(
                  duration: const Duration(seconds: 1),
                  child: FloatingActionButton(
                    onPressed: () async {

                      if(cubit.clerkList.isNotEmpty){
                        navigateTo(context, ClerkConfirmRegistrationScreen(clerkModel: cubit.clerkModel!,));
                      }else{
                        showToast(message: "يجب تحديد الموظف اولاً", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
                      }

                    },
                    child: const Icon(
                      IconlyBold.arrowLeft3,
                      color: Colors.white,
                    ),
                    backgroundColor: Colors.teal[700],
                    elevation: 15.0,
                ),
              ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, right: 12.0, left: 12.0),
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: TextFormField(
                            textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.search,
                            cursorColor: Colors.teal,
                            style: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                            onFieldSubmitted: (String value){
                              cubit.getClerks(value);
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 1.0),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8.0))),
                              labelStyle: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              floatingLabelStyle: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                              labelText: "بحث بالرقم القومى / العسكرى",
                              hintStyle: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                              hintTextDirection: TextDirection.rtl,
                              prefixIcon: Icon(
                                IconlyBroken.search,
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
                        ),
                      ),
                      const SizedBox(height: 12.0,),
                      state is ClerkRegisterLoadingClerksState ?
                      const Center(child: CircularProgressIndicator(color: Colors.teal,strokeWidth: 0.8,),)
                      : getEmptyWidget(),
                      state is ClerkRegisterGetClerksSuccessState ?
                      clerkView(cubit)
                      : getEmptyWidget(),
                    ],
                  ),
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
      padding: const EdgeInsets.all(12.0),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                hintText: cubit.clerkModel!.clerkName,
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
              style: TextStyle(color: Colors.teal[700], fontSize: 14.0, letterSpacing: 1.5 ,fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal, width: 1.0),
                    borderRadius: BorderRadius.all(
                        Radius.circular(8.0))),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: cubit.clerkModel!.personPhone,
                hintStyle: TextStyle(color: Colors.teal[700], fontSize: 16.0, fontWeight: FontWeight.bold),
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
                "الإدارة التابع لها :",
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
                hintText: cubit.clerkModel!.managementName,
                hintStyle: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                hintTextDirection: TextDirection.rtl,
                prefixIcon: Icon(
                  IconlyBold.work,
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
                "الدرجة :",
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
                hintText: cubit.clerkModel!.personTypeName,
                hintStyle: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                hintTextDirection: TextDirection.rtl,
                prefixIcon: Icon(
                  IconlyBold.document,
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
            cubit.isCivil ? getEmptyWidget() : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "الرتبة :",
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
                    hintText: cubit.clerkModel!.rankName,
                    hintStyle: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                    hintTextDirection: TextDirection.rtl,
                    prefixIcon: Icon(
                      Icons.local_police_rounded,
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
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "الوظيفة :",
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
                    hintText: cubit.clerkModel!.jobName,
                    hintStyle: TextStyle(color: Colors.teal[700], fontSize: 14.0, fontWeight: FontWeight.bold),
                    hintTextDirection: TextDirection.rtl,
                    prefixIcon: Icon(
                      IconlyBold.work,
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
