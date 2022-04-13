import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/cubit/monitor_officer_permission_cubit.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/cubit/monitor_officer_permission_states.dart';

class MonitorOfficerPermissionsScreen extends StatelessWidget {
  const MonitorOfficerPermissionsScreen({Key? key, required this.officerID}) : super(key: key);

  final String officerID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorOfficerPermissionCubit()..getUserData()..getPermissions(officerID),
      child: BlocConsumer<MonitorOfficerPermissionCubit, MonitorOfficerPermissionStates>(
        listener: (context, state){},
        builder: (context, state){

          var cubit = MonitorOfficerPermissionCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: const Text("صلاحيات الموظف", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 12),),
                  backgroundColor: Colors.teal[700],
                  systemOverlayStyle:  SystemUiOverlayStyle(
                    statusBarColor: Colors.teal[700],
                    statusBarIconBrightness: Brightness.light,
                    // For Android (dark icons)
                    statusBarBrightness: Brightness.dark, // For iOS (dark icons)
                  )
              ),
              body: Column(
                children: [
                  BuildCondition(
                    condition: state is MonitorOfficerPermissionLoadingGetPermissionsState,
                    builder: (context) => Center(
                      child: CircularProgressIndicator(
                        color: Colors.teal[700],
                        strokeWidth: 0.8,
                      ),
                    ),
                    fallback: (context) => ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) =>
                          listItem(context, cubit, state, index),
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 10.0),
                      itemCount: cubit.permissionModelList.length,
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InkWell(
                      onTap: (){
                        cubit.addPermissionToClerk();
                      },
                      splashColor: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.teal.shade500,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: const Center(child: Text("اضافة صلاحيات", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
        ),
    );
  }

  Widget listItem(BuildContext context, MonitorOfficerPermissionCubit cubit, state, int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        elevation: 2,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  cubit.permissionModelList[index].permissionDescription,
                  style: TextStyle(
                      color: Colors.teal[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: (){
                  cubit.deletePermissionFromClerk(officerID, cubit.permissionModelList[index].permissionID);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: FadeIn(
                    duration: const Duration(milliseconds: 500),
                    child: const CircleAvatar(
                      child: Icon(
                        Icons.remove_circle_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      backgroundColor: Colors.red,
                      maxRadius: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
