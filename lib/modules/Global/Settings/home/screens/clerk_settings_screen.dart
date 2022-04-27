import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../../../../shared/constants.dart';
import '../../personal/screens/clerk_personal_screen.dart';
import '../cubit/clerk_settings_cubit.dart';
import '../cubit/clerk_settings_states.dart';

class ClerkSettingsScreen extends StatefulWidget {
  const ClerkSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ClerkSettingsScreen> createState() => _ClerkSettingsScreenState();
}

class _ClerkSettingsScreenState extends State<ClerkSettingsScreen> {
  //final timerController = TimerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClerkSettingsCubit()..getUserData(),
      child: BlocConsumer<ClerkSettingsCubit, ClerkSettingsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ClerkSettingsCubit.get(context);

          return Scaffold(
              appBar: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.white,
                  statusBarIconBrightness: Brightness.dark,
                  // For Android (dark icons)
                  statusBarBrightness: Brightness.light, // For iOS (dark icons)
                ),
                toolbarHeight: 0,
                elevation: 0,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
              ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SafeArea(
                child: Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 0.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      shadowColor: Colors.black,
                      child: InkWell(
                        onTap: () async{
                          await cubit.getUserData();
                          cubit.navigate(context, ClerkPersonalScreen(
                            userID: cubit.userID,
                            userName: cubit.userName,
                            userPhone: cubit.userPhone,
                            userPassword: cubit.userPassword,
                            userImageUrl: cubit.userImage,
                            userDocNumber: cubit.userNumber,
                          ));
                        },
                        splashColor: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 2.0,
                              ),
                              Icon(
                                IconlyBroken.user3,
                                color: Colors.teal[700],
                                size: 28,
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              Text(
                                "الملف الشخصى",
                                style: TextStyle(
                                    color: Colors.teal[700],
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 0.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      shadowColor: Colors.black,
                      child: InkWell(
                        onTap: () {
                          //cubit.goToConversation(context, ConversationScreen(userID: cubit.userList[index].userID,userName: cubit.userList[index].userName,userImage: cubit.userImage!, userToken: cubit.userList[index].userToken,));
                        },
                        splashColor: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 2.0,
                              ),
                              Icon(
                                IconlyBroken.infoCircle,
                                color: Colors.teal[700],
                                size: 28,
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              Text(
                                "نبذة عن المشروع",
                                style: TextStyle(
                                    color: Colors.teal[700],
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 0.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      shadowColor: Colors.black,
                      child: InkWell(
                        onTap: () {
                          //cubit.goToConversation(context, ConversationScreen(userID: cubit.userList[index].userID,userName: cubit.userList[index].userName,userImage: cubit.userImage!, userToken: cubit.userList[index].userToken,));
                        },
                        splashColor: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 2.0,
                              ),
                              Icon(
                                IconlyBroken.edit,
                                color: Colors.teal[700],
                                size: 28,
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              Text(
                                "تغيير اللغة",
                                style: TextStyle(
                                    color: Colors.teal[700],
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 0.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      shadowColor: Colors.black,
                      child: InkWell(
                        onTap: () {
                          //cubit.goToConversation(context, ConversationScreen(userID: cubit.userList[index].userID,userName: cubit.userList[index].userName,userImage: cubit.userImage!, userToken: cubit.userList[index].userToken,));
                        },
                        splashColor: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 2.0,
                              ),
                              Icon(
                                IconlyBroken.star,
                                color: Colors.teal[700],
                                size: 28,
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              Text(
                                "تقييم التطبيق",
                                style: TextStyle(
                                    color: Colors.teal[700],
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 0.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      shadowColor: Colors.black,
                      child: InkWell(
                        onTap: () {
                          showDialog(context: context, builder: (BuildContext context) => BlurryDialog("تنبيه", "هل تريد تسجيل الخروج ؟", (){cubit.logOut(context);}) );
                        },
                        splashColor: Colors.white70,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 2.0,
                              ),
                              Icon(
                                IconlyBroken.logout,
                                color: Colors.teal[700],
                                size: 28,
                              ),
                              const SizedBox(
                                width: 12.0,
                              ),
                              Text(
                                "تسجيل الخروج",
                                style: TextStyle(
                                    color: Colors.teal[700],
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
