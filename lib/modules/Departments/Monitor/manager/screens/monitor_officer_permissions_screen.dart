import 'package:animate_do/animate_do.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/cubit/monitor_officer_permission_cubit.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/cubit/monitor_officer_permission_states.dart';
import 'package:mostaqbal_masr/modules/Departments/Monitor/manager/screens/monitor_add_permission_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

class MonitorOfficerPermissionsScreen extends StatefulWidget {
  const MonitorOfficerPermissionsScreen({Key? key, required this.officerID}) : super(key: key);

  final String officerID;

  @override
  State<MonitorOfficerPermissionsScreen> createState() => _MonitorOfficerPermissionsScreenState();
}

class _MonitorOfficerPermissionsScreenState extends State<MonitorOfficerPermissionsScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);

    noInternet();

    print("app in initState\n");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed\n");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive\n");
        break;
      case AppLifecycleState.paused:
        print("app in paused\n");
        break;
      case AppLifecycleState.detached:
      //await SocialHomeCubit.get(context).logOut(context);
      //await logOut();
        print("app in detached\n");
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MonitorOfficerPermissionCubit()..getUserData()..getPermissions(widget.officerID),
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
              body: BuildCondition(
                condition: !cubit.gotPermission,
                builder: (context) => Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal[700],
                    strokeWidth: 0.8,
                  ),
                ),
                fallback: (_){
                  return cubit.grantedPermissionModelList.isNotEmpty ? hasPermissions(context, cubit, state) : zeroPermissions(context, cubit);
                }
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
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.08,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  cubit.grantedPermissionModelList[index].permissionDescription,
                  style: TextStyle(
                      color: Colors.teal[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (context) => BlurryDialog("تنبيه", "هل تريد حذف هذه الصلاحية ؟", (){cubit.deletePermissionFromClerk(widget.officerID, cubit.grantedPermissionModelList[index].permissionID);})
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

  Widget hasPermissions(BuildContext context, MonitorOfficerPermissionCubit cubit, state) {
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
            itemCount: cubit.grantedPermissionModelList.length,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: cubit.unGrantedPermissionModelList.isNotEmpty ? InkWell(
            onTap: ()async {
                //Navigator.push(context,MaterialPageRoute(builder: (context) => MonitorAddPermissionsScreen(officerID: widget.officerID, unGrantedPermissionModelList: cubit.unGrantedPermissionModelList))).then((value) {cubit.getPermissions(widget.officerID);});
                cubit.navigateTo(context, MonitorAddPermissionsScreen(officerID: widget.officerID, unGrantedPermissionModelList: cubit.unGrantedPermissionModelList), widget.officerID);
            },
            splashColor: Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.teal.shade500,
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
          ) : Center(child: Text("هذا الموظف لديه جميع الصلاحيات", style: TextStyle(color: Colors.teal[700], fontSize: 14),),),
        ),
      ],
    );
  }

  Widget zeroPermissions(BuildContext context, MonitorOfficerPermissionCubit cubit) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Center(
            child: Text(
              "هذا الموظف لا يمتلك \n اى صلاحيات حتى الان",
              style: TextStyle(
                  color: Colors.teal[700], fontWeight: FontWeight.bold, fontSize: 16, height: 1.5),
            )),
        Positioned(
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                cubit.navigateTo(context, MonitorAddPermissionsScreen(officerID: widget.officerID, unGrantedPermissionModelList: cubit.unGrantedPermissionModelList), widget.officerID);
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
