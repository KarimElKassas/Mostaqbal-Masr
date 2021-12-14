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
      create: (context) => SplashCubit(),
      child: BlocConsumer<SplashCubit, SplashStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = SplashCubit.get(context);

          cubit.navigate(context, LoginScreen());

          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: FadeInImage(
                height: 300,
                width: 300,
                fit: BoxFit.fill,
                fadeInDuration: Duration(seconds: 1),
                image: AssetImage('assets/images/logo.jpg'),
                placeholder: AssetImage("assets/images/black_back.png"),
              ),
            ),
          );
        },
      ),
    );
  }
}
