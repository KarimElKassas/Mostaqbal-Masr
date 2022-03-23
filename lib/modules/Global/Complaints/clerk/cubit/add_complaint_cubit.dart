import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/modules/Global/Complaints/clerk/cubit/add_complaint_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import '../../../../../network/remote/dio_helper.dart';

class AddComplaintCubit extends Cubit<AddComplaintStates>{
  AddComplaintCubit() : super(AddComplaintInitialState());

  static AddComplaintCubit get(context) => BlocProvider.of(context);


  void sendComplaint(BuildContext context, String userID, String userManagementID, String complaintDescription)async {
    emit(AddComplaintLoadingSendComplaintState());

    DateTime complaintDate = DateTime.now();
    String lastDate =
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(complaintDate);

    await DioHelper.postData(url: 'complaints/POST', query: {
      'User_ID': userID,
      'Complaint_Date': lastDate,
      'Complaint_Description': complaintDescription,
      'User_Management_ID': userManagementID,
    }).then((value){

      if(value.statusCode == 200){

        showToast(message: "تم ارسال الشكوى بنجاح", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
        if(Navigator.canPop(context)){
          Navigator.pop(context);
        }
        emit(AddComplaintSuccessSendComplaintState());
      }

    }).catchError((error){
      if(error is DioError){
        emit(AddComplaintErrorSendComplaintState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      }else {
        emit(AddComplaintErrorSendComplaintState(error.toString()));
      }
    });
  }
}