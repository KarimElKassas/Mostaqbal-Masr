import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/deparment_core/screens/monitor_core_screen.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/home/cubit/monitor_manager_home_cubit.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/home/cubit/monitor_manager_home_states.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/permissions/screens/monitor_permission_details_screen.dart';

class MonitorManagerHomeScreen extends StatelessWidget {
  const MonitorManagerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorManagerHomeCubit()
        ..getUserData()
        ..getManagementClerks()
        ..getPermissions(),
      child: BlocConsumer<MonitorManagerHomeCubit, MonitorManagerHomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = MonitorManagerHomeCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.teal,
                statusBarIconBrightness: Brightness.light,
                // For Android (dark icons)
                statusBarBrightness: Brightness.dark, // For iOS (dark icons)
              ),
              centerTitle: true,
              title: const Text(
                "إدارة الرقابة والمتابعة",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 4.5),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.teal.shade600,
                        Colors.teal.shade400,
                        Colors.teal.shade300,
                      ],
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: const [0.0, 0.5, 1.0],
                      tileMode: TileMode.clamp),
                ),
              ),
              elevation: 0,
              toolbarHeight: MediaQuery.of(context).size.height * 0.05,
            ),
            backgroundColor: Colors.teal,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Colors.teal.shade600,
                      Colors.teal.shade400,
                      Colors.teal.shade300,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: const [0.0, 0.5, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.98),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12),
                    child: cubit.gotPermission ? SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          InkWell(
                            onTap: (){
                              cubit.navigateTo(context, MonitorCoreScreen(departmentID: cubit.userManagementID, departmentName: cubit.userManagementName,));
                            },
                            child: FadeInDown(
                              duration: const Duration(milliseconds: 1500),
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.90,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width *
                                              0.25,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child:
                                                Image.asset("assets/images/me.jpg"),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              cubit.userName,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  overflow: TextOverflow.ellipsis),
                                                overflow: TextOverflow.ellipsis
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              cubit.userManagementName,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Text(
                                              "قوة الإدارة : ${cubit.filteredClerksModelList.length}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          FadeInRight(duration: const Duration(milliseconds: 1500), child: const Text('صلاحيات الإدارة', style: TextStyle(color: Colors.teal, fontSize: 12),)),
                          const SizedBox(
                            height: 8,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (_, index) => permissionItem(context, cubit, index),
                            itemCount: cubit.permissionModelList.length,
                          )
                        ],
                      ),
                    ) : Center(child: CircularProgressIndicator(color: Colors.teal[500], strokeWidth: 0.8,),),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget permissionItem(
      BuildContext context, MonitorManagerHomeCubit cubit, int index) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1500),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        child: InkWell(
          onTap: (){
            cubit.navigateTo(context, MonitorPermissionDetailsScreen(permissionID: cubit.permissionModelList[index].permissionID));
          },
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              decoration: BoxDecoration(
                color: RandomColor().colorRandomizer(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(IconlyBroken.notification, color: Colors.white, size: 40,),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      cubit.permissionModelList[index].permissionDescription,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class RandomColor {
  List color = [
    Color(0xFF5DA55B),
    Color(0xFF715699),
    Color(0xFF60AAA9),
    Color(0xFF5999BD),
    Color(0xFF4A7CB9),
    Color(0xFFE5AA46),
  ];

  var index = Random().nextInt(6);

  Color colorRandomizer() {
    return color[index];
  }
}