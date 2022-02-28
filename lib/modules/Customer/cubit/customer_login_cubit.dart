import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_login_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerLoginCubit extends Cubit<CustomerLoginStates>{

  CustomerLoginCubit() : super(CustomerLoginInitialState());

  static CustomerLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_rounded;

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix =
    isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(CustomerLoginChangePassVisibility());
  }
  
  void signInUser(String userEmail, String userPassword, BuildContext context)async {
    emit(CustomerLoginLoadingState());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "$userEmail@gmail.com",
          password: userPassword
      );

      getUserData(userEmail, context);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(CustomerLoginErrorState('لا يوجد مستخدم بهذة البيانات'));
      } else if (e.code == 'wrong-password') {
        emit(CustomerLoginErrorState('كلمة المرور غير صحيحة'));
      }
    }
  }

  void getUserData(String userPhone, BuildContext context)async{

    FirebaseDatabase.instance
        .reference()
        .child('Users')
        .orderByChild("UserPhone")
        .equalTo(userPhone)
        .once()
        .then((value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          Map<dynamic, dynamic> values = value.value;
          values.forEach((key, values) async {
            FirebaseDatabase.instance
                .reference()
                .child('Users')
                .child(values["UserID"])
                .child("UserToken")
                .set(FirebaseMessaging.instance.getToken()).then((value)async {
              await prefs.setString("CustomerName", values["UserName"]);
              await prefs.setString("CustomerPhone", values["UserPhone"]);
              await prefs.setString("CustomerPassword", values["UserPassword"]);
              await prefs.setString("CustomerRegion", values["UserRegion"]);
              await prefs.setString("CustomerCity", values["UserCity"]);
              await prefs.setString("CustomerToken", values["UserToken"]);
              await prefs.setString("CustomerImage", values["UserImage"]);
              await prefs.setString("CustomerID", values["UserID"]);
              await prefs.setString("CustomerDocType", values["UserDocType"]);
              await prefs.setString("CustomerDocNumber", values["UserDocNumber"]);
              await prefs.setString("UserType", "Customer");

              customerLogged = true;
              customerState.value = 1;

              await FirebaseDatabase.instance
                  .reference()
                  .child("ChatList")
                  .child(values["UserID"])
                  .child("Future Of Egypt")
                  .once()
                  .then((value) {
                if (!value.exists) {
                  FirebaseDatabase.instance
                      .reference()
                      .child("ChatList")
                      .child(values["UserID"])
                      .child("Future Of Egypt")
                      .child("ReceiverID")
                      .set("Future Of Egypt");
                }
              }).catchError((error) {
                emit(CustomerLoginErrorState(error.toString()));
              });

              await FirebaseDatabase.instance
                  .reference()
                  .child("ChatList")
                  .child("Future Of Egypt")
                  .child(values["UserID"])
                  .child("ReceiverID")
                  .set(values["UserID"]);

              Navigator.pop(context);

            });

            emit(CustomerLoginGetDataSuccessState());

          });


        }).catchError((error){
          emit(CustomerLoginGetDataErrorState(error.toString()));
    });


  }

}