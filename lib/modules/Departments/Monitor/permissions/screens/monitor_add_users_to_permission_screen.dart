import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/permissions/cubit/monitor_permission_details_cubit.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/permissions/cubit/monitor_permission_details_states.dart';

import '../../../../../shared/components.dart';
import '../../../../../shared/constants.dart';

class MonitorAddUsersToPermissionScreen extends StatefulWidget {
  const MonitorAddUsersToPermissionScreen({Key? key, required this.permissionID, required this.clerksModelIDList}) : super(key: key);

  final String permissionID;
  final List<String> clerksModelIDList;
  @override
  State<MonitorAddUsersToPermissionScreen> createState() => _MonitorAddUsersToPermissionScreenState();
}

class _MonitorAddUsersToPermissionScreenState extends State<MonitorAddUsersToPermissionScreen> {
  var searchController = TextEditingController();
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorPermissionDetailsCubit()..getUserData()..getUnGrantedClerks(widget.permissionID),
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
                              cubit.searchUser(value);
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
                      BuildCondition(
                        condition: !cubit.gotUnGrantedClerks,
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
                          itemCount: cubit.filteredClerkList.length,
                        ),
                      ),
                      !cubit.zeroUnGrantedClerks ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: defaultButton(function: (){
                          if (cubit.selectedClerksList.isNotEmpty) {
                            print("User ID ${cubit.userID} \n");
                            showDialog(
                                context: context,
                                builder: (context) => BlurryDialog("تنبيه", "هل انت متأكد ؟", (){
                                  showDialog(context: context, builder: (context) => const BlurryProgressDialog(title: 'جارى اضافة الموظفين ...'));
                                  cubit.addPermissionToClerk(widget.permissionID).then((value){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                })
                            );

                          } else {
                            showToast(
                                message: "يجب اختيار شخص واحد على الاقل",
                                length: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3);
                          }
                        }, text: "اضافة", background: Colors.teal),
                      ): getEmptyWidget(),
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
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        elevation: 2,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        shadowColor: Colors.black,
        child: InkWell(
          onTap: () {
            if (cubit.selectedClerksList
                .contains(cubit.filteredClerkList[index])) {
              print("Yeeeees\n");
              cubit.removeUserFromSelect(cubit.filteredClerkList[index]);
            } else {
              print("Nooooooo\n");
              cubit.addClerkToSelect(cubit.filteredClerkList[index]);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                BuildCondition(
                  condition: !cubit.gotUnGrantedClerks,
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                      strokeWidth: 0.8,
                    ),
                  ),
                  fallback: (context) => InkWell(
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
                                                      .filteredClerkList[index]
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
                                                .filteredClerkList[index]
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
                        imageUrl: cubit.filteredClerkList[index].clerkImage!,
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
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      cubit.filteredClerkList[index].clerkName,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: cubit.selectedClerksList
                        .contains(cubit.filteredClerkList[index])
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
                        : getEmptyWidget(),
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
