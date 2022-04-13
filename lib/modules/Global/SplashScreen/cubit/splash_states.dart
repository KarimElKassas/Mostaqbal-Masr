abstract class SplashStates{}

class SplashInitialState extends SplashStates{}

class SplashSuccessCreateDirectoryState extends SplashStates{}

class SplashSuccessPermissionDeniedState extends SplashStates{}

class SplashSuccessNavigateState extends SplashStates{}

class SplashGetDepartmentManagerSuccessState extends SplashStates{}

class SplashGetDepartmentManagerErrorState extends SplashStates{
  final String error;

  SplashGetDepartmentManagerErrorState(this.error);
}

class SplashErrorNavigateState extends SplashStates{

  final String error;

  SplashErrorNavigateState(this.error);

}