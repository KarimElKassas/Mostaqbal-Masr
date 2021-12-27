abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginChangePassVisibility extends LoginStates {}

class LoginNoInternetState extends LoginStates {}

class LoginLoadingSignIn extends LoginStates {}

class LoginSuccessState extends LoginStates {

  final String sectionName;

  LoginSuccessState(this.sectionName);

}

class LoginGetUserSectionSuccessState extends LoginStates {}

class LoginGetSectionNameSuccessState extends LoginStates {}

class LoginGetUserFormsSuccessState extends LoginStates {}

class LoginLogSuccessState extends LoginStates {}

class LoginLogErrorState extends LoginStates {}

class LoginNoUserState extends LoginStates {}

class LoginSharedPrefErrorState extends LoginStates {
  final String error;

  LoginSharedPrefErrorState(this.error);
}

class LoginGetUserSectionErrorState extends LoginStates {
  final String error;

  LoginGetUserSectionErrorState(this.error);
}

class LoginGetSectionNameErrorState extends LoginStates {
  final String error;

  LoginGetSectionNameErrorState(this.error);
}

class LoginGetUserFormsErrorState extends LoginStates {
  final String error;

  LoginGetUserFormsErrorState(this.error);
}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState(this.error);
}
