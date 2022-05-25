import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/shared/components.dart';

import '../../../../../shared/constants.dart';
import '../cubit/monitor_management_permission_cubit.dart';
import '../cubit/monitor_management_permission_states.dart';

class MonitorManagementPermissionsScreen extends StatefulWidget {
  const MonitorManagementPermissionsScreen({Key? key}) : super(key: key);

  @override
  State<MonitorManagementPermissionsScreen> createState() =>
      _MonitorManagementPermissionsScreenState();
}

class _MonitorManagementPermissionsScreenState extends State<MonitorManagementPermissionsScreen> {

    var permissionDescriptionController = TextEditingController();
    var dialogKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorManagementPermissionCubit()..getPermissions(),
      child: BlocConsumer<MonitorManagementPermissionCubit,
              MonitorManagementPermissionStates>(
          listener: (context, state) {
          },
          builder: (context, state) {
            var cubit = MonitorManagementPermissionCubit.get(context);

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                    centerTitle: true,
                    title: const Text(
                      "صلاحيات الادارة",
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
                      statusBarBrightness:
                          Brightness.dark, // For iOS (dark icons)
                    )),
                body: BuildCondition(
                    condition: !cubit.gotPermission,
                    builder: (context) => Center(
                          child: CircularProgressIndicator(
                            color: Colors.teal[700],
                            strokeWidth: 0.8,
                          ),
                        ),
                    fallback: (_) {
                      return cubit.permissionModelList.isNotEmpty
                          ? hasPermissions(context, cubit, state)
                          : zeroPermissions(context, cubit, state);
                    }),
              ),
            );
          }),
    );
  }

  Widget listItem(BuildContext context, MonitorManagementPermissionCubit cubit, state, int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => BlurryDialog("تنبيه", "هل تريد حذف هذه الصلاحية ؟", (){
                        cubit.deletePermission(cubit.permissionModelList[index].permissionID);
                      })
                  );
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

  Widget hasPermissions(
      BuildContext context, MonitorManagementPermissionCubit cubit, state) {
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
            itemCount: cubit.permissionModelList.length,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return SlideInUp(
                              duration:
                              const Duration(milliseconds: 500),
                              child: Form(
                                key: dialogKey,
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.90,
                                            child: TextFormField(
                                              textDirection:
                                              TextDirection.rtl,
                                              controller:
                                              permissionDescriptionController,
                                              keyboardType:
                                              TextInputType.multiline,
                                              textInputAction:
                                              TextInputAction.newline,
                                              maxLines: 10,
                                              maxLength: 500,
                                              minLines: 1,
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return 'يجب كتابة وصف الصلاحية !';
                                                }
                                                return null;
                                              },
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                              decoration: InputDecoration(
                                                focusedBorder: const OutlineInputBorder(
                                                    borderSide:
                                                    BorderSide(
                                                        color: Colors
                                                            .teal,
                                                        width: 1.0),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius
                                                            .circular(
                                                            8.0))),
                                                floatingLabelStyle:
                                                TextStyle(
                                                    color: Colors
                                                        .teal[700]),
                                                labelText: 'وصف الصلاحية',
                                                alignLabelWithHint: true,
                                                hintTextDirection:
                                                TextDirection.rtl,
                                                border: const OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius
                                                            .circular(
                                                            8.0))),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 18.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: (){
                                                  permissionDescriptionController.text = "";
                                                  Navigator.pop(
                                                      context);
                                                },
                                                child: Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        6),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .teal
                                                            .shade700,
                                                        spreadRadius:
                                                        0.16,
                                                        blurRadius: 0,
                                                        offset: const Offset(
                                                            0,
                                                            0), // changes position of shadow
                                                      ),
                                                    ],
                                                    color: Colors
                                                        .white,
                                                  ),
                                                  //width: MediaQuery.of(context).size.width / 2.5,
                                                  height: 40,
                                                  child: Center(
                                                      child: Text(
                                                        "رجوع",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .teal.shade700,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 12),
                                                      )),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 12,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: ()async {
                                                  if(dialogKey.currentState!.validate()) {
                                                    await cubit.addManagementPermission(
                                                        permissionDescriptionController.text.toString());
                                                    permissionDescriptionController.text = "";
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                child: state
                                                is MonitorManagementPermissionLoadingAddPermissionsState
                                                    ? Center(
                                                    child:
                                                    CircularProgressIndicator(
                                                      color: Colors
                                                          .teal
                                                          .shade700,
                                                      strokeWidth:
                                                      0.8,
                                                    ))
                                                    : Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        6),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .teal
                                                            .shade700,
                                                        spreadRadius:
                                                        0.16,
                                                        blurRadius:
                                                        0,
                                                        offset: const Offset(
                                                            0,
                                                            0), // changes position of shadow
                                                      ),
                                                    ],
                                                    color: Colors
                                                        .teal
                                                        .shade700,
                                                  ),
                                                  //width: MediaQuery.of(context).size.width / 2.5,
                                                  height: 40,
                                                  child:
                                                  const Center(
                                                      child:
                                                      Text(
                                                        "اضافة",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize:
                                                            12),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  splashColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.teal.shade700,
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: const Center(
                        child: Text(
                      "اضافة صلاحيات جديدة",
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

  Widget zeroPermissions(
      BuildContext context, MonitorManagementPermissionCubit cubit, MonitorManagementPermissionStates state) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Center(
            child: Text(
          "لا يوجد فى الادارة \n اى صلاحيات حتى الان",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.teal[700],
              fontWeight: FontWeight.bold,
              fontSize: 16,
              height: 1.5),
        )),
        Positioned(
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: ()async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return SlideInUp(
                          duration:
                          const Duration(milliseconds: 500),
                          child: Form(
                            key: dialogKey,
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: SizedBox(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.90,
                                        child: TextFormField(
                                          textDirection:
                                          TextDirection.rtl,
                                          controller:
                                          permissionDescriptionController,
                                          keyboardType:
                                          TextInputType.multiline,
                                          textInputAction:
                                          TextInputAction.newline,
                                          maxLines: 10,
                                          maxLength: 500,
                                          minLines: 1,
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'يجب كتابة وصف الصلاحية !';
                                            }
                                            return null;
                                          },
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                          decoration: InputDecoration(
                                            focusedBorder: const OutlineInputBorder(
                                                borderSide:
                                                BorderSide(
                                                    color: Colors
                                                        .teal,
                                                    width: 1.0),
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius
                                                        .circular(
                                                        8.0))),
                                            floatingLabelStyle:
                                            TextStyle(
                                                color: Colors
                                                    .teal[700]),
                                            labelText: 'وصف الصلاحية',
                                            alignLabelWithHint: true,
                                            hintTextDirection:
                                            TextDirection.rtl,
                                            border: const OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius
                                                        .circular(
                                                        8.0))),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 18.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: (){
                                              permissionDescriptionController.text = "";
                                              Navigator.pop(
                                                  context);
                                            },
                                            child: Container(
                                              decoration:
                                              BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    6),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors
                                                        .teal
                                                        .shade700,
                                                    spreadRadius:
                                                    0.16,
                                                    blurRadius: 0,
                                                    offset: const Offset(
                                                        0,
                                                        0), // changes position of shadow
                                                  ),
                                                ],
                                                color: Colors
                                                    .white,
                                              ),
                                              //width: MediaQuery.of(context).size.width / 2.5,
                                              height: 40,
                                              child: Center(
                                                  child: Text(
                                                    "رجوع",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .teal.shade700,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize: 12),
                                                  )),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: ()async {
                                              if(dialogKey.currentState!.validate()) {
                                                await cubit.addManagementPermission(
                                                    permissionDescriptionController.text.toString());
                                                permissionDescriptionController.text = "";
                                                Navigator.pop(context);
                                              }
                                            },
                                            child: state
                                            is MonitorManagementPermissionLoadingAddPermissionsState
                                                ? Center(
                                                child:
                                                CircularProgressIndicator(
                                                  color: Colors
                                                      .teal
                                                      .shade700,
                                                  strokeWidth:
                                                  0.8,
                                                ))
                                                : Container(
                                              decoration:
                                              BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    6),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors
                                                        .teal
                                                        .shade700,
                                                    spreadRadius:
                                                    0.16,
                                                    blurRadius:
                                                    0,
                                                    offset: const Offset(
                                                        0,
                                                        0), // changes position of shadow
                                                  ),
                                                ],
                                                color: Colors
                                                    .teal
                                                    .shade700,
                                              ),
                                              //width: MediaQuery.of(context).size.width / 2.5,
                                              height: 40,
                                              child:
                                              const Center(
                                                  child:
                                                  Text(
                                                    "اضافة",
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                        fontSize:
                                                        12),
                                                  )),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              splashColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.teal[700],
                ),
                width: MediaQuery.of(context).size.width * 0.98,
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
        ),
      ],
    );
  }
}
