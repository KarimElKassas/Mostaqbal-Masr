abstract class ClerkRegisterStates{}

class ClerkRegisterInitialState extends ClerkRegisterStates{}

class ClerkRegisterChangeImageState extends ClerkRegisterStates{}

class ClerkRegisterChangePasswordVisibilityState extends ClerkRegisterStates{}

class ClerkRegisterChangeCityBottomSheetState extends ClerkRegisterStates{}

class ClerkRegisterChangeRegionBottomSheetState extends ClerkRegisterStates{}

class ClerkRegisterChangeCityState extends ClerkRegisterStates{

  final String cityName;

  ClerkRegisterChangeCityState(this.cityName);

}

class ClerkRegisterLoadingClerksState extends ClerkRegisterStates{}

class ClerkRegisterClerkExistState extends ClerkRegisterStates{}

class ClerkRegisterLoadingUploadClerksState extends ClerkRegisterStates{}

class ClerkRegisterGetClerksSuccessState extends ClerkRegisterStates{}

class ClerkRegisterNoClerkFoundState extends ClerkRegisterStates{}

class ClerkRegisterGetRegionsSuccessState extends ClerkRegisterStates{}

class ClerkRegisterChangePaperState extends ClerkRegisterStates{}

class ClerkRegisterLoadingState extends ClerkRegisterStates{}

class ClerkRegisterAddNameSuccessState extends ClerkRegisterStates{}

class ClerkRegisterAddPhoneSuccessState extends ClerkRegisterStates{}

class ClerkRegisterAddDocumentSuccessState extends ClerkRegisterStates{}

class ClerkRegisterAddClassificationPersonIDSuccessState extends ClerkRegisterStates{}

class ClerkRegisterSuccessState extends ClerkRegisterStates{}

class ClerkRegisterNavigateSuccessState extends ClerkRegisterStates{}

class ClerkRegisterErrorState extends ClerkRegisterStates{

  final String error;

  ClerkRegisterErrorState(this.error);

}
class ClerkRegisterAddNameErrorState extends ClerkRegisterStates{

  final String error;

  ClerkRegisterAddNameErrorState(this.error);

}
class ClerkRegisterAddPhoneErrorState extends ClerkRegisterStates{

  final String error;

  ClerkRegisterAddPhoneErrorState(this.error);

}
class ClerkRegisterAddDocumentErrorState extends ClerkRegisterStates{

  final String error;

  ClerkRegisterAddDocumentErrorState(this.error);

}
class ClerkRegisterAddClassificationPersonIDErrorState extends ClerkRegisterStates{

  final String error;

  ClerkRegisterAddClassificationPersonIDErrorState(this.error);

}
class ClerkRegisterGetClerksErrorState extends ClerkRegisterStates{

  final String error;

  ClerkRegisterGetClerksErrorState(this.error);

}
class ClerkRegisterGetRegionsErrorState extends ClerkRegisterStates{

  final String error;

  ClerkRegisterGetRegionsErrorState(this.error);

}
