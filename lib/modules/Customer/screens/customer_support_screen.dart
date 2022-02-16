import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_support_cubit.dart';
import 'package:mostaqbal_masr/modules/Customer/cubit/customer_support_states.dart';
import 'package:mostaqbal_masr/modules/Customer/screens/customer_display_chats_screen.dart';
import 'package:mostaqbal_masr/modules/Customer/screens/customer_login_screen.dart';
import 'package:mostaqbal_masr/modules/Customer/screens/customer_register_screen.dart';
import 'package:mostaqbal_masr/modules/Global/Chat/conversation_screen.dart';
import 'package:mostaqbal_masr/shared/components.dart';
import 'package:mostaqbal_masr/shared/constants.dart';

class CustomerSupportScreen extends StatefulWidget {
  const CustomerSupportScreen({Key? key}) : super(key: key);

  @override
  State<CustomerSupportScreen> createState() => _CustomerSupportScreenState();
}

class _CustomerSupportScreenState extends State<CustomerSupportScreen> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerSupportCubit, CustomerSupportStates>(
        listener: (context, state){

        },
        builder: (context, state){

          var cubit = CustomerSupportCubit.get(context);

          return Scaffold(
            body: ValueListenableBuilder(
                 valueListenable: customerState,
                 builder: (context, value, widget){
                   return value == 1 ? const CustomerDisplayChats() :
                   Center(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         defaultButton(
                             function: (){
                               cubit.navigate(context, CustomerLoginScreen());
                             },
                             text: "تسجيل الدخول",
                             width: 150,
                             background: Colors.teal,
                             textColor: Colors.white
                         ),
                         defaultButton(
                             function: (){
                               cubit.navigate(context, CustomerRegisterScreen());
                             },
                             text: "انشاء حساب",
                             width: 150,
                             background: Colors.grey,
                             textColor: Colors.black
                         )

                       ],
                     ),
                   );
                 },
               ),
          );
        },
    );
  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);
    setState(() {

    });
    print("app in initstate \n");

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
}
