import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/shared/components.dart';

import '../../../../../models/complaint_model.dart';
import '../../../../../network/remote/dio_helper.dart';
import 'display_complaint_states.dart';

class DisplayComplaintCubit extends Cubit<DisplayComplaintStates>{
  DisplayComplaintCubit() : super(DisplayComplaintInitialState());

  static DisplayComplaintCubit get(context) => BlocProvider.of(context);

  bool answeredComplaints = false;
  bool waitingComplaints = true;

  List<ComplaintModel>? complaintsList = [];
  ComplaintModel? complaintModel;

  void changeFilter(String buttonSelected){

     if(buttonSelected == "تم الرد"){
      answeredComplaints = true;
      waitingComplaints = false;
    }else{
      answeredComplaints = false;
      waitingComplaints = true;
    }
    emit(DisplayComplaintChangeFilterState());
  }
  Response<ResponseBody>? rs;

  Future<void> getFilteredComplaints(String userID, bool selectedFilterBool)async {

    emit(DisplayComplaintLoadingComplaintsState());
    Future.delayed(const Duration(milliseconds: 500)).then((value)async{
      complaintsList = [];
      await DioHelper.getData(
          url: 'complaints/GetWithMultiParameters',
          query: {
            'User_ID': userID,
            'Complaint_State': selectedFilterBool
          }).then((value) {
            if(value.statusMessage != "No Complaint Found") {
              if (value.data != null) {
                value.data.forEach((complaint) {
                  complaintModel = ComplaintModel(
                      complaint["Complaint_ID"].toString(),
                      complaint["User_ID"].toString(),
                      "",
                      complaint["Complaint_Description"].toString(),
                      complaint["Complaint_Date"].toString(),
                      complaint["Complaint_Answer"].toString(),
                      complaint["Complaint_State"].toString(),
                      complaint["Complaint_Answer_Date"].toString(),
                      complaint["User_Management_ID"].toString(),
                      complaint["Answer_Officer_ID"].toString(),
                  );
                  complaintsList!.add(complaintModel!);
                });
              }
            }
        emit(DisplayComplaintSuccessGetComplaintsState());
      }).catchError((error) {
        if (error is DioError) {
          emit(DisplayComplaintErrorGetComplaintsState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
        } else {
          emit(DisplayComplaintErrorGetComplaintsState(error.toString()));
        }
      });
    });
  }

  Future<void> updateComplaint(BuildContext context ,String userID, String complaintID, String complaintDescription, String complaintDate, String complaintAnswer, String complaintAnswerDate, bool complaintState)async {
    emit(DisplayComplaintLoadingUpdateComplaintState());
    await DioHelper.updateData(
        url: 'complaints/PutComplaint',
        query: {
            'User_ID': int.parse(userID),
            'Complaint_ID': int.parse(complaintID),
            'Complaint_Description': complaintDescription,
            'Complaint_Date': DateTime.parse(complaintDate),
            'Complaint_Answer': complaintAnswer,
            'Complaint_Answer_Date': null,
            'Answer_Officer_ID': null,
            'Complaint_State': false,
    }).then((value){
      showToast(message: "تم تعديل الشكوى بنجاح", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }
      emit(DisplayComplaintSuccessUpdateComplaintState());
    }).catchError((error){
      if(error is DioError){
        emit(DisplayComplaintErrorUpdateComplaintState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      }else{
        emit(DisplayComplaintErrorUpdateComplaintState(error.toString()));
      }
    });
  }

  Future<void> deleteComplaint(BuildContext context ,String complaintID)async {
    emit(DisplayComplaintLoadingDeleteComplaintState());
    await DioHelper.deleteData(url: 'complaints/DeleteWithParams', query: {
      'Complaint_ID': complaintID
    }).then((value){
      showToast(message: "تم حذف الشكوى بنجاح", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }
      emit(DisplayComplaintSuccessDeleteComplaintState());
    }).catchError((error){
      if(error is DioError){
        emit(DisplayComplaintErrorDeleteComplaintState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      }else{
        emit(DisplayComplaintErrorDeleteComplaintState(error.toString()));
      }
    });
  }

  void navigateToDetails(BuildContext context, route){
    navigateTo(context, route);
  }
}