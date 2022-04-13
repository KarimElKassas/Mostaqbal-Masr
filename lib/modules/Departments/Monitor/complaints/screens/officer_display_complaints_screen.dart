import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as i;
import 'package:mostaqbal_masr/shared/components.dart';

import '../cubit/officer_display_complaint_cubit.dart';
import '../cubit/officer_display_complaint_states.dart';
import 'officer_complaint_details_screen.dart';

// ignore: must_be_immutable
class OfficerDisplayComplaintScreen extends StatefulWidget {
  final String officerID;

  const OfficerDisplayComplaintScreen({Key? key, required this.officerID})
      : super(key: key);

  @override
  State<OfficerDisplayComplaintScreen> createState() => _OfficerDisplayComplaintScreenState();
}

class _OfficerDisplayComplaintScreenState extends State<OfficerDisplayComplaintScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfficerDisplayComplaintCubit()..getSpecifyDepartments(),
      child: BlocConsumer<OfficerDisplayComplaintCubit, OfficerDisplayComplaintStates>(
        listener: (context, state) {
          if (state is OfficerDisplayComplaintErrorGetComplaintsState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is OfficerDisplayComplaintErrorGetDepartmentsState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
        },
        builder: (context, state) {
          var cubit = OfficerDisplayComplaintCubit.get(context);

          return WillPopScope(
            onWillPop: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  SystemNavigator.pop();
              }
              return Future.value(false);
            },
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 0,
                elevation: 0,
              ),
              key: cubit.scaffoldKey,
              body: cubit.filteredDepartments ? Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16.0, horizontal: 14),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        cubit.filteredDepartments ? SizedBox(
                          height: 80,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>
                                departmentItem(context, cubit, state, index),
                            separatorBuilder: (context, index) =>
                            const SizedBox(
                              width: 2,
                            ),
                            itemCount: cubit.departmentsCustomList.length,
                          ),
                        ) : Center(
                          child: CircularProgressIndicator(
                            color: Colors.teal.shade500,
                            strokeWidth: 0.8,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (!cubit.waitingComplaints) {
                                    cubit.changeFilterRespond("لم يتم الرد");
                                    cubit.getFilteredComplaints(cubit.selectedDepartmentID!.toString(), false);
                                  }
                                },
                                splashColor: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.teal.shade700,
                                        spreadRadius: 0.16,
                                        blurRadius: 0,
                                        offset: const Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                    color: cubit.waitingComplaints
                                        ? Colors.teal.shade500
                                        : Colors.white,
                                  ),
                                  height: 40,
                                  child: Center(
                                      child: Text(
                                        "لم يتم الرد",
                                        style: TextStyle(
                                            color: cubit.waitingComplaints
                                                ? Colors.white
                                                : Colors.teal.shade500,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      )),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (!cubit.answeredComplaints) {
                                    cubit.changeFilterRespond("تم الرد");
                                    cubit.getFilteredComplaints(cubit.selectedDepartmentID!.toString(), true);
                                  }
                                },
                                splashColor: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.teal.shade700,
                                        spreadRadius: 0.16,
                                        blurRadius: 0,
                                        offset: const Offset(
                                            0, 0), // changes position of shadow
                                      ),
                                    ],
                                    color: cubit.answeredComplaints
                                        ? Colors.teal.shade500
                                        : Colors.white,
                                  ),
                                  height: 40,
                                  child: Center(
                                      child: Text(
                                        "تم الرد",
                                        style: TextStyle(
                                            color: cubit.answeredComplaints
                                                ? Colors.white
                                                : Colors.teal.shade500,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        state is OfficerDisplayComplaintLoadingComplaintsState
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.teal.shade500,
                                  strokeWidth: 0.8,
                                ),
                              )
                            : cubit.complaintsList.isNotEmpty ? ListView.separated(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) =>
                                    listItem(context, cubit, state, index),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 1,
                                ),
                                itemCount: cubit.complaintsList.length,
                              ) : const Center(child: Text("لا يوجد شكاوى", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.normal, fontSize: 18),)),
                      ],
                    ),
                  ),
                ),
              ) : Center(child: CircularProgressIndicator(color: Colors.teal[600], strokeWidth: 0.8,),),
            ),
          );
        },
      ),
    );
  }


  Widget departmentItem(BuildContext context, OfficerDisplayComplaintCubit cubit, state, int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2),
      child: InkWell(
        onTap: () {
          if(cubit.selectedDepartmentID != cubit.departmentsCustomList[index].departmentID){
            cubit.changeFilter(cubit.departmentsCustomList[index].departmentID!);
            cubit.getFilteredComplaints(cubit.departmentsCustomList[index].departmentID!.toString(), cubit.answeredComplaints);
          }
        },
        splashColor: Colors.white,
        child: Card(
          semanticContainer: true,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          shadowColor: Colors.black,
          color: cubit.selectedDepartmentID == cubit.departmentsCustomList[index].departmentID
              ? Colors.teal.shade500
              : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            child: Center(
                child: Text(
                  cubit.departmentsCustomList[index].departmentName,
                  style: TextStyle(
                      color: cubit.selectedDepartmentID == cubit.departmentsCustomList[index].departmentID
                          ? Colors.white
                          : Colors.teal.shade500,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                )),
          ),
        ),
      ),
    );

  }
  Widget listItem(
      BuildContext context, OfficerDisplayComplaintCubit cubit, state, int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        //margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
        shadowColor: Colors.black,
        child: InkWell(
          onTap: () {
            cubit.navigateToDetails(context,
                OfficerComplaintDetailsScreen(
                    userID: cubit.complaintsList[index].userID,
                    userManagementID: cubit.complaintsList[index].userManagementID,
                    officerID: widget.officerID,
                    complaintID: cubit.complaintsList[index].complaintID,
                    complaintDescription: cubit.complaintsList[index].complaintDescription,
                    complaintDate: cubit.complaintsList[index].complaintDate,
                    complaintAnswer: cubit.complaintsList[index].complaintAnswer,
                    complaintAnswerDate: cubit.complaintsList[index].complaintAnswerDate,
                    complaintState: cubit.complaintsList[index].complaintState));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      cubit.complaintsList[index].userName,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: cubit.complaintsList[index].complaintState ==
                              "false"
                              ? Colors.red.shade700
                              : Colors.teal.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      cubit.complaintsList[index].complaintDescription,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      children: [
                        Text(
                          i.DateFormat.yMMMMEEEEd('ar').format(DateTime.parse(
                              cubit.complaintsList[index].complaintDate)),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w200,
                            overflow: TextOverflow.ellipsis,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                        const Spacer(),
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  cubit.complaintsList[index].complaintState ==
                                          "false"
                                      ? Colors.red
                                      : Colors.teal.shade500),
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          cubit.complaintsList[index].complaintState == "false"
                              ? "تحت النظر"
                              : "تم الرد",
                          style: TextStyle(
                            color:
                                cubit.complaintsList[index].complaintState ==
                                        "false"
                                    ? Colors.red
                                    : Colors.teal.shade500,
                            fontSize: 10,
                            fontWeight: FontWeight.w200,
                            overflow: TextOverflow.ellipsis,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
