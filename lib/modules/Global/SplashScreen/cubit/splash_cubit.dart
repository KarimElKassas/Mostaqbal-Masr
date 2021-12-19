import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaqbal_masr/modules/Global/SplashScreen/cubit/spash_states.dart';
import 'package:mostaqbal_masr/shared/components.dart';

class SplashCubit extends Cubit<SplashStates>{

  SplashCubit() : super(SplashInitialState());

  static SplashCubit get(context) => BlocProvider.of(context);

  void navigate(BuildContext context, Widget route)async {

    await Future.delayed(const Duration(milliseconds: 4000),(){});

    navigateAndFinish(context, route);
    emit(SplashSuccessNavigateState());

  }

}