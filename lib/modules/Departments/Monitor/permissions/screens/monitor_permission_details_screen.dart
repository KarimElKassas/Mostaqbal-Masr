import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/permissions/cubit/monitor_permission_details_cubit.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/permissions/screens/monitor_add_users_to_permission_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

import '../cubit/monitor_permission_details_states.dart';

class MonitorPermissionDetailsScreen extends StatefulWidget {
  const MonitorPermissionDetailsScreen({Key? key, required this.permissionID}) : super(key: key);

  final String permissionID;

  @override
  State<MonitorPermissionDetailsScreen> createState() =>
      _MonitorPermissionDetailsScreenState();
}

class _MonitorPermissionDetailsScreenState extends State<MonitorPermissionDetailsScreen> {
  var searchController = TextEditingController();

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorPermissionDetailsCubit()..getUserData()..getPermissionClerks(widget.permissionID),
      child: BlocConsumer<MonitorPermissionDetailsCubit, MonitorPermissionDetailsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = MonitorPermissionDetailsCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                // For Android (dark icons)
                statusBarBrightness: Brightness.light, // For iOS (dark icons)
              ),
              elevation: 0.0,
              toolbarHeight: 0.0,
              backgroundColor: Colors.transparent,
            ),
            floatingActionButton: FadeInUp(
              duration: const Duration(milliseconds: 1500),
              child: FloatingActionButton(
                onPressed: (){
                    cubit.navigateTo(context, MonitorAddUsersToPermissionScreen(permissionID: widget.permissionID, clerksModelIDList: cubit.filteredClerksIDList), widget.permissionID);
                },
                child: const Icon(IconlyBroken.addUser, color: Colors.white,),
                backgroundColor: Colors.teal,
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, right: 12.0, left: 12.0),
                        child: SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: TextFormField(
                            textAlign: TextAlign.right,
                            textAlignVertical: TextAlignVertical.center,
                            textDirection: TextDirection.rtl,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.search,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                searchText = value;
                              });
                              //cubit.searchUser(value);
                            },
                            style: TextStyle(
                                color: greyThreeColor,
                                fontFamily: "Open Sans",
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: greyFiveColor,
                              hintText: 'بحث ..',
                              hintStyle: TextStyle(
                                  color: greyThreeColor,
                                  fontFamily: "Open Sans",
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                              alignLabelWithHint: true,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: greyBorderColor, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: greyBorderColor, width: 1.0),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: greyBorderColor, width: 1.0),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                       if(cubit.zeroClerks)
                       const Center(child: Text("لا يوجد موظفين لديهم هذا الإذن", style: TextStyle(color: Colors.teal,),)),
                      if (cubit.gotClerks) Visibility(
                        visible: cubit.filteredClerksModelList.isNotEmpty,
                        child: ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) =>
                                Column(
                                  children: [
                                    listItem(context, cubit, state, index),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 0.5,
                                    ),
                                  ],
                                ),
                            separatorBuilder: (context, index) => getEmptyWidget(),
                            itemCount: cubit.filteredClerksModelList.length,
                          ),
                      ) else const Center(child: CircularProgressIndicator(color: Colors.teal, strokeWidth: 0.8,),),
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

  Widget listItem(BuildContext context, MonitorPermissionDetailsCubit cubit, state, int index) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return SlideInUp(
                            duration: const Duration(milliseconds: 500),
                            child: Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return CachedNetworkImage(
                                              fit: BoxFit.fill,
                                              imageUrl: cubit
                                                  .filteredClerksModelList[index]
                                                  .clerkImage!,
                                              height: double.infinity,
                                              width: double.infinity,
                                              placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                  CircularProgressIndicator(
                                                    color: Colors.teal,
                                                    strokeWidth: 0.8,
                                                  )),
                                              errorWidget: (context, url,
                                                  error) =>
                                              const Icon(Icons.error),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fill,
                                        imageUrl: cubit
                                            .filteredClerksModelList[index]
                                            .clerkImage!,
                                        height: MediaQuery.of(context)
                                            .size
                                            .height *
                                            0.55,
                                        width: double.infinity,
                                        placeholder: (context, url) =>
                                        const Center(
                                            child:
                                            CircularProgressIndicator(
                                              color: Colors.teal,
                                              strokeWidth: 0.8,
                                            )),
                                        errorWidget:
                                            (context, url, error) =>
                                        const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: ClipOval(
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: cubit.filteredClerksModelList[index].clerkImage!,
                    height: 50,
                    width: 50,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                          strokeWidth: 0.8,
                        )),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(width: 16,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cubit.filteredClerksModelList[index].clerkName!,
                      style: TextStyle(
                          color: Colors.teal[700],
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4,),
                    Text(
                      cubit.filteredClerksModelList[index].clerkJobName!,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => BlurryDialog("تنبيه", "هل تريد حذف هذه الصلاحية ؟", (){
                        cubit.deletePermissionFromClerk(cubit.filteredClerksModelList[index].clerkID!, widget.permissionID);
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

}
