abstract class CustomerRegisterStates{}

class CustomerRegisterInitialState extends CustomerRegisterStates{}

class CustomerRegisterChangePasswordVisibilityState extends CustomerRegisterStates{}

class CustomerRegisterChangeCityState extends CustomerRegisterStates{}

class CustomerRegisterChangePaperState extends CustomerRegisterStates{}

class CustomerRegisterLoadingState extends CustomerRegisterStates{}

class CustomerRegisterSuccessState extends CustomerRegisterStates{}

class CustomerRegisterErrorState extends CustomerRegisterStates{

  final String error;

  CustomerRegisterErrorState(this.error);

}
