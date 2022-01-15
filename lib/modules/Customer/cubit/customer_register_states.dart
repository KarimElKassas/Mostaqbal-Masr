abstract class CustomerRegisterStates{}

class CustomerRegisterInitialState extends CustomerRegisterStates{}

class CustomerRegisterChangePasswordVisibilityState extends CustomerRegisterStates{}

class CustomerRegisterChangeCityBottomSheetState extends CustomerRegisterStates{}

class CustomerRegisterChangeRegionBottomSheetState extends CustomerRegisterStates{}

class CustomerRegisterChangeCityState extends CustomerRegisterStates{

  final String cityName;

  CustomerRegisterChangeCityState(this.cityName);

}

class CustomerRegisterGetCitiesSuccessState extends CustomerRegisterStates{}

class CustomerRegisterGetRegionsSuccessState extends CustomerRegisterStates{}

class CustomerRegisterChangePaperState extends CustomerRegisterStates{}

class CustomerRegisterLoadingState extends CustomerRegisterStates{}

class CustomerRegisterAddNameSuccessState extends CustomerRegisterStates{}

class CustomerRegisterAddPhoneSuccessState extends CustomerRegisterStates{}

class CustomerRegisterAddDocumentSuccessState extends CustomerRegisterStates{}

class CustomerRegisterAddClassificationPersonIDSuccessState extends CustomerRegisterStates{}

class CustomerRegisterSuccessState extends CustomerRegisterStates{}

class CustomerRegisterErrorState extends CustomerRegisterStates{

  final String error;

  CustomerRegisterErrorState(this.error);

}
class CustomerRegisterAddNameErrorState extends CustomerRegisterStates{

  final String error;

  CustomerRegisterAddNameErrorState(this.error);

}
class CustomerRegisterAddPhoneErrorState extends CustomerRegisterStates{

  final String error;

  CustomerRegisterAddPhoneErrorState(this.error);

}
class CustomerRegisterAddDocumentErrorState extends CustomerRegisterStates{

  final String error;

  CustomerRegisterAddDocumentErrorState(this.error);

}
class CustomerRegisterAddClassificationPersonIDErrorState extends CustomerRegisterStates{

  final String error;

  CustomerRegisterAddClassificationPersonIDErrorState(this.error);

}
class CustomerRegisterGetCitiesErrorState extends CustomerRegisterStates{

  final String error;

  CustomerRegisterGetCitiesErrorState(this.error);

}
class CustomerRegisterGetRegionsErrorState extends CustomerRegisterStates{

  final String error;

  CustomerRegisterGetRegionsErrorState(this.error);

}
