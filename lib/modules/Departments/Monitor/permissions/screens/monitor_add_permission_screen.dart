import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/models/officer_permission_model.dart';

import '../../../../../shared/components.dart';
import '../../../../../shared/constants.dart';
import '../cubit/monitor_officer_permission_cubit.dart';
import '../cubit/monitor_officer_permission_states.dart';

class MonitorAddPermissionsScreen extends StatelessWidget {
  const MonitorAddPermissionsScreen(
      {Key? key,
      required this.officerID,
      required this.unGrantedPermissionModelList})
      : super(key: key);

  final String officerID;
  final List<OfficerPermissionModel> unGrantedPermissionModelList;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorOfficerPermissionCubit()
        ..getUserData()
        ,
      child: BlocConsumer<MonitorOfficerPermissionCubit,
          MonitorOfficerPermissionStates>(listener: (context, state) {
        if (state
            is MonitorOfficerPermissionLoadingAddPermissionsToClerkState) {
          showDialog(
              context: context,
              builder: (BuildContext context) => const BlurryProgressDialog(
                  title: "جارى اضافة الصلاحيات ..."));
        }
      }, builder: (context, state) {
        var cubit = MonitorOfficerPermissionCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  "اضافة صلاحيات",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ),
                backgroundColor: Colors.teal[700],
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.teal[700],
                  statusBarIconBrightness: Brightness.light,
                  // For Android (dark icons)
                  statusBarBrightness: Brightness.dark, // For iOS (dark icons)
                )),
            body: BuildCondition(
                condition: state
                    is MonitorOfficerPermissionLoadingUnGrantedPermissionsState,
                builder: (context) => Center(
                      child: CircularProgressIndicator(
                        color: Colors.teal[700],
                        strokeWidth: 0.8,
                      ),
                    ),
                fallback: (_) {
                  return hasPermissions(context, cubit, state);
                }),
          ),
        );
      }),
    );
  }

  Widget hasPermissions(
      BuildContext context, MonitorOfficerPermissionCubit cubit, state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) => Column(
              children: [
                listItem(context, cubit, state, index),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
              ],
            ),
            separatorBuilder: (context, index) => getEmptyWidget(),
            itemCount: unGrantedPermissionModelList.length,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
            onTap: () {
              if(cubit.selectedUnGrantedPermissionModelList.isNotEmpty){
                showDialog(
                    context: context,
                    builder: (blurContext) =>
                        BlurryDialog("تنبيه", "هل تريد اضافة هذه الصلاحيات ؟", () {
                          cubit
                              .addPermissionToClerk(officerID, cubit.userNumber)
                              .then((value) async {
                            for (int i = 0; i <= 1; i++) {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                                await cubit.getPermissions(officerID);
                              } else {
                                SystemNavigator.pop();
                              }
                            }
                          });
                        }));
              }else{
               showToast(message: "يجب اختيار الصلاحيات اولاً", length: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3);
              }
            },
            splashColor: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.teal[700],
              ),
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: const Center(
                  child: Text(
                "اضافة صلاحيات",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              )),
            ),
          ),
        ),
      ],
    );
  }

  Widget listItem(BuildContext context, MonitorOfficerPermissionCubit cubit,
      state, int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: InkWell(
        onTap: () {
          if (cubit.selectedUnGrantedPermissionModelList
              .contains(unGrantedPermissionModelList[index])) {
            print("Yeeeees\n");
            cubit.removeUserFromSelect(unGrantedPermissionModelList[index]);
          } else {
            print("Nooooooo\n");
            cubit.addClerkToSelect(unGrantedPermissionModelList[index]);
          }
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    unGrantedPermissionModelList[index].permissionDescription,
                    style: TextStyle(
                        color: Colors.teal[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: cubit.selectedUnGrantedPermissionModelList
                          .contains(unGrantedPermissionModelList[index])
                      ? FadeIn(
                          duration: const Duration(milliseconds: 500),
                          child: const CircleAvatar(
                            child: Icon(
                              Icons.done_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            backgroundColor: Colors.teal,
                            maxRadius: 16,
                          ),
                        )
                      : FadeIn(
                          duration: const Duration(milliseconds: 500),
                          child: const CircleAvatar(
                            child: Icon(
                              Icons.add_circle_outline_rounded,
                              color: Colors.grey,
                              size: 24,
                            ),
                            backgroundColor: Colors.transparent,
                            maxRadius: 16,
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
