import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/splash_states.dart';
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
                  fit: BoxFit.cover,
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
