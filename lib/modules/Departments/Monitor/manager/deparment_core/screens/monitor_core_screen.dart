import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/deparment_core/cubit/monitor_core_cubit.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/deparment_core/cubit/monitor_core_states.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/deparment_core/screens/core_clerk_details_screen.dart';

class MonitorCoreScreen extends StatelessWidget {
  const MonitorCoreScreen({Key? key, required this.departmentID, required this.departmentName}) : super(key: key);

  final String departmentID;
  final String departmentName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorCoreCubit()..getFilteredClerks(departmentID, 0),
      child: BlocConsumer<MonitorCoreCubit, MonitorCoreStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = MonitorCoreCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.teal,
                statusBarIconBrightness: Brightness.light,
                // For Android (dark icons)
                statusBarBrightness: Brightness.dark, // For iOS (dark icons)
              ),
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                "قوة $departmentName",
                style: const TextStyle(
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
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 80,
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) =>
                                personTypeItem(context, cubit, state, index),
                            separatorBuilder: (context, index) =>
                            const SizedBox(
                              width: 2,
                            ),
                            itemCount: cubit.personTypeNameList.length,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      cubit.gotClerks ? (!cubit.zeroClerks ? ListView.separated(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            listItem(context, cubit, state, index),
                        separatorBuilder: (context, index) =>
                        const SizedBox(
                          width: 2,
                        ),
                        itemCount: cubit.filteredClerksModelList.length,
                      ) : Center(child: Text('لا يوجد ${cubit.selectedPersonTypeName} بالإدارة', style: TextStyle(color: Colors.teal[700], fontSize: 16),),))  : Center(child: CircularProgressIndicator(color: Colors.teal[700], strokeWidth: 0.8,),),
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

  Widget personTypeItem(BuildContext context, MonitorCoreCubit cubit, state, int index){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2),
      child: InkWell(
        onTap: () {
          if(cubit.selectedPersonTypeID != cubit.personTypeNameList[index].typeID){
            cubit.changeFilter(cubit.personTypeNameList[index].typeID, cubit.personTypeNameList[index].typeName);
            cubit.getFilteredClerks("1022", cubit.personTypeNameList[index].typeID);
          }
        },
        splashColor: Colors.white,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 5,
          child: Card(
            semanticContainer: true,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
            shadowColor: Colors.black,
            color: cubit.selectedPersonTypeID == cubit.personTypeNameList[index].typeID
                ? Colors.teal.shade500
                : Colors.white,
            child: Center(
                child: Text(
                  cubit.personTypeNameList[index].typeName,
                  style: TextStyle(
                      color: cubit.selectedPersonTypeID == cubit.personTypeNameList[index].typeID
                          ? Colors.white
                          : Colors.teal.shade500,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,),
                  textAlign: TextAlign.center,
                )),
          ),
        ),
      ),
    );
  }

  Widget listItem(BuildContext context, MonitorCoreCubit cubit, state, int index) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
          elevation: 2,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          shadowColor: Colors.black,
          child: InkWell(
            onTap: () {
              //print("USER PHONE NAVIGATE : ${cubit.filteredClerksModelList[index].personNumber}\n");
              cubit.navigateTo(context, CoreClerkDetailsScreen(
                  userID: cubit.filteredClerksModelList[index].clerkID!,
                  userName: cubit.filteredClerksModelList[index].clerkName!,
                  userPhone: cubit.filteredClerksModelList[index].personPhone!,
                  userImageUrl: cubit.filteredClerksModelList[index].clerkImage!,
                  userDocNumber: cubit.filteredClerksModelList[index].personNumber!,
                  userJob: cubit.filteredClerksModelList[index].jobName!,
                  onFirebase: cubit.filteredClerksModelList[index].OnFirebase!,
                  userToken: cubit.filteredClerksModelList[index].token??"",));
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
                                                  fit: BoxFit.scaleDown,
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
                                          child: Container(
                                            color: Colors.black,
                                            child: CachedNetworkImage(
                                              fit: BoxFit.scaleDown,
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
                        fit: BoxFit.scaleDown,
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
                    width: 4.0,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cubit.filteredClerksModelList[index].clerkName??"",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6,),
                          Text(
                            "${cubit.filteredClerksModelList[index].personNumber}",
                            style: const TextStyle(
                                color: Colors.teal,
                                fontSize: 12,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• ${cubit.filteredClerksModelList[index].userStatus??""}",
                        style: TextStyle(
                            color: cubit.filteredClerksModelList[index].userStatus == "غير لائق" ? Colors.red : Colors.teal,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6,),
                      Text(
                        "• ${cubit.filteredClerksModelList[index].jobName??""}",
                        style: const TextStyle(
                            color: Colors.teal,
                            fontSize: 10,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
