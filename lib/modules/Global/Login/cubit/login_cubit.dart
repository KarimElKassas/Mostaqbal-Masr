import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/Global/Login/cubit/login_states.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/screens/global_display_posts_screen.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_rounded;

  double? loginLogID;
  int? sectionUserID;
  int? sectionID;
  String? sectionName;
  List<int?>? userFormsIDList = [];
  List<String>? sectionFormsNameList = [];
  List<String>? sectionFormsFinalNameList = [];

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix =
        isPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded;

    emit(LoginChangePassVisibility());
  }

  void signInUser(String userName, String userPassword) async {
    emit(LoginLoadingSignIn());

    var connectivityResult = await (Connectivity().checkConnectivity());

    if ((connectivityResult == ConnectivityResult.mobile) ||
        (connectivityResult == ConnectivityResult.none)) {
      showToast(
        message: "برجاءالاتصال بشبكة المشروع اولاً",
        length: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
      );
      emit(LoginNoInternetState());
    } else if (connectivityResult == ConnectivityResult.wifi) {
      final info = NetworkInfo();

      info.getWifiIP().then((deviceIP) async {
        if (deviceIP!.contains("172.16.1.")) {
          DioHelper.getData(
                  url: 'login/GetWithParams',
                  query: {'User_Name': userName, 'User_Password': userPassword})
              .then((value) async {
            print(value.statusMessage.toString());

            if (value.statusMessage == "No User Found") {
              showToast(
                  message: "لا يوجد مستخدم بهذه البيانات",
                  length: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3);

              emit(LoginNoUserState());
            } else {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var oldLoginLogID = prefs.getDouble("Login_Log_ID");

              if (prefs.containsKey("Login_Log_ID")) {
                await updateLog(oldLoginLogID!);
              }

              var userID = value.data[0]["User_ID"];
              var userName = value.data[0]["User_Name"];
              var userPassword = value.data[0]["User_Password"];

              info.getWifiIP().then((ipValue) {
                DateTime now = DateTime.now();
                String formattedDate =
                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

                getUserSection(userID).then((userSectionValue) {
                  getSectionName().then((nameValue) {
                    getUserForms().then((userFormValue) {
                      getSectionFormName().then((sectionFormNameValue) {
                        addLog(userID, formattedDate, "Flutter Application",
                            ipValue!.toString(), userName, userPassword);
                      });
                    });
                  });
                });
              });
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
              emit(LoginErrorState(error.toString()));
            }
          });
        } else {
          showToast(
              message: "برجاء الاتصال بشبكة المشروع اولاً",
              length: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3);
          emit(LoginNoInternetState());
        }
      });
    }
  }

  Future<void> getLoginLogID(int userID, String Login_Log_FDate) async {
    await DioHelper.getData(
            url: 'loginlog/GetWithParameters',
            query: {'Login_Log_FDate': Login_Log_FDate, 'User_ID': userID})
        .then((value) {
      loginLogID = value.data[0]["Login_Log_ID"];
    });
  }

  Future<void> updateLog(double oldLoginLogID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var loginDate = prefs.getString("LoginDate");

    DateTime formattedDate = DateTime.parse(loginDate!);

    var logOutDate = formattedDate.add(const Duration(days: 1));

    String lastDate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(logOutDate);

    await DioHelper.updateData(url: 'loginlog/PutWithParams', query: {
      'Login_Log_ID': oldLoginLogID.toInt(),
      'Login_Log_TDate': lastDate,
    }).then((value) {
      emit(LoginUpdateLogSuccess());
    }).catchError((error) {
      emit(LoginUpdateLogError(error.toString()));
    });
  }

  Future<void> addLog(
      int userID,
      String Login_Log_FDate,
      String Login_Log_HostName,
      String Login_Log_IPAddress,
      String userName,
      String userPassword) async {
    await DioHelper.postData(url: 'loginlog/POST', query: {
      'User_ID': userID,
      'Login_Log_FDate': Login_Log_FDate,
      'Login_Log_HostName': Login_Log_HostName,
      'Login_Log_IPAddress': Login_Log_IPAddress
    }).then((value) {
      getLoginLogID(userID, Login_Log_FDate).then((value) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        DateTime loginDate = DateTime.now();

        prefs.setDouble("Login_Log_ID", loginLogID!);
        prefs.setString("LoginDate", loginDate.toString());
        prefs.setInt("Section_User_ID", sectionUserID!);
        prefs.setInt("Section_ID", sectionID!);
        prefs.setString("Section_Name", sectionName!);
        prefs.setStringList(
            "Section_Forms_Name_List", sectionFormsFinalNameList!);
        prefs.setString("User_Name", userName);
        prefs.setString("User_Password", userPassword);
        prefs.setInt("User_ID", userID).then((value) {
          print("Login Log ID $loginLogID");
          print("LoginDate ${loginDate.toString()}");
          print("User_Name $userName");
          print("User_Password $userPassword");

          emit(LoginSuccessState(sectionName!));
        }).catchError((error) {
          emit(LoginSharedPrefErrorState(error.toString()));
        });
      }).catchError((error) {
        emit(LoginSharedPrefErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  Future<void> getUserSection(int userID) async {
    await DioHelper.getData(
        url: 'sectionUser/GetWithParameters',
        query: {'User_ID': userID}).then((value) {
      sectionUserID = value.data[0]["Section_User_ID"];
      sectionID = value.data[0]["Section_ID"];

      print("Section User ID : $sectionUserID");
      print("Section ID : $sectionID");

      emit(LoginGetUserSectionSuccessState());
    }).catchError((error) {
      emit(LoginGetUserSectionErrorState(error.toString()));
    });
  }

  Future<void> getSectionName() async {
    await DioHelper.getData(
        url: 'section/GetWithParameters',
        query: {'Section_ID': sectionID}).then((value) {
      sectionName = value.data[0]["Section_Name"];

      print("Section Name : $sectionName");

      emit(LoginGetSectionNameSuccessState());
    }).catchError((error) {
      emit(LoginGetSectionNameErrorState(error.toString()));
    });
  }

  Future<void> getUserForms() async {
    await DioHelper.getData(
        url: 'userForms/GetWithParameters',
        query: {'Section_User_ID': sectionUserID}).then((value) {
      for (var formID in value.data) {
        userFormsIDList!.add(formID["Section_Form_ID"]);
      }

      print("User Forms ID List : $userFormsIDList\n");

      emit(LoginGetUserFormsSuccessState());
    }).catchError((error) {
      emit(LoginGetUserFormsErrorState(error.toString()));
    });
  }

  Future<void> getSectionFormName() async {
    for (var formID in userFormsIDList!) {
      await DioHelper.getData(
          url: 'sectionForm/GetWithParameters',
          query: {'Section_Form_ID': formID}).then((value) {
        for (var formID in value.data) {
          sectionFormsNameList!.add(formID["Section_Form_Name"]);
        }
      });
    }
    sectionFormsFinalNameList!.addAll(sectionFormsNameList!);
    print("Section Forms Final Name List : $sectionFormsFinalNameList\n");
  }

  void backToPosts(BuildContext context) {
    navigateAndFinish(context, GlobalDisplayPostsScreen());
  }

  var connectivityResult = (Connectivity().checkConnectivity());
  bool hasInternet = false;

  Future<void> checkConnection() async {
    Future<bool> noConnection = noInternetConnection();

    noConnection.then((value) {
      hasInternet = value;
      if (value == true) {
        emit(LoginNoInternetState());
      }
    });
  }
}
