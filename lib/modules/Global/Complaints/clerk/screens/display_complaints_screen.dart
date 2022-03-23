import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as i;
import 'package:mostaqbal_masr/modules/Global/Complaints/clerk/screens/complaint_details_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';

import '../cubit/display_complaint_cubit.dart';
import '../cubit/display_complaint_states.dart';

// ignore: must_be_immutable
class DisplayComplaintScreen extends StatelessWidget {
  final String userID;

  const DisplayComplaintScreen({Key? key, required this.userID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DisplayComplaintCubit()..getFilteredComplaints(userID, false),
      child: BlocConsumer<DisplayComplaintCubit, DisplayComplaintStates>(
        listener: (context, state) {
          if (state is DisplayComplaintErrorGetComplaintsState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
        },
        builder: (context, state) {
          var cubit = DisplayComplaintCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 0,
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (!cubit.waitingComplaints) {
                                    cubit.changeFilter("لم يتم الرد");
                                    cubit.getFilteredComplaints(userID, false);
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
                                  width:
                                  MediaQuery.of(context).size.width / 2.2,
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
                              const SizedBox(
                                width: 12.0,
                              ),
                              InkWell(
                                onTap: () {
                                  if (!cubit.answeredComplaints) {
                                    cubit.changeFilter("تم الرد");
                                    cubit.getFilteredComplaints(userID, true);
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
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
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
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      state is DisplayComplaintLoadingComplaintsState
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.teal.shade500,
                                strokeWidth: 0.8,
                              ),
                            )
                          : cubit.complaintsList!.isNotEmpty ? ListView.separated(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) =>
                                  listItem(context, cubit, state, index),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 1,
                              ),
                              itemCount: cubit.complaintsList!.length,
                            ) : const Center(child: Text("لا يوجد شكاوى", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.normal, fontSize: 18),)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget listItem(
      BuildContext context, DisplayComplaintCubit cubit, state, int index) {
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
                ComplaintDetailsScreen(
                    userID: userID,
                    complaintID: cubit.complaintsList![index].complaintID,
                    complaintDescription: cubit.complaintsList![index].complaintDescription,
                    complaintDate: cubit.complaintsList![index].complaintDate,
                    complaintAnswer: cubit.complaintsList![index].complaintAnswer,
                    complaintAnswerDate: cubit.complaintsList![index].complaintAnswerDate,
                    complaintState: cubit.complaintsList![index].complaintState));
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
                      cubit.complaintsList![index].complaintDescription,
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
                              cubit.complaintsList![index].complaintDate)),
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
                                  cubit.complaintsList![index].complaintState ==
                                          "false"
                                      ? Colors.red
                                      : Colors.teal.shade500),
                        ),
                        const SizedBox(
                          width: 4.0,
                        ),
                        Text(
                          cubit.complaintsList![index].complaintState == "false"
                              ? "تحت النظر"
                              : "تم الرد",
                          style: TextStyle(
                            color:
                                cubit.complaintsList![index].complaintState ==
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
