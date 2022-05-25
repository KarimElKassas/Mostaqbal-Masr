import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/models/clerk_model.dart';
import 'package:mostaqbal_masr/models/core_person_type_model.dart';
import 'package:transition_plus/transition_plus.dart';

import '../../../../../../network/remote/dio_helper.dart';
import 'monitor_core_states.dart';

class MonitorCoreCubit extends Cubit<MonitorCoreStates>{

  MonitorCoreCubit() : super(MonitorCoreInitialState());

  static MonitorCoreCubit get(context) => BlocProvider.of(context);

  String selectedPersonTypeName = "ضباط";
  int? selectedPersonTypeID = 0;
  bool gotClerks = false;
  bool zeroClerks = false;
  bool touched = false;
  String publicImage = "https://firebasestorage.googleapis.com/v0/b/mostaqbal-masr.appspot.com/o/Public%2Fbusiness_man_blue.png?alt=media";
  
  ClerkModel? clerkModel;
  List<ClerkModel> clerksModelList = [];
  List<ClerkModel> filteredClerksModelList = [];

  List<CorePersonTypeModel> personTypeNameList = [
    CorePersonTypeModel(typeID: 0, typeName: 'ضباط'),
    CorePersonTypeModel(typeID: 1, typeName: 'ضباط صف'),
    CorePersonTypeModel(typeID: 2, typeName: 'جنود'),
    CorePersonTypeModel(typeID: 3, typeName: 'مدنيين'),
  ];
  void changeBtnSize(){
    touched = !touched;
    emit(MonitorCoreChangeButtonSizeState());
  }
  void changeFilter(int selectedID, String selectedName){
    selectedPersonTypeID = selectedID;
    selectedPersonTypeName = selectedName;
    emit(MonitorCoreChangeFilterState());
  }

  Future<void> getFilteredClerks(String managementID, int personTypeID)async {
    gotClerks = false;
    emit(MonitorCoreLoadingClerksState());
    Future.delayed(const Duration(milliseconds: 500)).then((value)async{
      clerksModelList = [];
      print("ManagementID : $managementID\n");
      await DioHelper.getData(
          url: 'userInfo/GetUserInfoWithType',
          query: {
            'PR_Management_ID': managementID,
            'Person_Type_ID': personTypeID+1
          }).then((value) {
        if(value.statusMessage != "No Person Form Row Found") {
          if (value.data != null) {
            //print(value.data);
            //print(value.data[0]["TrueOrFalse"]);
            value.data.forEach((clerk) async {
              print("Name ${clerk["PR_Persons_Name"]}\n");
              print("Status ${clerk["TrueOrFalse"] == 0 ? "لائق" : "غير لائق"}\n");
              var userID = clerk["PR_Persons_Number"].toString();
              var userName = clerk["PR_Persons_Name"].toString();
              var userNumber = clerk["PR_Persons_Number"].toString();
              var userAddress = clerk["PR_Persons_Address"].toString();
              var userPhone = clerk["PR_Persons_MobilNum1"].toString();
              var userManagementName = clerk["PR_Management_Name"].toString();
              var userTypeName = clerk["Person_Type_Name"].toString();
              var userRankID = clerk["PR_Rank_ID"].toString();
              var userRankName = clerk["PR_Rank_Name"].toString();
              var userCategoryRank = clerk["CategoryRank"].toString();
              var userCategoryID = clerk["PR_Category_ID"].toString();
              var userCategoryName = clerk["PR_Category_Name"].toString();
              var userCoreStrengthID = clerk["PR_CoreStrength_ID"].toString();
              var userCoreStrengthName = clerk["PR_CoreStrength_Name"].toString();
              var userPresenceID = clerk["PR_Presence_ID"].toString();
              var userPresenceName = clerk["PR_Presence_Name"].toString();
              var userJobID = clerk["PR_Jobs_ID"].toString();
              var userJobName = clerk["PR_Jobs_Name"].toString();
              var userStatus = clerk["TrueOrFalse"].toString();
              var onFirebase = clerk["OnFirebase"].toString();
              var userImage = clerk["User_Image"].toString();
              var userToken = "";

              print("Clerk ON Firebase State : $onFirebase ------ ID : $userNumber\n");
              print("Clerk Name : $userName ---- is Empty : ${userImage.toString() == "null"}");
              print("Clerk Image : $userImage\n");
              //print("Clerk Name : $userName ----- Clerk Job Name : $userJobName \n");
              FirebaseFirestore.instance.collection("Clerks").doc(userNumber).get().then((value){
                 if(value.exists){
                   Map data = value.data()!;
                   userToken = data["ClerkToken"];
                 }
                });
              clerkModel = ClerkModel(
                  userID,
                  userName,
                  onFirebase == "true" ? userImage : publicImage,
                  userNumber,
                  userAddress,
                  userPhone,
                  personTypeID.toString(),
                  userTypeName,
                  userCategoryID,
                  userCategoryName,
                  userCategoryRank,
                  userRankID,
                  userRankName,
                  managementID,
                  userManagementName,
                  userJobID,
                  userJobName == "بدون" ? "بدون وظيفة" : userJobName,
                  userCoreStrengthID,
                  userCoreStrengthName,
                  userPresenceID,
                  userPresenceName,
                  userStatus == "0" ? "لائق" : "غير لائق",
                  onFirebase,
                  userToken
              );
              clerksModelList.add(clerkModel!);
              filteredClerksModelList = clerksModelList;
            });
            zeroClerks = false;
            gotClerks = true;
            emit(MonitorCoreGetClerksSuccessState());

          }
        }else{
          gotClerks = true;
          zeroClerks = true;
          emit(MonitorCoreGetClerksSuccessState());
        }
      }).catchError((error) {
        if (error is DioError) {
          print("Dio ERROR : ${error.toString()}\n");
          emit(MonitorCoreGetClerksErrorState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
        } else {
          emit(MonitorCoreGetClerksErrorState(error.toString()));
          print("ERROR : ${error.toString()}\n");
        }
      });
    });
  }
  void navigateTo(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
    emit(MonitorCoreNavigateSuccessState());
  }
}