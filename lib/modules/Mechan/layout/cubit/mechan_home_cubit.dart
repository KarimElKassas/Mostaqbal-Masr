import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/Global/Login/login_screen.dart';
import 'package:mostaqbal_masr/modules/Mechan/layout/cubit/mechan_home_states.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MechanHomeCubit extends Cubit<MechanHomeStates>{

  MechanHomeCubit() : super(MechanHomeInitialState());

  static MechanHomeCubit get(context) => BlocProvider.of(context);


  double? loginLogID;

  Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    loginLogID = prefs.getDouble("Login_Log_ID");
    print("Login Log ID $loginLogID");

    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(now);

    await DioHelper.updateData(url: 'loginlog/PutWithParams', query: {
      'Login_Log_ID': loginLogID!.toInt(),
      'Login_Log_TDate': formattedDate,
    }).then((value) {
      prefs.remove("Login_Log_ID");
      prefs.remove("LoginDate");
      prefs.remove("Section_User_ID");
      prefs.remove("Section_ID");
      prefs.remove("Section_Name");
      prefs.remove("Section_Forms_Name_List");
      prefs.remove("User_Name");
      prefs.remove("User_Password");
      prefs.remove("User_ID");

      navigateAndFinish(context, LoginScreen());

      emit(MechanHomeLogOutSuccessState());
    }).catchError((error){
      emit(MechanHomeLogOutErrorState(error.toString()));
    });
  }
}