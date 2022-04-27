import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Departments/SocialMedia/home/layout/social_home_layout.dart';
import 'package:mostaqbal_masr/modules/Global/Login/clerk_login_screen.dart';
import 'package:mostaqbal_masr/modules/Global/SplashScreen/cubit/splash_states.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../network/remote/dio_helper.dart';
import '../../../Departments/Monitor/complaints/screens/complaint_screen.dart';
import '../../../Departments/Monitor/layout/screens/manager_home_layout.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitialState());

  static SplashCubit get(context) => BlocProvider.of(context);

  String? managerID;

  Future<void> navigate(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 4000), () {});

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString("ClerkID") != null){

      await getDepartmentManager(prefs.getString("ClerkManagementID")!.toString());
      switch (prefs.getString("ClerkManagementID")!.toString()){

        //إدارة التسويق
        case "1054" :
          finish(context, const SocialHomeLayout());
          break;
        //إدارة الرقمنة
        case "1028" :
          finish(context, const SocialHomeLayout());
          break;
        //إدارة الرقابة والمتابعة
        case "1022" :
          finish(context, (managerID != prefs.getString("ClerkNumber")!.toString()) ? const OfficerComplaintScreen() : const ManagerHomeLayout());
          break;
      }
    }else{
      finish(context, ClerkLoginScreen());
    }
    emit(SplashSuccessNavigateState());
  }

  Future<void> getDepartmentManager(String departmentID) async{
    await DioHelper.getData(
        url: 'departments/GetDepartmentWithID',
        query: {'DEPTID' : departmentID}).then((value){
      managerID = value.data[0]["DEPTLeaderID"].toString();
      emit(SplashGetDepartmentManagerSuccessState());
    }).catchError((error){
      emit(SplashGetDepartmentManagerErrorState(error.toString()));
    });
  }

  Future<void> createMediaFolder() async {

    await FirebaseMessaging.instance.subscribeToTopic("2022-02-20-22-26-32");

    var status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      var externalDoc = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      final Directory mediaDirectory =
          Directory('$externalDoc/Future Of Egypt Media/');

      if (mediaDirectory.existsSync()) {
        emit(SplashSuccessCreateDirectoryState());
      } else {
        await mediaDirectory.create(recursive: true);
        emit(SplashSuccessCreateDirectoryState());
      }

      final Directory documentsDirectory = Directory('/storage/emulated/0/Download/Future Of Egypt Media/Documents/');

      if (documentsDirectory.existsSync()) {
        emit(SplashSuccessCreateDirectoryState());
      } else {
        await documentsDirectory.create(recursive: true);
        emit(SplashSuccessCreateDirectoryState());
      }

      final Directory recordingsDirectory = Directory('/storage/emulated/0/Download/Future Of Egypt Media/Records/');

      if (recordingsDirectory.existsSync()) {
        emit(SplashSuccessCreateDirectoryState());
      } else {
        await recordingsDirectory.create(recursive: true);
        emit(SplashSuccessCreateDirectoryState());
      }

      final Directory imagesDirectory = Directory('/storage/emulated/0/Download/Future Of Egypt Media/Images/');

      if (await imagesDirectory.exists()) {
        emit(SplashSuccessCreateDirectoryState());
      } else {
        await imagesDirectory.create(recursive: true);
        emit(SplashSuccessCreateDirectoryState());
      }
    } else {
      emit(SplashSuccessPermissionDeniedState());
    }
  }

  void finish(BuildContext context, route){
    Navigator.pushReplacement(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
  }
}
