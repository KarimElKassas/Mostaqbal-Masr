import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Global/Posts/screens/global_display_posts_screen.dart';
import 'package:mostaqbal_masr/modules/Global/SplashScreen/cubit/spash_states.dart';

class SplashCubit extends Cubit<SplashStates> {
  SplashCubit() : super(SplashInitialState());

  static SplashCubit get(context) => BlocProvider.of(context);

  double? loginLogID;

  Future<void> navigate(BuildContext context) async {

    await Future.delayed(const Duration(milliseconds: 4000), () {});

    navigateToDisplayPosts(context);
    emit(SplashSuccessNavigateState());
  }

  void navigateToDisplayPosts(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => GlobalDisplayPostsScreen()));
  }

}
