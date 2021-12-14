abstract class LoginStates{}

class LoginInitialState extends LoginStates{}

class LoginChangePassVisibility extends LoginStates{}

class LoginLoadingSignIn extends LoginStates{}

class LoginSuccessState extends LoginStates{}

class LoginSharedPrefErrorState extends LoginStates{

  final String error;

  LoginSharedPrefErrorState(this.error);

}

class LoginLogSuccessState extends LoginStates{}

class LoginLogErrorState extends LoginStates{}

class LoginNoUserState extends LoginStates{}

class LoginErrorState extends LoginStates{

  final String error;

  LoginErrorState(this.error);

}