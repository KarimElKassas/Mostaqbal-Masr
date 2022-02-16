import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Global/Login/login_screen.dart';
import 'package:mostaqbal_masr/network/remote/dio_helper.dart';

import 'cubit/spash_states.dart';
import 'cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..createMediaFolder()..navigate(context),
      child: BlocConsumer<SplashCubit, SplashStates>(
        listener: (context, state) {},
        builder: (context, state){

          return  Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: FadeInDown(
                duration: const Duration(milliseconds: 2000),
                child: const FadeInImage(
                  height: 300,
                  width: 300,
                  fit: BoxFit.fill,
                  fadeInDuration: Duration(milliseconds: 1500),
                  image: AssetImage('assets/images/logo.jpg'),
                  placeholder: AssetImage("assets/images/black_back.png"),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
