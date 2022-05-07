import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/models/firebase_clerk_model.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/home/cubit/monitor_manager_home_cubit.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/home/cubit/monitor_manager_home_states.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

import 'monitor_officer_permissions_screen.dart';

class MonitorDisplayUsersScreen extends StatefulWidget {
  const MonitorDisplayUsersScreen({Key? key, required this.clerksList}) : super(key: key);

  final List<ClerkFirebaseModel> clerksList;

  @override
  State<MonitorDisplayUsersScreen> createState() =>
      _MonitorDisplayUsersScreenState();
}

class _MonitorDisplayUsersScreenState extends State<MonitorDisplayUsersScreen> {
  var searchController = TextEditingController();

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorManagerHomeCubit()..getUserData()..getManagementClerks(),
      child: BlocConsumer<MonitorManagerHomeCubit, MonitorManagerHomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = MonitorManagerHomeCubit.get(context);

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
                       ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) =>
                              listItem(context, cubit, state, index),
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 10.0),
                          itemCount: cubit.filteredClerksModelList.length,
                        ),
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

  Widget listItem(BuildContext context, MonitorManagerHomeCubit cubit, state, int index) {
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
            print("USER PHONE NAVIGATE : ${cubit.filteredClerksModelList[index].personNumber}\n");
              cubit.navigateTo(context, MonitorOfficerPermissionsScreen(officerID: cubit.filteredClerksModelList[index].personNumber!));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
                const SizedBox(
                  width: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    cubit.filteredClerksModelList[index].clerkName??"",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
