import 'package:animate_do/animate_do.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mostaqbal_masr/models/department_model.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import '../../../../../models/complaint_model.dart';
import '../../../../../network/remote/dio_helper.dart';
import '../../../../../shared/constants.dart';
import 'officer_display_complaint_states.dart';

class OfficerDisplayComplaintCubit extends Cubit<OfficerDisplayComplaintStates>{
  OfficerDisplayComplaintCubit() : super(OfficerDisplayComplaintInitialState());

  static OfficerDisplayComplaintCubit get(context) => BlocProvider.of(context);

  bool answeredComplaints = false;
  bool waitingComplaints = true;
  String userName = "";
  // ignore: prefer_typing_uninitialized_variables
  var departmentBottomSheetController;
  bool isDepartmentBottomSheetShown = false;
  bool filteredDepartments = false;

  String selectedDepartmentName = "";
  int? selectedDepartmentID;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  List<ComplaintModel> complaintsList = [];
  List<ComplaintModel> complaintsAllList = [];
  List<DepartmentModel> departmentsList = [];
  List<DepartmentModel> departmentsCustomList = [];
  ComplaintModel? complaintModel;
  ComplaintModel? complaintAllModel;
  DepartmentModel? departmentModel;
  DepartmentModel? departmentCustomModel;

  void waitForData(BuildContext context){
    if(!filteredDepartments){
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return SlideInUp(
                duration:
                const Duration(milliseconds: 500),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(12.0),
                  ),
                  child: Center(child: CircularProgressIndicator(color: Colors.teal[500], strokeWidth: 0.8,),),
                ),
              );
            },
          );
        },
      );
    }
  }

  void changeFilter(int selectedID){
     selectedDepartmentID = selectedID;
    emit(OfficerDisplayComplaintChangeFilterState());
  }
  void changeFilterRespond(String buttonSelected){
    if(buttonSelected == "تم الرد"){
      answeredComplaints = true;
      waitingComplaints = false;
      //complaintsAllList.removeWhere((element) => element.complaintState == "false");
    }else{
      answeredComplaints = false;
      waitingComplaints = true;
      //complaintsAllList.removeWhere((element) => element.complaintState == "true");

    }
    emit(OfficerDisplayComplaintChangeFilterState());
  }

  Future<void> getUser(String userID) async {
    emit(OfficerDisplayComplaintLoadingUserState());
    departmentsList = [];
    await DioHelper.getData(
        url: 'userInfo/GetUserInfoWithID',
        query: {
          'PR_Persons_ID' : userID
        }).then((value) {
        userName = value.data[0]["PR_Persons_Name"].toString();
        emit(OfficerDisplayComplaintSuccessGetUserState());
    }).catchError((error) {
      if (error is DioError) {
        emit(OfficerDisplayComplaintErrorGetUserState(
            "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      } else {
        emit(OfficerDisplayComplaintErrorGetUserState(error.toString()));
      }
    });
  }

  Future<void> getSpecifyDepartments() async {
    emit(OfficerDisplayComplaintLoadingDepartmentsState());
    departmentsCustomList = [];
    Future.delayed(const Duration(milliseconds: 500)).then((value)async{
      await DioHelper.getData(
          url: 'departments/DepartmentsGetView').then((value) {
        value.data.forEach((department) {
          departmentCustomModel = DepartmentModel(department["User_Management_ID"], department["DEPTNAME"]);
          departmentsCustomList.add(departmentCustomModel!);
        });
        print("DEPARTMENTS : ${value.data}\n");
        selectedDepartmentID = departmentsCustomList[0].departmentID;
        selectedDepartmentName = departmentsCustomList[0].departmentName;
        filteredDepartments = true;
        emit(OfficerDisplayComplaintSuccessGetDepartmentsState());
        getFilteredComplaints(selectedDepartmentID!.toString(), answeredComplaints);
      }).catchError((error) {
        if (error is DioError) {
          emit(OfficerDisplayComplaintErrorGetDepartmentsState(
              "لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
        } else {
          emit(OfficerDisplayComplaintErrorGetDepartmentsState(error.toString()));
        }
      });
    });
  }

  Future<void> getAllComplaints()async {
    emit(OfficerDisplayComplaintLoadingComplaintsState());
    Future.delayed(const Duration(milliseconds: 500)).then((value)async{
      complaintsAllList = [];
      departmentsCustomList = [];
      await DioHelper.getData(
          url: 'complaints/ComplaintsGetAll').then((value) {
        if(value.statusMessage != "No Complaint Found") {
          if (value.data != null) {
            value.data.forEach((complaint)async {
              await getUser(complaint["User_ID"].toString());
              complaintAllModel = ComplaintModel(
                complaint["Complaint_ID"].toString(),
                complaint["User_ID"].toString(),
                userName,
                complaint["Complaint_Description"].toString(),
                complaint["Complaint_Date"].toString(),
                complaint["Complaint_Answer"].toString(),
                complaint["Complaint_State"].toString(),
                complaint["Complaint_Answer_Date"].toString(),
                complaint["User_Management_ID"].toString(),
                complaint["Answer_Officer_ID"].toString(),
              );
              complaintsAllList.add(complaintAllModel!);
            });
          }
        }
        emit(OfficerDisplayComplaintSuccessGetComplaintsState());
      }).catchError((error) {
        if (error is DioError) {
          emit(OfficerDisplayComplaintErrorGetComplaintsState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
        } else {
          emit(OfficerDisplayComplaintErrorGetComplaintsState(error.toString()));
        }
      });
    });
  }

  Future<void> getFilteredComplaints(String managementID, bool selectedFilterBool)async {
    emit(OfficerDisplayComplaintLoadingComplaintsState());
      complaintsList = [];
      await DioHelper.getData(
          url: 'complaints/GetWithManagementAndState',
          query: {
            'User_Management_ID': managementID,
            'Complaint_State': selectedFilterBool
          }).then((value) {
            if(value.statusMessage != "No Complaint Found") {
              if (value.data != null) {
                value.data.forEach((complaint)async {
                  await getUser(complaint["User_ID"].toString());
                  complaintModel = ComplaintModel(
                      complaint["Complaint_ID"].toString(),
                      complaint["User_ID"].toString(),
                      userName,
                      complaint["Complaint_Description"].toString(),
                      complaint["Complaint_Date"].toString(),
                      complaint["Complaint_Answer"].toString(),
                      complaint["Complaint_State"].toString(),
                      complaint["Complaint_Answer_Date"].toString(),
                      complaint["User_Management_ID"].toString(),
                      complaint["Answer_Officer_ID"].toString(),
                  );
                  complaintsList.add(complaintModel!);
                });
              }
            }
            emit(OfficerDisplayComplaintSuccessGetComplaintsState());
      }).catchError((error) {
        if (error is DioError) {
          emit(OfficerDisplayComplaintErrorGetComplaintsState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
        } else {
          emit(OfficerDisplayComplaintErrorGetComplaintsState(error.toString()));
        }
      });
  }

  Future<void> updateComplaint(BuildContext context ,String userID, String userManagementID, String officerID, String complaintID, String complaintDescription, String complaintDate, String complaintAnswer)async {
    emit(OfficerDisplayComplaintLoadingUpdateComplaintState());

    DateTime answerDate = DateTime.now();
    String lastDate =
    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(answerDate);

    await DioHelper.updateData(
        url: 'complaints/PutComplaint',
        query: {
            'User_ID': int.parse(userID),
            'Complaint_ID': int.parse(complaintID),
            'Complaint_Description': complaintDescription,
            'Complaint_Date': DateTime.parse(complaintDate),
            'Complaint_Answer': complaintAnswer,
            'Complaint_Answer_Date': lastDate,
            'Answer_Officer_ID': officerID,
            'User_Management_ID': userManagementID,
            'Complaint_State': true,
    }).then((value){
      showToast(message: "تم تعديل الشكوى بنجاح", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }
      emit(OfficerDisplayComplaintSuccessUpdateComplaintState());
    })/*.catchError((error){
      if(error is DioError){
        emit(OfficerDisplayComplaintErrorUpdateComplaintState(error.toString()));
      }else{
        emit(OfficerDisplayComplaintErrorUpdateComplaintState(error.toString()));
      }
    })*/;
  }

  Future<void> deleteComplaint(BuildContext context ,String complaintID)async {
    emit(OfficerDisplayComplaintLoadingDeleteComplaintState());
    await DioHelper.deleteData(url: 'complaints/DeleteWithParams', query: {
      'Complaint_ID': complaintID
    }).then((value){
      showToast(message: "تم حذف الشكوى بنجاح", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }
      emit(OfficerDisplayComplaintSuccessDeleteComplaintState());
    }).catchError((error){
      if(error is DioError){
        emit(OfficerDisplayComplaintErrorDeleteComplaintState("لقد حدث خطأ ما برجاء المحاولة لاحقاً"));
      }else{
        emit(OfficerDisplayComplaintErrorDeleteComplaintState(error.toString()));
      }
    });
  }

  void navigateToDetails(BuildContext context, route){
    navigateTo(context, route);
  }
}