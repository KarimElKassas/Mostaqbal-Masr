abstract class ClerkLoginStates{}

class ClerkLoginInitialState extends ClerkLoginStates{}

class ClerkLoginChangePassVisibility extends ClerkLoginStates {}

class ClerkLoginNoInternetState extends ClerkLoginStates {}

class ClerkLoginLoadingSignIn extends ClerkLoginStates {}

class ClerkLoginUpdateLogSuccess extends ClerkLoginStates {}

class ClerkLoginUpdateLogError extends ClerkLoginStates {

  final String error;

  ClerkLoginUpdateLogError(this.error);

}

class ClerkLoginSuccessState extends ClerkLoginStates {}

class ClerkLoginGetClerkDataSuccessState extends ClerkLoginStates {}

class ClerkLoginGetUserSectionSuccessState extends ClerkLoginStates {}

class ClerkLoginGetUserPersonIDSuccessState extends ClerkLoginStates {}

class ClerkLoginGetUserDataSuccessState extends ClerkLoginStates {}

class ClerkLoginGetSectionNameSuccessState extends ClerkLoginStates {}

class ClerkLoginGetUserFormsSuccessState extends ClerkLoginStates {}

class ClerkLoginLogSuccessState extends ClerkLoginStates {}

class ClerkLoginLogErrorState extends ClerkLoginStates {}

class ClerkLoginNoUserState extends ClerkLoginStates {}

class ClerkLoginSharedPrefErrorState extends ClerkLoginStates {
  final String error;

  ClerkLoginSharedPrefErrorState(this.error);
}

class ClerkLoginGetClerkDataErrorState extends ClerkLoginStates {
  final String error;

  ClerkLoginGetClerkDataErrorState(this.error);
}

class ClerkLoginGetUserSectionErrorState extends ClerkLoginStates {
  final String error;

  ClerkLoginGetUserSectionErrorState(this.error);
}

class ClerkLoginGetSectionNameErrorState extends ClerkLoginStates {
  final String error;

  ClerkLoginGetSectionNameErrorState(this.error);
}

class ClerkLoginGetUserFormsErrorState extends ClerkLoginStates {
  final String error;

  ClerkLoginGetUserFormsErrorState(this.error);
}
class ClerkLoginGetPersonIDErrorState extends ClerkLoginStates {
  final String error;

  ClerkLoginGetPersonIDErrorState(this.error);
}
class ClerkLoginGetUserDataErrorState extends ClerkLoginStates {
  final String error;

  ClerkLoginGetUserDataErrorState(this.error);
}

class ClerkLoginErrorState extends ClerkLoginStates {
  final String error;

  ClerkLoginErrorState(this.error);
}
