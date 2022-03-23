import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Global/Complaints/clerk/cubit/add_complaint_cubit.dart';
import 'package:mostaqbal_masr/shared/components.dart';

import '../cubit/add_complaint_states.dart';

class AddComplaintScreen extends StatelessWidget {

  final String userID;
  final String userManagementID;
  AddComplaintScreen({Key? key, required this.userID, required this.userManagementID}) : super(key: key);

  var complaintDescription = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AddComplaintCubit(),
        child: BlocConsumer<AddComplaintCubit, AddComplaintStates>(
            listener: (context, state){
              if(state is AddComplaintErrorSendComplaintState){
                showToast(message: state.error, length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
              }
            },
            builder: (context, state){

              var cubit = AddComplaintCubit.get(context);

              return Scaffold(
                appBar: AppBar(
                  toolbarHeight: 0,
                  elevation: 0,
                ),
                body: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
                    child: Form(
                      key: formKey,
                      child: CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.80,
                                  child: TextFormField(
                                    textDirection: TextDirection.rtl,
                                    controller: complaintDescription,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    maxLines: 30,
                                    maxLength: 500,
                                    minLines: 1,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'يجب كتابة وصف الشكوى !';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.teal, width: 1.0),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8.0))),
                                      floatingLabelStyle:
                                      TextStyle(color: Colors.teal[700]),
                                      labelText: 'وصف الشكوى',
                                      alignLabelWithHint: true,
                                      hintTextDirection: TextDirection.rtl,
                                      border: const OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8.0))),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                BuildCondition(
                                  condition: state is AddComplaintLoadingSendComplaintState,
                                  builder: (context) => Center(child: CircularProgressIndicator(color: Colors.teal.shade500, strokeWidth: 0.8,),),
                                  fallback: (context) => InkWell(
                                    onTap: (){
                                      if(formKey.currentState!.validate()){
                                        cubit.sendComplaint(context, userID, userManagementID, complaintDescription.text.toString());
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
                                            offset: const Offset(0, 0), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.teal.shade500,
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.80,
                                      height: 40,
                                      child: const Center(child: Text("ارسال الشكوى", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

              );
            },
        )
    );
  }
}
