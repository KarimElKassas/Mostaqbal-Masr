import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/Global/Login/cubit/login_states.dart';
import 'package:mostaqbal_masr/network/local/cache_helper.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:network_info_plus/network_info_plus.dart';

class LoginCubit extends Cubit<LoginStates>{

  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  IconData suffix = Icons.visibility_rounded;

  void changePasswordVisibility(){

    isPassword = !isPassword;

    suffix = isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(LoginChangePassVisibility());

  }

  void signInUser(String userName, String userPassword)async{

    emit(LoginLoadingSignIn());

    DioHelper.getData(
        url: 'login/GetWithParams',
        query: {
          'User_Name':userName,
          'User_Password':userPassword
        }
    ).then((value){

      print(value.statusMessage.toString());

      if(value.statusMessage == "No User Found"){

        showToast(
            message: "لا يوجد مستخدم بهذه البيانات",
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3);

        emit(LoginNoUserState());

      }else{
        print(value.data[0]["User_Name"].toString());

        if((value.data[0]["User_Name"].toString()) != "1"){

          showToast(
              message: "ليس لديك صلاحية الدخول",
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3);

          emit(LoginNoUserState());
        }else{

          var userID = value.data[0]["User_ID"];

          final info = NetworkInfo();

          info.getWifiIP().then((value){

            DateTime now = DateTime.now();
            String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

            addLog(userID, formattedDate, "Flutter Application", value!.toString());

          });


        }
      }

    }).catchError((error){

      if(error.type == DioErrorType.response){

        showToast(
            message: "لا يوجد مستخدم بهذه البيانات",
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3);

        emit(LoginNoUserState());
      }else{

        emit(LoginErrorState(error));

      }

    });

  }

  void addLog(int userID, String Login_Log_FDate, String Login_Log_HostName, String Login_Log_IPAddress){

    DioHelper.postData(
        url: 'loginlog/POST',
        query: {
          'User_ID':userID,
          'Login_Log_FDate':Login_Log_FDate,
          'Login_Log_HostName':Login_Log_HostName,
          'Login_Log_IPAddress':Login_Log_IPAddress
        }
    ).then((value){

      CacheHelper.saveData(key: 'UserID', value: userID).then((val) {
        if (val) {
          showToast(
            message: 'تم تسجيل الدخول بنجاح',
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );

          emit(LoginSuccessState());
        }
      }).catchError((error){

        emit(LoginSharedPrefErrorState(error));
      });


    });/*.catchError((error){

      if(error.type == DioErrorType.response){

        showToast(
            message: "لقد حدث خطأ ما برجاء المحاولة لاحقاً",
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3);

        showToast(
            message: error.toString(),
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3);

        emit(LoginLogErrorState());
      }else{

        emit(LoginErrorState(error));

      }

    });*/

  }
}