import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/complaints/screens/officer_display_client_complaints_screen.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/complaints/screens/officer_display_complaints_screen.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/cubit/monitor_manager_home_cubit.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/cubit/monitor_manager_home_states.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/screens/monitor_display_users_screen.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/screens/monitor_management_permissions_screen.dart';

class MonitorManagerHomeScreen extends StatelessWidget {
  const MonitorManagerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorManagerHomeCubit()..getUserData()..getManagementClerks(),
      child: BlocConsumer<MonitorManagerHomeCubit, MonitorManagerHomeStates>(
        listener: (context, state){

        },
        builder: (context, state){

          var cubit = MonitorManagerHomeCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text("إدارة الرقابة والمتابعة", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
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
                      height: MediaQuery.of(context).size.height / 1.8,
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
                              InkWell(
                                onTap: (){
                                  cubit.navigateTo(context, const MonitorManagementPermissionsScreen());
                                },
                                splashColor: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.teal.shade500,
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.8,
                                  height: 40,
                                  child: const Center(child: Text("صلاحيات الإدارة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),)),
                                ),
                              ),
                              const SizedBox(height: 16,),
                              InkWell(
                                onTap: (){
                                  cubit.navigateTo(context, MonitorDisplayUsersScreen(clerksList: cubit.filteredClerksModelList));
                                },
                                splashColor: Colors.white,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.teal.shade500,
                                  ),
                                  width: MediaQuery.of(context).size.width / 1.8,
                                  height: 40,
                                  child: const Center(child: Text("صلاحيات الموظفين", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),)),
                                ),
                              ),
                              const SizedBox(height: 16,),
                              InkWell(
                                onTap: (){
                                  cubit.navigateTo(context, OfficerDisplayComplaintScreen(officerID: cubit.userID));
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
                              const SizedBox(height: 16,),
                              InkWell(
                                onTap: (){
                                  cubit.navigateTo(context, OfficerDisplayClientComplaintsScreen(officerID: cubit.userID));
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
                              const SizedBox(height: 16,),
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
                              ),
                            ],
                          ),
                        ),
                      ),
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
