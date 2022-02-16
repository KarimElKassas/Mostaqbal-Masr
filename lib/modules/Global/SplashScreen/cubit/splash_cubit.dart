import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Customer/layout/customer_home_layout.dart';
import 'package:mostaqbal_masr/modules/Global/SplashScreen/cubit/spash_states.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitialState());

  static SplashCubit get(context) => BlocProvider.of(context);

  double? loginLogID;

  Future<void> navigate(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 4000), () {});

    navigateToDisplayPosts(context);
    emit(SplashSuccessNavigateState());
  }

  void navigateToDisplayPosts(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => CustomerHomeLayout()));
  }

  Future<void> createMediaFolder() async {
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
}
