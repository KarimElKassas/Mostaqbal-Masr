import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/Customer/layout/customer_home_layout.dart';
import 'package:mostaqbal_masr/modules/Global/Login/cubit/login_states.dart';
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
  double? classificationPersonID;
  double? personID;
  String? personName;
  String? personImg;
  int? sectionUserID;
  int? sectionID;
  String? sectionName;
  String? ip;
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
        if (deviceIP!.contains("172.16.1.") || deviceIP.contains("١٧٢")) {
          await DioHelper.getData(
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
              classificationPersonID =
                  value.data[0]["Classification_Persons_ID"];

              info.getWifiIP().then((ipValue) async {
                DateTime now = DateTime.now();
                String formattedDate =
                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

                await getUserSection(userID);
                await getSectionName();
                await getUserForms();
                await getSectionFormName();
                await getUserData(classificationPersonID!);
                await addLog(userID, formattedDate, "Flutter Application",
                    ipValue!.toString(), userName, userPassword);
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

  Future<void> getLoginLogID(int userID, String LoginLogFDate) async {
    await DioHelper.getData(
            url: 'loginlog/GetWithParameters',
            query: {'Login_Log_FDate': LoginLogFDate, 'User_ID': userID})
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
      String LoginLogFDate,
      String LoginLogHostName,
      String LoginLogIPAddress,
      String userName,
      String userPassword) async {
    await DioHelper.postData(url: 'loginlog/POST', query: {
      'User_ID': userID,
      'Login_Log_FDate': LoginLogFDate,
      'Login_Log_HostName': LoginLogHostName,
      'Login_Log_IPAddress': LoginLogIPAddress
    }).then((value) {
      getLoginLogID(userID, LoginLogFDate).then((value) async {
        await getClerkFirebase(userName);

        SharedPreferences prefs = await SharedPreferences.getInstance();

        DateTime loginDate = DateTime.now();

        await prefs.setDouble("Login_Log_ID", loginLogID!);
        await prefs.setString("LoginDate", loginDate.toString());
        await prefs.setInt("Section_User_ID", sectionUserID!);
        await prefs.setInt("Section_ID", sectionID!);
        await prefs.setString("Section_Name", sectionName!);
        await prefs.setStringList(
            "Section_Forms_Name_List", sectionFormsFinalNameList!);
        await prefs.setString("UserIDMessage", "Future Of Egypt");
        await prefs.setString("User_Name", userName);
        await prefs.setString("User_Password", userPassword);
        await prefs.setDouble("Classification_Person_ID", classificationPersonID!);
        await prefs.setDouble("Person_ID", personID!);
        await prefs.setString("Person_Name", personName!);
        await prefs.setString("Person_Img", personImg!);
        await prefs.setInt("User_ID", userID).then((value) {
          print("Login Log ID $loginLogID");
          print("LoginDate ${loginDate.toString()}");
          print("User_Name $userName");
          print("User_Password $userPassword");
          print("Person Name $personName");

          emit(LoginSuccessState(sectionName!));
        }) /*.catchError((error) {
          emit(LoginSharedPrefErrorState(error.toString()));
        })*/
            ;
      }) /*.catchError((error) {
        emit(LoginSharedPrefErrorState(error.toString()));
      })*/
          ;
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }

  Future<void> getClerkFirebase(String clerkPhone) async {
    await FirebaseDatabase.instance
        .reference()
        .child("Clerks")
        .child(clerkPhone)
        .once()
        .then((value) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> groups = [];

      print("DATAAA : ${value.value["ClerkName"]}\n");
      print("DATAAA : ${value.value["ClerkID"]}\n");
      print("DATAAA : ${value.value["ClerkTypeName"]}\n");

      await prefs.setString("ClerkID", value.value["ClerkID"].toString());
      await prefs.setString("ClerkName", value.value["ClerkName"].toString());
      await prefs.setString("ClerkImage", value.value["ClerkImage"].toString());
      await prefs.setString("ClerkPhone", value.value["ClerkPhone"].toString());
      await prefs.setString(
          "ClerkNumber", value.value["ClerkNumber"].toString());
      await prefs.setString(
          "ClerkPassword", value.value["ClerkPassword"].toString());
      await prefs.setString(
          "ClerkManagementName", value.value["ClerkManagementName"].toString());
      await prefs.setString(
          "ClerkTypeName", value.value["ClerkTypeName"].toString());
      await prefs.setString(
          "ClerkRankName", value.value["ClerkRankName"].toString());
      await prefs.setString(
          "ClerkCategoryName", value.value["ClerkCategoryName"].toString());
      await prefs.setString("ClerkCoreStrengthName",
          value.value["ClerkCoreStrengthName"].toString());
      await prefs.setString(
          "ClerkPresenceName", value.value["ClerkPresenceName"].toString());
      await prefs.setString(
          "ClerkJobName", value.value["ClerkJobName"].toString());

      value.value["ClerkSubscriptions"].forEach((group) {
        groups.add(group);
      });
      await prefs.setStringList("ClerkSubscriptions", groups);

      var token = await FirebaseMessaging.instance.getToken();
      await FirebaseDatabase.instance.reference().child("Clerks").child(clerkPhone).child("ClerkToken").set(token);
      await prefs.setString("ClerkToken", token!);

      emit(LoginGetClerkDataSuccessState());
    }).catchError((error) {
      emit(LoginGetClerkDataErrorState(error.toString()));
    });
  }

  Future<void> getPersonID(double classificationPersonID) async {
    await DioHelper.getData(
            url: 'classificationPersons/GetWithParameters',
            query: {'Classification_Persons_ID': classificationPersonID})
        .then((value) {
      personID = value.data[0]["Person_ID"];

      emit(LoginGetUserPersonIDSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(
            LoginGetPersonIDErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(LoginGetPersonIDErrorState(error.toString()));
      }
    });
  }

  Future<void> getUserData(double classificationPersonID) async {
    await getPersonID(classificationPersonID);

    await DioHelper.getData(
        url: 'person/GetWithParameters',
        query: {'Person_ID': personID!.round()}).then((value) {
      personName = value.data[0]["Person_Name"];
      if (value.data[0]["Person_Pic"] != null) {
        personImg = value.data[0]["Person_Pic"];
      } else {
        personImg = "null";
      }

      emit(LoginGetUserDataSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        emit(
            LoginGetUserDataErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(LoginGetUserDataErrorState(error.toString()));
      }
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
    navigateAndFinish(context, CustomerHomeLayout());
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
