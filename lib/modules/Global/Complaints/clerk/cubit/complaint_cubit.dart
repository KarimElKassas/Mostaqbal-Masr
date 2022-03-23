import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Global/Complaints/clerk/cubit/complaint_states.dart';
import 'package:mostaqbal_masr/modules/Global/Complaints/clerk/screens/add_complaint_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Complaints/officer/screens/officer_display_complaints_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/display_complaints_screen.dart';

class ComplaintCubit extends Cubit<ComplaintStates>{
  ComplaintCubit() : super(ComplaintInitialState());

  static ComplaintCubit get(context) => BlocProvider.of(context);

  String userID = "";
  String receiverID = "Future Of Egypt";
  String userName = "";
  String userPhone = "";
  String userNumber = "";
  String userPassword = "";
  String userManagementID = "";
  String userManagementName = "";
  String userCategoryName = "";
  String userRankName = "";
  String userTypeName = "";
  String userCoreStrengthName = "";
  String userPresenceName = "";
  String userJobName = "";
  String userToken = "";
  String userImage = "";

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userID = prefs.getString("ClerkID")!;
    userName = prefs.getString("ClerkName")!;
    userPhone = prefs.getString("ClerkPhone")!;
    userNumber = prefs.getString("ClerkNumber")!;
    userPassword = prefs.getString("ClerkPassword")!;
    userManagementID = prefs.getString("ClerkManagementID")!;
    userManagementName = prefs.getString("ClerkManagementName")!;
    userTypeName = prefs.getString("ClerkTypeName")!;
    userRankName = prefs.getString("ClerkRankName")!;
    userCategoryName = prefs.getString("ClerkCategoryName")!;
    userCoreStrengthName = prefs.getString("ClerkCoreStrengthName")!;
    userPresenceName = prefs.getString("ClerkPresenceName")!;
    userJobName = prefs.getString("ClerkJobName")!;
    userToken = prefs.getString("ClerkToken")!;
    userImage = prefs.getString("ClerkImage")!;

    emit(ComplaintGetUserDataState());
  }

  void navigateToAddComplaint(BuildContext context){
    navigateTo(context, AddComplaintScreen(userID: userID, userManagementID: userManagementID,));
  }

  void navigateToOfficerDisplayComplaint(BuildContext context){
    navigateTo(context, OfficerDisplayComplaintScreen(officerID: userID,));
  }
  void navigateToDisplayComplaint(BuildContext context){
    navigateTo(context, DisplayComplaintScreen(userID: userID,));
  }
}