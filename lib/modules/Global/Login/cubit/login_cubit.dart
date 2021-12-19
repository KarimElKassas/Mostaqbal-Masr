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
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;

  IconData suffix = Icons.visibility_rounded;

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix =
        isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(LoginChangePassVisibility());
  }

  void signInUser(String userName, String userPassword) async {
    emit(LoginLoadingSignIn());

    DioHelper.getData(
            url: 'login/GetWithParams',
            query: {'User_Name': userName, 'User_Password': userPassword})
        .then((value) {
      print(value.statusMessage.toString());

      if (value.statusMessage == "No User Found") {
        showToast(
            message: "لا يوجد مستخدم بهذه البيانات",
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3);

        emit(LoginNoUserState());
      } else {
        print(value.data[0]["User_Name"].toString());

        if ((value.data[0]["User_Name"].toString()) != "1") {
          showToast(
              message: "ليس لديك صلاحية الدخول",
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3);

          emit(LoginNoUserState());
        } else {
          var userID = value.data[0]["User_ID"];
          var userName = value.data[0]["User_Name"];
          var userPassword = value.data[0]["User_Password"];

          final info = NetworkInfo();

          info.getWifiIP().then((value) {
            DateTime now = DateTime.now();
            String formattedDate =
                DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

            addLog(userID, formattedDate, "Flutter Application",
                value!.toString(),userName,userPassword);
          });
        }
      }
    }).catchError((error) {
      if (error.type == DioErrorType.response) {
        showToast(
            message: "لا يوجد مستخدم بهذه البيانات",
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3);

        emit(LoginNoUserState());
      } else {
        emit(LoginErrorState(error));
      }
    });
  }
  double? loginLogID;

  Future<void> getLoginLogID(int userID, String Login_Log_FDate) async {
    await DioHelper.getData(
        url: 'loginlog/GetWithParameters',
        query: {'Login_Log_FDate': Login_Log_FDate, 'User_ID': userID})
        .then((value) {
      loginLogID = value.data[0]["Login_Log_ID"];
    });
  }

  Future<void> addLog(int userID, String Login_Log_FDate,
      String Login_Log_HostName, String Login_Log_IPAddress,String userName, String userPassword) async {

    await DioHelper.postData(url: 'loginlog/POST', query: {
      'User_ID': userID,
      'Login_Log_FDate': Login_Log_FDate,
      'Login_Log_HostName': Login_Log_HostName,
      'Login_Log_IPAddress': Login_Log_IPAddress
    }).then((value) {
      getLoginLogID(userID, Login_Log_FDate).then((value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setDouble("Login_Log_ID", loginLogID!);
        prefs.setString("User_Name", userName);
        prefs.setString("User_Password", userPassword);
        prefs.setInt("User_ID", userID).then((value){
          print("Login Log ID $loginLogID");
          print("User_Name $userName");
          print("User_Password $userPassword");
          showToast(
            message: 'تم تسجيل الدخول بنجاح',
            length: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
          );

          emit(LoginSuccessState());

        }).catchError((error){
          emit(LoginSharedPrefErrorState(error.toString()));

        });

      }).catchError((error) {
        emit(LoginSharedPrefErrorState(error.toString()));

      });

    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
  }


}
