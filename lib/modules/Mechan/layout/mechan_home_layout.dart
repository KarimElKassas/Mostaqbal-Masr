import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Mechan/layout/cubit/mechan_home_cubit.dart';
import 'package:mostaqbal_masr/modules/Mechan/layout/cubit/mechan_home_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class MechanHomeLayout extends StatelessWidget {
  const MechanHomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => MechanHomeCubit(),
      child: BlocConsumer<MechanHomeCubit, MechanHomeStates>(
        listener: (context, state){},
        builder: (context, state){

          var cubit = MechanHomeCubit.get(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("الميكنة الزراعية"),
                      const SizedBox(height: 12.0,),
                      defaultButton(function: (){
                          cubit.logOut(context);
                      }, text: "تسجيل الخروج")
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

}
