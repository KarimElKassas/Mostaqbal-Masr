import 'dart:convert';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/models/client_complaint_model.dart';
import 'package:mostaqbal_masr/models/department_model.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:transition_plus/transition_plus.dart';
import '../../../../../models/complaint_model.dart';
import '../../../../../network/remote/dio_helper.dart';
import '../../../../../shared/constants.dart';
import 'officer_display_client_complaint_states.dart';
import 'officer_display_complaint_states.dart';

class OfficerDisplayClientComplaintsCubit extends Cubit<OfficerDisplayClientComplaintsStates>{
  OfficerDisplayClientComplaintsCubit() : super(OfficerDisplayClientComplaintsInitialState());

  static OfficerDisplayClientComplaintsCubit get(context) => BlocProvider.of(context);

  bool answeredComplaints = false;
  bool waitingComplaints = true;
  String userName = "";
  String userToken = "";

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  List<ClientComplaintModel> complaintsList = [];
  List<ClientComplaintModel> complaintsAllList = [];
  ClientComplaintModel? complaintModel;
  ClientComplaintModel? complaintAllModel;

  void changeFilterRespond(String buttonSelected){
    if(buttonSelected == "تم الرد"){
      answeredComplaints = true;
      waitingComplaints = false;
    }else{
      answeredComplaints = false;
      waitingComplaints = true;
    }
    emit(OfficerDisplayClientComplaintsChangeFilterState());
  }

  Future<void> getUser(String userID) async {
    emit(OfficerDisplayClientComplaintsLoadingUserState());

    FirebaseDatabase.instance.reference().child("Clients").child(userID).get().then((value){
      if(value.exists){
        userName = value.value["ClientName"];
        userToken = value.value["ClientToken"];

        print("User Name : $userName\n");
        print("User Token : $userToken\n");

        emit(OfficerDisplayClientComplaintsSuccessGetUserState());
      }
    }).catchError((error){
      emit(OfficerDisplayClientComplaintsErrorGetUserState(error.toString()));
    });
  }


  Future<void> getAllComplaints()async {
    emit(OfficerDisplayClientComplaintsLoadingComplaintsState());
    Future.delayed(const Duration(milliseconds: 500)).then((value)async{
      complaintsAllList = [];
      await DioHelper.getData(
          url: 'complaintsClient/ComplaintsGetAll').then((value) {
        if(value.statusMessage != "No Complaint Found") {
          if (value.data != null) {
            value.data.forEach((complaint)async {
              await getUser(complaint["User_ID"].toString());
              complaintAllModel = ClientComplaintModel(
                complaint["Complaint_ID"].toString(),
                complaint["User_ID"].toString(),
                userName,
                userToken,
                complaint["Complaint_Description"].toString(),
                complaint["Complaint_Date"].toString(),
                complaint["Complaint_Answer"].toString(),
                complaint["Complaint_State"].toString(),
                complaint["Complaint_Answer_Date"].toString(),
                complaint["Answer_Officer_ID"].toString(),
              );
              complaintsAllList.add(complaintAllModel!);
            });
          }
        }
        emit(OfficerDisplayClientComplaintsSuccessGetComplaintsState());
      }).catchError((error) {
        if (error is DioError) {
          emit(OfficerDisplayClientComplaintsErrorGetComplaintsState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
        } else {
          emit(OfficerDisplayClientComplaintsErrorGetComplaintsState(error.toString()));
        }
      });
    });
  }

  Future<void> getFilteredComplaints(bool selectedFilterBool)async {
    emit(OfficerDisplayClientComplaintsLoadingComplaintsState());
      complaintsList = [];
      await DioHelper.getData(
          url: 'complaintsClient/GetWithState',
          query: {
            'Complaint_State': selectedFilterBool
          }).then((value) {
            if(value.statusMessage != "No Complaint Found") {
              if (value.data != null) {
                value.data.forEach((complaint)async {
                  await getUser(complaint["User_ID"].toString());
                  complaintModel = ClientComplaintModel(
                      complaint["Complaint_ID"].toString(),
                      complaint["User_ID"].toString(),
                      userName,
                      userToken,
                      complaint["Complaint_Description"].toString(),
                      complaint["Complaint_Date"].toString(),
                      complaint["Complaint_Answer"].toString(),
                      complaint["Complaint_State"].toString(),
                      complaint["Complaint_Answer_Date"].toString(),
                      complaint["Answer_Officer_ID"].toString(),
                  );
                  complaintsList.add(complaintModel!);
                });
              }
            }
            emit(OfficerDisplayClientComplaintsSuccessGetComplaintsState());
      }).catchError((error) {
        if (error is DioError) {
          emit(OfficerDisplayClientComplaintsErrorGetComplaintsState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
        } else {
          emit(OfficerDisplayClientComplaintsErrorGetComplaintsState(error.toString()));
        }
      });
  }

  void sendNotification(String message, String userID)async {
    var serverKey = 'AAAAnuydfc0:APA91bF3jkS5-JWRVnTk3mEBnj2WI70EYJ1zC7Q7TAI6GWlCPTd37SiEkhuRZMa8Uhu9HTZQi1oiCEQ2iKQgxljSyLtWTAxN4HoB3pyfTuyNQLjXtf58s99nAEivs2L6NzEL0laSykTK';

    FirebaseDatabase.instance.reference().child("Clients").child(userID).get().then((value)async {
      if(value.exists){
        userName = value.value["ClientName"];
        userToken = value.value["ClientToken"];

        print("User Name Notify : $userName\n");
        print("User Token Notify : $userToken\n");

        await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: jsonEncode(
            <String, dynamic>{
              'notification': <String, dynamic>{
                'body': message,
                'title': 'تم الرد على شكوتك'
              },
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': Random().nextInt(100),
                'status': 'done'
              },
              'to': userToken,
            },
          ),
        );
        emit(OfficerDisplayClientComplaintsSuccessGetUserState());
      }
    }).catchError((error){
      emit(OfficerDisplayClientComplaintsErrorGetUserState(error.toString()));
    });
  }

  Future<void> updateComplaint(BuildContext context ,String userID, String officerID, String complaintID, String complaintDescription, String complaintDate, String complaintAnswer)async {
    emit(OfficerDisplayClientComplaintsLoadingUpdateComplaintState());

    DateTime answerDate = DateTime.now();
    String lastDate =
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(answerDate);

    await DioHelper.updateData(
        url: 'complaintsClient/PutComplaint',
        query: {
            'User_ID': int.parse(userID),
            'Complaint_ID': int.parse(complaintID),
            'Complaint_Description': complaintDescription,
            'Complaint_Date': DateTime.parse(complaintDate),
            'Complaint_Answer': complaintAnswer,
            'Complaint_Answer_Date': lastDate,
            'Answer_Officer_ID': officerID,
            'Complaint_State': true,
    }).then((value){

      sendNotification(complaintDescription, userID);
      showToast(message: "تم تعديل الشكوى بنجاح", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }

      emit(OfficerDisplayClientComplaintsSuccessUpdateComplaintState());
    }).catchError((error){
      if(error is DioError){
        emit(OfficerDisplayClientComplaintsErrorUpdateComplaintState(error.toString()));
      }else{
        emit(OfficerDisplayClientComplaintsErrorUpdateComplaintState(error.toString()));
      }
    });
  }

  Future<void> deleteComplaint(BuildContext context ,String complaintID)async {
    emit(OfficerDisplayClientComplaintsLoadingDeleteComplaintState());
    await DioHelper.deleteData(url: 'complaintsClient/DeleteWithParams', query: {
      'Complaint_ID': complaintID
    }).then((value){
      showToast(message: "تم حذف الشكوى بنجاح", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }
      emit(OfficerDisplayClientComplaintsSuccessDeleteComplaintState());
    }).catchError((error){
      if(error is DioError){
        emit(OfficerDisplayClientComplaintsErrorDeleteComplaintState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      }else{
        emit(OfficerDisplayClientComplaintsErrorDeleteComplaintState(error.toString()));
      }
    });
  }

  void navigateToDetails(BuildContext context, route){
    Navigator.push(context, ScaleTransition1(page: route, startDuration: const Duration(milliseconds: 1500),closeDuration: const Duration(milliseconds: 800), type: ScaleTrasitionTypes.bottomRight));
    //navigateTo(context, route);
  }
}