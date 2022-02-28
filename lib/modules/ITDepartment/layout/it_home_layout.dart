import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mostaqbal_masr/modules/Global/GroupChat/screens/display_groups_screen.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/cubit/home/home_cubit.dart';
import 'package:mostaqbal_masr/modules/ITDepartment/cubit/home/home_states.dart';

class ITHomeScreen extends StatelessWidget {
  const ITHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ITHomeCubit(),
      child: BlocConsumer<ITHomeCubit, ITHomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ITHomeCubit.get(context);

          return Scaffold(
              floatingActionButton: FadeInUp(
                  duration: const Duration(seconds: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        onPressed: () async {
                          cubit.navigateToCreateClerk(context);
                        },
                        child: const Icon(
                          IconlyBroken.addUser,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.teal[700],
                        elevation: 15.0,
                        heroTag: null,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          cubit.navigateToSelectUsers(context);
                        },
                        child: const Icon(
                          Icons.group_add_rounded,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.teal[700],
                        elevation: 15.0,
                        heroTag: null,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FloatingActionButton(
                        onPressed: () async {
                          cubit.logOut(context);
                        },
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.teal[700],
                        elevation: 15.0,
                        heroTag: null,
                      )
                    ],
                  ),
              ),
            floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            body: DisplayGroupsScreen(),
          );
        },
      ),
    );
  }
}
