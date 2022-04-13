import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as i;
import 'package:mostaqbal_masr/shared/components.dart';

import '../cubit/officer_display_complaint_cubit.dart';
import '../cubit/officer_display_complaint_states.dart';

// ignore: must_be_immutable
class OfficerComplaintDetailsScreen extends StatefulWidget {
  final String userID;
  final String userManagementID;
  final String officerID;
  final String complaintID;
  final String complaintDescription;
  final String complaintDate;
  final String complaintAnswer;
  final String complaintAnswerDate;
  final String complaintState;

  const OfficerComplaintDetailsScreen(
      {Key? key,
      required this.userID,
      required this.userManagementID,
      required this.officerID,
      required this.complaintID,
      required this.complaintDescription,
      required this.complaintDate,
      required this.complaintAnswer,
      required this.complaintAnswerDate,
      required this.complaintState})
      : super(key: key);

  @override
  State<OfficerComplaintDetailsScreen> createState() =>
      _OfficerComplaintDetailsScreenState();
}

class _OfficerComplaintDetailsScreenState
    extends State<OfficerComplaintDetailsScreen> {
  var complaintAnswerController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfficerDisplayComplaintCubit(),
      child: BlocConsumer<OfficerDisplayComplaintCubit,
          OfficerDisplayComplaintStates>(
        listener: (context, state) {
          if (state is OfficerDisplayComplaintErrorGetComplaintsState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is OfficerDisplayComplaintErrorDeleteComplaintState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
          if (state is OfficerDisplayComplaintErrorUpdateComplaintState) {
            showToast(
                message: state.error,
                length: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 3);
          }
        },
        builder: (context, state) {
          var cubit = OfficerDisplayComplaintCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                "تفاصيل الشكوى",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.teal[700],
              automaticallyImplyLeading: false,
            ),
            body: Form(
              key: formKey,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 10),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        listItem(context, cubit, state),
                      ],
                    ),
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
      BuildContext context, OfficerDisplayComplaintCubit cubit, state) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.0)),
              shadowColor: Colors.black,
              child: InkWell(
                onTap: () {},
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
                            "وصف الشكوى :",
                            style: TextStyle(
                                color: Colors.teal.shade500,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            widget.complaintDescription,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Row(
                            children: [
                              Text(
                                i.DateFormat.yMMMMEEEEd('ar').format(
                                    DateTime.parse(widget.complaintDate)),
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
                                    color: widget.complaintState == "false"
                                        ? Colors.red
                                        : Colors.teal.shade500),
                              ),
                              const SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                widget.complaintState == "false"
                                    ? "تحت النظر"
                                    : "تم الرد",
                                style: TextStyle(
                                  color: widget.complaintState == "false"
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
                        height: 4.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            widget.complaintState == "true"
                ? Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    shadowColor: Colors.black,
                    child: InkWell(
                      onTap: () {},
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
                                  "الرد على الشكوى :",
                                  style: TextStyle(
                                      color: Colors.teal.shade500,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  widget.complaintAnswer,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 8.0,
                                ),
                                Text(
                                  widget.complaintAnswerDate != "null"
                                      ? i.DateFormat.yMMMMEEEEd('ar').format(
                                          DateTime.parse(
                                              widget.complaintAnswerDate))
                                      : "",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w200,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : getEmptyWidget(),
            widget.complaintState == "true"
                ? const SizedBox(
                    height: 16,
                  )
                : getEmptyWidget(),
            widget.complaintState == "false"
                ? Column(
                    children: [
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextFormField(
                            textDirection: TextDirection.rtl,
                            controller: complaintAnswerController,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            maxLines: 10,
                            maxLength: 500,
                            minLines: 1,
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'يجب كتابة الرد على الشكوى !';
                              }
                              return null;
                            },
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.teal, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              floatingLabelStyle:
                                  TextStyle(color: Colors.teal[700]),
                              labelText: 'الرد على الشكوى',
                              alignLabelWithHint: true,
                              hintTextDirection: TextDirection.rtl,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      state is OfficerDisplayComplaintLoadingUpdateComplaintState
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.teal.shade600,
                                strokeWidth: 0.8,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.updateComplaint(
                                      context,
                                      widget.userID,
                                      widget.userManagementID,
                                      widget.officerID,
                                      widget.complaintID,
                                      widget.complaintDescription,
                                      widget.complaintDate,
                                      complaintAnswerController.text
                                          .toString()).then((value) => Navigator.pop(context));
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
                                  color: Colors.teal.shade500,
                                ),
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                child: const Center(
                                    child: Text(
                                  "إرسال الرد",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )),
                              ),
                            ),
                    ],
                  )
                : getEmptyWidget(),
          ],
        ),
      ),
    );
  }
}
