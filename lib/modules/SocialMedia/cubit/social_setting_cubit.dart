import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/Global/Login/login_screen.dart';
import 'package:mostaqbal_masr/modules/SocialMedia/cubit/social_setting_states.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SocialSettingCubit extends Cubit<SocialSettingStates>{

  SocialSettingCubit() : super(SocialSettingInitialState());

  static SocialSettingCubit get(context) => BlocProvider.of(context);



  Future<void> changePassword(BuildContext context, String newPassword, String currentPassword)async{

    emit(SocialSettingLoadingState());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userID = prefs.getInt("User_ID");
    String? userPassword = prefs.getString("User_Password");

    if(userPassword != currentPassword){

      showToast(
        message: "كلمة المرور الحاليه غير صحيحة",
        length: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
      );

      emit(SocialSettingWrongPasswordState());
      return;
    }

    await DioHelper.updateData(url: 'login/PutLoginWithParams', query: {
      'User_ID': userID,
      'User_Password': newPassword,
    }).then((value) {

      logOut(context).then((value){
        emit(SocialSettingSuccessState());
      }).catchError((error){
        emit(SocialSettingErrorState(error.toString()));
      });

    }).catchError((error){
      emit(SocialSettingErrorState(error.toString()));
    });

  }


  Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double? loginLogID = prefs.getDouble("Login_Log_ID");
    print("Login Log ID $loginLogID");

    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

    await DioHelper.updateData(url: 'loginlog/PutWithParams', query: {
      'Login_Log_ID': loginLogID!.toInt(),
      'Login_Log_TDate': formattedDate,
    }).then((value) {
      prefs.remove("Login_Log_ID");
      prefs.remove("User_ID");
      prefs.remove("User_Name");
      prefs.remove("User_Password");

      navigateAndFinish(context, LoginScreen());

      emit(SocialSettingSuccessState());
    }).catchError((error){
      emit(SocialSettingErrorState(error.toString()));
    });
  }


}