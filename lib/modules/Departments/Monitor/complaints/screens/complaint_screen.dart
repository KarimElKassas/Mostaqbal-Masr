import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/complaints/cubit/officer_complaint_cubit.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/complaints/cubit/officer_complaint_states.dart';
import 'package:mostaqbal_masr/modules/Global/Complaints/clerk/cubit/complaint_cubit.dart';
import 'package:mostaqbal_masr/modules/Global/Complaints/clerk/cubit/complaint_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class OfficerComplaintScreen extends StatelessWidget {
  const OfficerComplaintScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OfficerComplaintCubit()..getUserData()..getDepartmentManager()..getAllPermissions(),
      child: BlocConsumer<OfficerComplaintCubit, OfficerComplaintStates>(
        listener: (context, state){
          if(state is OfficerComplaintGetPermissionsState){
            print(OfficerComplaintCubit.get(context).buttonPermission[1]);
          }
          if(state is OfficerComplaintGetClerksForPermissionsState){
            print(OfficerComplaintCubit.get(context).clerkPermissionList[0]);
          }
        },
        builder: (context, state){

          var cubit = OfficerComplaintCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("قسم الشكاوى", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              backgroundColor: Colors.teal[700],
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48.0, horizontal: 36),
                child: Center(
                  child: SlideInUp(
                    duration: const Duration(milliseconds: 1500),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.shade700,
                            spreadRadius: 0.16,
                            blurRadius: 0.1,
                            offset: const Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("اهلا بيك  \n ${cubit.userName}", style: TextStyle(color: Colors.teal.shade500, fontWeight: FontWeight.normal, wordSpacing: 2, fontSize: 14, overflow: TextOverflow.ellipsis,), overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,),
                              const SizedBox(height: 24,),
                              //const Spacer(),
                              Visibility(
                                visible: (cubit.departmentManagerList.contains(cubit.userPhone) || cubit.clerkPermissionList.contains(cubit.userPhone)),
                                child: InkWell(
                                  onTap: (){
                                    cubit.navigateToClerkComplaint(context);
                                  },
                                  splashColor: Colors.white,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.teal.shade500,
                                    ),
                                    width: MediaQuery.of(context).size.width / 1.8,
                                    height: 40,
                                    child: const Center(child: Text("شكاوى الموظفين", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),)),
                                  ),
                                ),
                              ),
                              (cubit.clerkPermissionList.contains(cubit.userPhone) || cubit.departmentManagerList.contains(cubit.userPhone)) ? const SizedBox(height: 16,) : getEmptyWidget(),
                              Visibility(
                                visible: (cubit.clientPermissionList.contains(cubit.userPhone) || cubit.departmentManagerList.contains(cubit.userPhone)),
                                child: InkWell(
                                  onTap: (){
                                    cubit.navigateToDisplayClientComplaint(context);
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
                                      color: Colors.white,
                                    ),
                                    width: MediaQuery.of(context).size.width / 1.8,
                                    height: 40,
                                    child: Center(child: Text("شكاوى العملاء", style: TextStyle(color: Colors.teal.shade500, fontWeight: FontWeight.bold, fontSize: 12),)),
                                  ),
                                ),
                              ),
                              (cubit.clientPermissionList.contains(cubit.userPhone) || cubit.departmentManagerList.contains(cubit.userPhone)) ? const SizedBox(height: 16,) : getEmptyWidget(),
                              InkWell(
                                onTap: (){
                                  cubit.logOut(context);
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
                                    color: Colors.white,
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.8,
                                  height: 40,
                                  child: Center(child: Text("تسجيل الخروج", style: TextStyle(color: Colors.teal.shade500, fontWeight: FontWeight.bold, fontSize: 12),)),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
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
}
