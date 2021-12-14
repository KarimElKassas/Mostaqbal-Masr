abstract class SplashStates{}

class SplashInitialState extends SplashStates{}

class SplashSuccessNavigateState extends SplashStates{}

class SplashErrorNavigateState extends SplashStates{

  final String error;

  SplashErrorNavigateState(this.error);

}