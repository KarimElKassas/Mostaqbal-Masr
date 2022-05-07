import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/deparment_core/cubit/core_clerk_details_states.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transition_plus/transition_plus.dart';

class CoreClerkDetailsCubit extends Cubit<CoreClerkDetailsStates> {
  CoreClerkDetailsCubit() : super(CoreClerkDetailsInitialState());

  static CoreClerkDetailsCubit get(context) => BlocProvider.of(context);


  void navigate(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
    emit(CoreClerkDetailsNavigateSuccessState());
  }
}
